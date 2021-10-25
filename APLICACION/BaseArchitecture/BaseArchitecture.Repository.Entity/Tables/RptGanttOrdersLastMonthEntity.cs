using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace BaseArchitecture.Repository.Entity.Tables
{
    public class RptGanttOrdersLastMonthEntity
    {
        public string CodeOrder { get; set; }
        public string LocationOrder { get; set; }
        public string NameLocation { get; set; }
        public string DateInitOrderFlow { get; set; }
        public string DateEndOrderFlow { get; set; }
    }
}