using BaseArchitecture.Repository.Entity;
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
    }
}
