using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;

namespace BaseArchitecture.Presentation.UploadS3.Models
{
    public class PerfilUsuario
    {
        public string Profile_Id { get; set; }
        public string Profile_Name { get; set; }
        public string Tipo { get; set; }
        public List<Opcion> Permisos { get; set; }
    }
}