using System;

namespace BaseArchitecture.Repository.Entity.Tables
{
    public class BuySupplyEntity
    {
        public Guid IdSupply { get; set; }
        public Guid IdSupplier { get; set; }
        public double UnitPrice { get; set; }
        public double Quantity { get; set; }
        public double TotalPrice { get; set; }
    }
}