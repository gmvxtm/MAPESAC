using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;

namespace BaseArchitecture.Presentation.UploadS3.Models
{
    public class Info
    {
        public string Application_Id { get; set; }
        public string Application_Name { get; set; }
        public int IsAutoJoin { get; set; }
        public string Profile_Id_Default { get; set; }
        public string DisplayName { get; set; }
        public string User_Guid { get; set; }
        public string Email { get; set; }
        public string NetLogon { get; set; }
        public string SamAccountName { get; set; }
        public string CodTra { get; set; }
        public string EmployeeId { get; set; }
        public string Position_Id { get; set; }
        public string Prc { get; set; }
        public string Title { get; set; }
        public string Deparment { get; set; }
        public string TelephoneNumber { get; set; }
        public string Mobile { get; set; }
    }
}