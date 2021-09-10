using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace BaseArchitecture.Repository.Entity.Tables
{
    public class CustomerEntity
    {
        public Guid IdCustomer { get; set; }
        public string FirstName { get; set; }
        public string LastName { get; set; }
        public string DocumentNumber { get; set; }
        public string PhoneNumber { get; set; }
        public string Email { get; set; }
        public string IdDistrict { get; set; }
        public string District { get; set; }
        public string IdProvince { get; set; }
        public string Province { get; set; }
        public string IdDepartment { get; set; }
        public string Department { get; set; }
        public string RecordStatus { get; set; }
    }
}


