using System;

namespace BaseArchitecture.Repository.Entity
{
    public class ProductEntity
    {
        public Guid IdProduct { get; set; }
        public string Name { get; set; }
        public string RecordStatus { get; set; }
    }
}
