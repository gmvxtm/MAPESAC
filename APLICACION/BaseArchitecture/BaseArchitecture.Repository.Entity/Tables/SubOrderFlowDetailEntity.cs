using BaseArchitecture.Repository.Entity.Tables;
using System;
using System.Collections.Generic;

namespace BaseArchitecture.Repository.Entity
{
    public class SubOrderFlowDetailEntity
    {
        public Guid IdSuppliesByProduct { get; set; }        
        public Guid IdProduct { get; set; }
        public Guid IdSupply { get; set; }
        public string NameSupply { get; set; }
        public string QuantityReturn { get; set; }
        public Guid IdSubOrderFlowDetail { get; set; }
        public Guid IdSubOrderFlow { get; set; }
        



    }
}

