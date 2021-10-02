using System;

namespace BaseArchitecture.Repository.Entity
{
    public class DecreaseEntity
    {
        public Guid IdOrderDetail { get; set; }
        public string CodeSubOrder { get; set; }
        public int QuantityDecrease { get; set; }
    }
}
