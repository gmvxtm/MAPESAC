using BaseArchitecture.Application.TransferObject.Response.Common;
using BaseArchitecture.Repository.Entity;
using System.Collections.Generic;

namespace BaseArchitecture.Application.IService.Demo
{
    public interface ITableService
    {

        MasterTableEntity GetMasterById(MasterTableEntity masterTableRequest);
        Response<IEnumerable<MasterTableEntity>> ListMasterTable(MasterTableEntity masterTableRequest);
        Response<IEnumerable<MasterTableEntity>> ListMasterTableByValue(MasterTableEntity masterTableRequest);
        Response<UserEntity> Login(UserEntity userRequest);
        Response<IEnumerable<ProductEntity>> ListProduct();
    }
}