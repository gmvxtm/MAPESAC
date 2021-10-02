using BaseArchitecture.Application.TransferObject.Response.Common;
using BaseArchitecture.Repository.Entity;
using BaseArchitecture.Repository.Entity.Tables;

namespace BaseArchitecture.Repository.IData.Transactional
{
    public interface ITableTransaction
    {
        Response<int> MergeOrder(OrderEntity orderEntity);
        Response<int> MergeOrderDetail(OrderDetailEntity orderDetailEntity);
        Response<int> MergeCustomer(CustomerEntity customerEntity);
        Response<int> GenerateOrderFlow(OrderEntity orderEntity);
        Response<int> GenerateSubOrderFlow(OrderEntity orderEntity);
        Response<int> UpdOrderFlow(OrderFlowEntity orderFlowRequest);
        Response<int> UpdSubOrderFlow(OrderFlowEntity orderFlowRequest);
        Response<ResponseValidateStockEntity> ValidateAndUpdateStock(string listProductJson);
        Response<int> UpdDecrease(DecreaseEntity decreaseRequest);
    }
}
