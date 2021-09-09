using BaseArchitecture.Repository.Entity.Tables;
using System;
using System.Collections.Generic;

namespace BaseArchitecture.Repository.Entity
{
    public class OrderStatusEntity
    {
        public Guid IdOrderStatus { get; set; }
        public Guid IdOrder{ get; set; }
        public string Location { get; set; }
        public DateTime DateOrderStatus { get; set; }
        public string Status { get; set; }
    }
}
