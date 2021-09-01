using System;
using System.Collections.Generic;

namespace BaseArchitecture.Repository.Entity
{
    public class OrderEntity
    {
        public Guid IdOrder { get; set; }
        public DateTime DateOrder { get; set; }
        public double Total { get; set; }
        public string Status { get; set; }
        public Guid IdCustomer { get; set; }
        public List<OrderDetailEntity> ListOrderDetail { get; set; }
    }
}
