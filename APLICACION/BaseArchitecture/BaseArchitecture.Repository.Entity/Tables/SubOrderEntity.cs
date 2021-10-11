using BaseArchitecture.Repository.Entity.Tables;
using System;
using System.Collections.Generic;

namespace BaseArchitecture.Repository.Entity
{
    public class SubOrderEntity
    {

        public Guid IdOrder { get; set; }        
        public string CodeOrder { get; set; }
        public Guid IdSubOrderFlow { get; set; }
        public string CodeSubOrder { get; set; }
        public string Quantity { get; set; }
        public string StatusSubOrderMT { get; set; }
        public string StatusSubOrderName { get; set; }
        public string DateSubOrder { get; set; }
        public string DateEndSubOrder { get; set; }
        public Guid IdProduct { get; set; }
        public Guid IdOrderDetail { get; set; }
        public string Merma { get; set; }



    }
}
