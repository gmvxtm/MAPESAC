using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;

namespace BaseArchitecture.Presentation.UploadS3.Models
{
    public class OpcionesAcciones
    {
        public string Process_Id { get; set; }
        public string Process_Name { get; set; }
        public bool Process_OnlyRead { get; set; }
    }
}