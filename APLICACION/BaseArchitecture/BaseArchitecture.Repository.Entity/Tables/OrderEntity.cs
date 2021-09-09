using BaseArchitecture.Repository.Entity.Tables;
using System;
using System.Collections.Generic;

namespace BaseArchitecture.Repository.Entity
{
    public class OrderEntity
    {
        public Guid IdOrder { get; set; }
        public DateTime DateOrder { get; set; }
        public string CodeOrder { get; set; }
        public double Total { get; set; }
        public string Status { get; set; }
        public Guid IdCustomer { get; set; }
        public string BusinessName { get; set; }
        public string BusinessNumber { get; set; }
        public string RecordStatus { get; set; }
        public CustomerEntity CustomerEntity { set; get;}
        public List<OrderDetailEntity> ListOrderDetail { get; set; }
        public List<OrderStatusEntity> ListOrderStatus { get; set; }
    }
}
