using System;

namespace BaseArchitecture.Repository.Entity
{
    public class OrderDetailEntity
    {
        public Guid IdOrderDetail { get; set; }
        public Guid IdOrder { get; set; }
        public Guid IdProduct { get; set; }
        public string Description { get; set; }
        public double Quantity { get; set; }
        public double UnitPrice { get; set; }
        public double SubTotal { get; set; }
        public string RecordStatus { get; set; }
    }
}
