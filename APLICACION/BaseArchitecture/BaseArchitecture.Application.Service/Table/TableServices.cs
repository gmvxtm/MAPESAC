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

namespace BaseArchitecture.Application.Service.Table
{
    public class TableServices : ITableService
    {
        //public IDemoQuery DemoQuery { get; set; }
        //public IDemoTransaction DemoTransaction { get; set; }
        public ITableQuery TableQuery { get; set; }
        public ITableTransaction TableTransaction { get; set; }


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

        public Response<int> MergeOrder(OrderEntity orderRequest)
        {
            var result = new Response<int>(1);
            using (var transaction = new TransactionScope())
            {
                try
                {
                    TableTransaction.MergeCustomer(orderRequest.CustomerEntity);
                    orderRequest.IdCustomer = orderRequest.CustomerEntity.IdCustomer;
                    TableTransaction.MergeOrder(orderRequest);
                                        
                    foreach (var itemOrderDetail in orderRequest.ListOrderDetail)
                    {
                        itemOrderDetail.IdOrder = orderRequest.IdOrder;
                        itemOrderDetail.IdOrderDetail = Guid.NewGuid();
                        itemOrderDetail.Description = itemOrderDetail.Description == null ? "" : itemOrderDetail.Description;
                        TableTransaction.MergeOrderDetail(itemOrderDetail);
                    }
                    transaction.Complete();
                }
                catch (Exception e)
                {
                    result = new Response<int>(0);
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
    }
}