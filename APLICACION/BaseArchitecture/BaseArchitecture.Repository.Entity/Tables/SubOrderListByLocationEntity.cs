using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace BaseArchitecture.Repository.Entity.Tables
{
    public class SubOrderListByLocationEntity
    {
        public SubOrderListByLocationEntity()
        {
            ListSubOrderEntity = new List<SubOrderEntity>();
            ListSubOrderFlowDetailEntity = new List<SubOrderFlowDetailEntity>();
            ListTotalOrderEntity = new List<TotalOrderEntity>();
        }
        public IEnumerable<SubOrderEntity> ListSubOrderEntity { get; set; }
        public IEnumerable<SubOrderFlowDetailEntity> ListSubOrderFlowDetailEntity { get; set; }        
        public IEnumerable<TotalOrderEntity> ListTotalOrderEntity { get; set; }
        
    }
}

