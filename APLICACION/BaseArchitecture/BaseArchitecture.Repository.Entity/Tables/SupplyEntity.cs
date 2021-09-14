﻿using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace BaseArchitecture.Repository.Entity.Tables
{
    public class SupplyEntity
    {
        public string IdSupply { get; set; }
        public string Name { get; set; }
        public double Quantity { get; set; }
        public string MeasureUnit { get; set; }
    }
}
