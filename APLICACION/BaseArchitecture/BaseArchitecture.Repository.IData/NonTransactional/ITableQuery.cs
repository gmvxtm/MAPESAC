using BaseArchitecture.Application.TransferObject.Response.Common;
using BaseArchitecture.Repository.Entity;
using BaseArchitecture.Repository.Entity.Tables;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace BaseArchitecture.Repository.IData.NonTransactional
{
    public interface ITableQuery
    {
        IEnumerable<MasterTableEntity> ListMasterTable();
        Response<MenuLogin> Login(UserEntity userRequest);        
        IEnumerable<ProductEntity> ListProduct();
    }
}
