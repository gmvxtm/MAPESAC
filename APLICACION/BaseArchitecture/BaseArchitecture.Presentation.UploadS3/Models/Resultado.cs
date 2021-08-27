using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;

namespace BaseArchitecture.Presentation.UploadS3.Models
{
    public class Resultado
    {
        public int resultado { get; set; }
        public string Msg { get; set; }
        public List<Info> Info { get; set; }
        public List<PerfilUsuario> Perfiles { get; set; }
    }
}