using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace BaseArchitecture.Repository.Entity.Tables
{
    public class OrderFlowEntity
    {
        public Guid IdOrderFlow { get; set; }
        public Guid IdOrder { get; set; }
        public int NroOrder { get; set; }
        public string LocationOrder { get; set; }
        public string Answer { get; set; }
        public DateTime DateOrderFlow { get; set; }
        public bool FlagActive { get; set; }
        public bool FlagInProcess { get; set; }
        
    }
}
