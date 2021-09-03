using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace BaseArchitecture.Repository.Entity.Tables
{
    public class OrderListEntity
    {
        public OrderListEntity()
        {
            ListOrderEntity = new List<OrderEntity>();
        }
        public IEnumerable<OrderEntity> ListOrderEntity { get; set; }
    }
}
