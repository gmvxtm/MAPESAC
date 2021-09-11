using BaseArchitecture.Repository.Entity.Tables;
using System;
using System.Collections.Generic;

namespace BaseArchitecture.Repository.Entity
{
    public class OrderEntity
    {
        public OrderEntity()
        {
            ListOrderStatus = new List<OrderStatusEntity>();
        }

        public IEnumerable<OrderStatusEntity> ListOrderStatus { get; set; }
        public Guid IdOrder { get; set; }
        public DateTime DateOrder { get; set; }
        public string CodeOrder { get; set; }
        public double Total { get; set; }
        public string Email { get; set; }
        public string StatusOrder { get; set; }
        public string StatusOrderName { get; set; }
        public string LocationOrder { get; set; }
        public string LocationOrderName { get; set; }
        public Guid IdCustomer { get; set; }
        public string BusinessName { get; set; }
        public string BusinessNumber { get; set; }
        public string FirstName { get; set; }
        public string DocumentNumber { get; set; }
        public string PhoneNumber { get; set; }
        public string LastName { get; set; }
        public string RecordStatus { get; set; }
        public CustomerEntity CustomerEntity { set; get;}
        public List<OrderDetailEntity> ListOrderDetail { get; set; }
        
    }
}
