using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace BaseArchitecture.Repository.Entity.Tables
{
    public class OrderListByLocationEntity
    {
        public OrderListByLocationEntity()
        {
            ListOrderEntity = new List<OrderEntity>();
            ListTotalOrderEntity = new List<TotalOrderEntity>();
        }
        public IEnumerable<OrderEntity> ListOrderEntity { get; set; }
        public IEnumerable<TotalOrderEntity> ListTotalOrderEntity { get; set; }
        
    }
}

