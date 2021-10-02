using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace BaseArchitecture.Repository.Entity.Tables
{
    public class ProductOutOfStockEntity
    {
        public string Name { get; set; }
        public double Stock { get; set; }
        public string MeasureUnit { get; set; }
        public double MinimumStock{ get; set; }
    }
}
