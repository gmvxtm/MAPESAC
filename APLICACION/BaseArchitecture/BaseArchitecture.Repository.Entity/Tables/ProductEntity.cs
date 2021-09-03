using System;

namespace BaseArchitecture.Repository.Entity
{
    public class ProductEntity
    {
        public Guid IdProduct { get; set; }
        public string Name { get; set; }
        public string PathFile { get; set; }
        public double PriceUnit { get; set; }
        public string RecordStatus { get; set; }
        public double Quantity { get; set; }
        public double Total { get; set; }
    }
}
