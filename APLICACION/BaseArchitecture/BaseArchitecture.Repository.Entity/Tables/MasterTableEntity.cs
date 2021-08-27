using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace BaseArchitecture.Repository.Entity
{
    public class MasterTableEntity
    {
        public string IdMasterTable { get; set; }
        public string IdMasterTableParent { get; set; }
        public string Name { get; set; }
        public string Order { get; set; }
        public string Value { get; set; }
        public string AdditionalOne { get; set; }
        public string AdditionalTwo { get; set; }
        public string AdditionalThree { get; set; }
        public string RecordStatus { get; set; }

    }
}
