using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;

namespace BaseArchitecture.Presentation.UploadS3.Models
{
    public class Opcion
    {
        public string Option_Id { get; set; }
        public string Option_Name { get; set; }
        public string Option_Url { get; set; }
        public string Option_Id_Parent { get; set; }
        public OpcionesAcciones[] Process { get; set; }
    }
}