using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace BaseArchitecture.Repository.Entity.Tables
{
    public class SupplyEntity
    {
        public string IdSupply { get; set; }
        public string CodeSupply { get; set; }
        public string Name { get; set; }
        public double Stock { get; set; }
        public double Quantity { get; set; }
        public string MeasureUnit { get; set; }
        public double MinimumStock { get; set; }
        public string DateUpdate { get; set; }
    }
}
