using BaseArchitecture.Application.TransferObject.Response.Common;
using BaseArchitecture.Repository.Entity;
using BaseArchitecture.Repository.Entity.Tables;
using System.Collections.Generic;

namespace BaseArchitecture.Application.IService.Table
{
    public interface ITableService
    {

        MasterTableEntity GetMasterById(MasterTableEntity masterTableRequest);
        Response<IEnumerable<MasterTableEntity>> ListMasterTable(MasterTableEntity masterTableRequest);
        Response<IEnumerable<MasterTableEntity>> ListMasterTableByValue(MasterTableEntity masterTableRequest);
        Response<MenuLogin> Login(UserEntity userRequest);        
        Response<IEnumerable<ProductEntity>> ListProduct();        
        Response<string> MergeOrder(OrderEntity orderRequest);
        Response<UbiEntity> ListUbi();
        Response<OrderListEntity> ListOrder();
        Response<OrderEntity> GetOrderByCodeOrder(OrderEntity orderRequest);
        Response<string> UpdOrderFlow(OrderFlowEntity orderFlowRequest);
        Response<int> UpdSubOrderFlow(OrderFlowEntity orderFlowRequest);
        Response<OrderListByLocationEntity> ListOrderByLocation(OrderEntity orderRequest);
        Response<SubOrderListByLocationEntity> ListSubOrderByLocation(OrderEntity orderRequest);
        Response<IEnumerable<SupplyEntity>> ListSuppliesByProduct(ProductEntity suppliesByProductRequest);
        Response<int> UpdDecrease(DecreaseEntity decreaseRequest);
        Response<IEnumerable<SupplyEntity>> ListSupplies();
        Response<IEnumerable<SupplierEntity>> ListSuppliersByIdSupply(SupplyEntity supplyRequest);
        Response<int> InsBuySupply(BuySupplyEntity buySupplyRequest);
        Response<IEnumerable<RptListProductQuantityEntity>> RptListProductQuantity();
        Response<IEnumerable<RptListOrderQuantityEntity>> RptListOrderQuantity();
        Response<IEnumerable<RptListOrderQuantityStatusEntity>> RptListOrderQuantityStatus();
        Response<IEnumerable<RptListOrderQuantityStatusDeliveryEntity>> RptListOrderQuantityStatusDelivery():
    }
}