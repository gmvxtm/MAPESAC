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
    }
}
