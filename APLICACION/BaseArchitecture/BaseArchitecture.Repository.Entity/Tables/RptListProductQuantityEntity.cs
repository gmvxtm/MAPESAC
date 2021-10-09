using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace BaseArchitecture.Repository.Entity.Tables
{
    public class RptListProductQuantityEntity
    {

        public Guid IdProduct { get; set; }
        public string Name { get; set; }        
        public string Quantity { get; set; }
        
    }
}
