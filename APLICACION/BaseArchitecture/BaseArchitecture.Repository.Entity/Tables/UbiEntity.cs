using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace BaseArchitecture.Repository.Entity.Tables
{
    public class UbiEntity
    {
        public UbiEntity()
        {            
            ListDepartmentEntity = new List<DepartmentEntity>();
            ListProvinceEntity = new List<ProvinceEntity>();
            ListDistrictEntity = new List<DistrictEntity>();

        }
        
        public IEnumerable<DepartmentEntity> ListDepartmentEntity { get; set; }
        public IEnumerable<ProvinceEntity> ListProvinceEntity { get; set; }
        public IEnumerable<DistrictEntity> ListDistrictEntity { get; set; }

    }
}
