using BaseArchitecture.Application.TransferObject.Response.Common;
using BaseArchitecture.Repository.Entity;

namespace BaseArchitecture.Repository.IData.Transactional
{
    public interface ITableTransactional
    {
        Response<int> MrgOrder(OrderEntity orderEntity);
        Response<int> MrgOrderDetail(OrderDetailEntity orderDetailEntity);
    }
}
