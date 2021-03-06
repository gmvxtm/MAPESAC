using BaseArchitecture.Application.IService.Table  ;
using BaseArchitecture.Application.TransferObject.Response.Common;
using BaseArchitecture.Repository.IData.NonTransactional;
using BaseArchitecture.Repository.IData.Transactional;
using System.Collections.Generic;
using System.Linq;
using BaseArchitecture.Repository.Entity;
using BaseArchitecture.Cross.SystemVariable.Util;
using BaseArchitecture.Repository.Entity.Tables;
using System.Transactions;
using System;
using BaseArchitecture.Application.IService.Mail;
using Newtonsoft.Json;
using BaseArchitecture.Cross.SystemVariable.Constant;

namespace BaseArchitecture.Application.Service.Table
{
    public class TableServices : ITableService
    {
        //public IDemoQuery DemoQuery { get; set; }
        //public IDemoTransaction DemoTransaction { get; set; }
        public ITableQuery TableQuery { get; set; }
        public ITableTransaction TableTransaction { get; set; }
        public IMailService MailService { get; set; }

        /// <summary>
        ///     Method that get MasterTableResponse by IdMasterTable
        /// </summary>
        /// <param name="masterTableRequest">Params entry</param>
        /// <remarks>
        ///     The method GetMasterById get list MasterTable and filter by IdMasterTable
        /// </remarks>
        /// <returns>Return entity MasterTableResponse</returns>
        public MasterTableEntity GetMasterById(MasterTableEntity masterTableRequest)
        {
            var result = GetAllMaster();
            return result.FirstOrDefault(x => x.IdMasterTable == masterTableRequest.IdMasterTable);
        }

        public Response<IEnumerable<MasterTableEntity>> ListMasterTable(MasterTableEntity masterTableRequest)
        {
            var result = GetAllMaster();
            var masterTableResponses =
                result.Where(x => x.IdMasterTableParent == masterTableRequest.IdMasterTableParent).ToList();

            return new Response<IEnumerable<MasterTableEntity>> { Value = masterTableResponses };
        }

        public Response<IEnumerable<MasterTableEntity>> ListMasterTableByValue(MasterTableEntity masterTableRequest)
        {
            var result = GetAllMaster();
            var masterTableResponses = result.Where(x => x.IdMasterTableParent == masterTableRequest.IdMasterTableParent
                                                         && x.Value == masterTableRequest.Value).ToList();

            return new Response<IEnumerable<MasterTableEntity>> { Value = masterTableResponses };
        }

        private IEnumerable<MasterTableEntity> GetAllMaster()
        {
            return TableQuery.ListMasterTable();
        }

        public Response<MenuLogin> Login(UserEntity userRequest)
        {
            userRequest.Password = AesCryptography.CryptAES(userRequest.Password);
            var result = TableQuery.Login(userRequest);
            return result;
        }

        public Response<IEnumerable<ProductEntity>> ListProduct()
        {
            var result = TableQuery.ListProduct();
            return new Response<IEnumerable<ProductEntity>> { Value = result };
        }

        public Response<OrderListByLocationEntity> ListOrderByLocation(OrderEntity orderRequest)
        {
            var result = TableQuery.ListOrderByLocation(orderRequest);
            return result;
        }

        public Response<SubOrderListByLocationEntity> ListSubOrderByLocation(OrderEntity orderRequest)
        {

            var result = TableQuery.ListSubOrderByLocation(orderRequest);
            foreach (var item in result.Value.ListSubOrderEntity.ToList())
            {
                item.ListSubOrderFlowDetailEntity = result.Value.ListSubOrderFlowDetailEntity.Where(x => x.IdSubOrderFlow == item.IdSubOrderFlow);

            }
            return result;
        }

        public Response<string> MergeOrder(OrderEntity orderRequest)
        {
            var result = new Response<string>();
            using (var transaction = new TransactionScope())
            {
                try
                {
                    TableTransaction.MergeCustomer(orderRequest.CustomerEntity);
                    orderRequest.IdCustomer = orderRequest.CustomerEntity.IdCustomer;
                    orderRequest.LocationOrder = "00201"; //Encargado de Ventas
                    TableTransaction.MergeOrder(orderRequest);
                    TableTransaction.GenerateOrderFlow(orderRequest);
                    foreach (var itemOrderDetail in orderRequest.ListOrderDetail)
                    {
                        itemOrderDetail.IdOrder = orderRequest.IdOrder;
                        itemOrderDetail.IdOrderDetail = Guid.NewGuid();
                        itemOrderDetail.Description = itemOrderDetail.Description == null ? "" : itemOrderDetail.Description;
                        TableTransaction.MergeOrderDetail(itemOrderDetail);
                    }
                    TableTransaction.GenerateSubOrderFlow(orderRequest);
                    var resultQuery = TableQuery.ListOrder();
                    var codeOrder = resultQuery.Value.ListOrderEntity.ToList().Find(x => x.IdOrder == orderRequest.IdOrder).CodeOrder;
                    result = new Response<string>(codeOrder);

                    //correo
                    var body = MailService.GetHtml(codeOrder);
                    var rpsta = MailService.SendEmail(orderRequest.CustomerEntity.Email, body);
                    transaction.Complete();
                }
                catch (Exception e)
                {
                    result = new Response<string>("Error" + e.Message);
                }
            }
            return result;
        }

        public Response<UbiEntity> ListUbi()
        {
            var result = TableQuery.ListUbi();
            return result;
        }

        public Response<OrderListEntity> ListOrder()
        {            
            var result = TableQuery.ListOrder();
            return result;
        }

        public Response<OrderEntity> GetOrderByCodeOrder(OrderEntity orderRequest)
        {
            var result = TableQuery.GetOrderByCodeOrder(orderRequest);
            return result;
        }

        public Response<string> UpdOrderFlow(OrderFlowEntity orderFlowRequest)
        {
            Response<string> result = new Response<string>(string.Empty);
            if (orderFlowRequest.Answer == "00602" && orderFlowRequest.LocationOrder == "00201")
            {
                //Obtiene la orden y su detalle
                var orderDetail = TableQuery.GetOrderByIdOrder(orderFlowRequest.IdOrder);
                /*Inicio de validación de stock para pedido*/
                List<ProductJsonEntity> listProductEntityJson = new List<ProductJsonEntity>();
                foreach (var item in orderDetail.Value.ListOrderDetail)
                {
                    var itemProductEntityJson = new ProductJsonEntity();
                    itemProductEntityJson.IdProduct = item.IdProduct;
                    itemProductEntityJson.Quantity = int.Parse(item.Quantity.ToString());
                    listProductEntityJson.Add(itemProductEntityJson);
                }
                var validateStock = TableTransaction.ValidateAndUpdateStock(JsonConvert.SerializeObject(listProductEntityJson));
                /*Inicio de envío de correo al encargado de almacén cuando el stock está por debajo del mínimo*/
                if (validateStock.Value.ListProductOutOfStock.Count() > 0 &&
                    !string.IsNullOrEmpty(validateStock.Value.ListProductOutOfStock.FirstOrDefault().Name))
                {
                    var bodyMailOutOfStock = MailService.GetHtmlOutOfStock(validateStock.Value.ListProductOutOfStock.ToList());
                    var respuesta = MailService.SendEmail(AppSettingValue.EmailLogicticResponsible, bodyMailOutOfStock);
                }
                if (validateStock.Value.ValidateStock.Validate == true)
                {
                    result = new Response<string>(TableTransaction.UpdOrderFlow(orderFlowRequest).ToString());
                }
                else
                {
                    result = new Response<string>("Error: No hay stock suficiente para la producción del pedido");
                }
            }
            else
            {
                result = new Response<string>(TableTransaction.UpdOrderFlow(orderFlowRequest).ToString());
            }
            return result;
        }

        public Response<int> UpdSubOrderFlow(OrderFlowEntity orderFlowRequest)
        {
            var result = TableTransaction.UpdSubOrderFlow(orderFlowRequest);
            return result;
        }

        public Response<IEnumerable<SupplyEntity>> ListSuppliesByProduct(ProductEntity suppliesByProductRequest)
        {
            var result = TableQuery.ListSuppliesByProduct(suppliesByProductRequest);
            return new Response<IEnumerable<SupplyEntity>> { Value = result };
        }

        public Response<int> UpdDecrease(DecreaseEntity decreaseRequest)
        {
            var result = TableTransaction.UpdDecrease(decreaseRequest);
            return result;
        }

        public Response<IEnumerable<SupplyEntity>> ListSupplies()
        {
            var result = TableQuery.ListSupplies();
            return new Response<IEnumerable<SupplyEntity>> { Value = result };
        }

        public Response<IEnumerable<SupplierEntity>> ListSuppliersByIdSupply(SupplyEntity supplyRequest)
        {
            var result = TableQuery.ListSuppliersByIdSupply(supplyRequest);
            return new Response<IEnumerable<SupplierEntity>> { Value = result };
        }

        public Response<int> InsBuySupply(BuySupplyEntity buySupplyRequest)
        {
            var result = TableTransaction.IndBuySupply(buySupplyRequest);
            return result;
        }

        public Response<IEnumerable<RptListProductQuantityEntity>> RptListProductQuantity()
        {
            var result = TableQuery.RptListProductQuantity();
            return new Response<IEnumerable<RptListProductQuantityEntity>> { Value = result };
        }

        public Response<IEnumerable<RptListOrderQuantityEntity>> RptListOrderQuantity()
        {
            var result = TableQuery.RptListOrderQuantity();
            return new Response<IEnumerable<RptListOrderQuantityEntity>> { Value = result };
        }

        public Response<IEnumerable<RptListOrderQuantityStatusEntity>> RptListOrderQuantityStatus()
        {
            var result = TableQuery.RptListOrderQuantityStatus();
            return new Response<IEnumerable<RptListOrderQuantityStatusEntity>> { Value = result };
        }

        public Response<IEnumerable<RptListOrderQuantityStatusDeliveryEntity>> RptListOrderQuantityStatusDelivery()
        {
            var result = TableQuery.RptListOrderQuantityStatusDelivery();
            return new Response<IEnumerable<RptListOrderQuantityStatusDeliveryEntity>> { Value = result };
        }

        public Response<IEnumerable<RptListSuppliesMostUsedByMonthEntity>> RptListSuppliesMostUsedByMonth()
        {
            var result = TableQuery.RptListSuppliesMostUsedByMonth();
            return new Response<IEnumerable<RptListSuppliesMostUsedByMonthEntity>> { Value = result };
        }

        public Response<IEnumerable<RptListSuppliesDecreaseByMonthEntity>> RptListSuppliesDecreaseByMonth()
        {
            var result = TableQuery.RptListSuppliesDecreaseByMonth();
            return new Response<IEnumerable<RptListSuppliesDecreaseByMonthEntity>> { Value = result };
        }

        public Response<IEnumerable<RptGanttOrdersLastMonthEntity>> RptGanttOrdersLastMonth()
        {
            var result = TableQuery.RptGanttOrdersLastMonth();
            return new Response<IEnumerable<RptGanttOrdersLastMonthEntity>> { Value = result };
        }

        public Response<int> UpdSubOrderFlowDetail(SubOrderFlowDetailEntity subOrderFlowDetailRequest)
        {
            var result = TableTransaction.UpdSubOrderFlowDetail(subOrderFlowDetailRequest);
            return result;
        }
    }
}