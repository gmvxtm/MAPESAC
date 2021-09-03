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
    }
}