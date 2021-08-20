using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;

namespace BaseArchitecture.Presentation.UploadS3.Models
{
    public class UsuarioLogin
    {
        public UsuarioLogin()
        {
            IdPerfil = 0;
            IdUsuario = 0;
            PerfilNombre = string.Empty;
        }

        public string Codigo { get; set; }
        public bool EsInterno { get; set; }
        public string Nombres { get; set; }
        public string Apellidos { get; set; }
        public string Correo { get; set; }
        public string TelefonoCorporativo { get; set; }
        public string Profile_Id { get; set; }
        public string Profile_Name { get; set; }
        public int IdUsuario { get; set; }
        public int IdPerfil { get; set; }
        public string PerfilNombre { get; set; }
    }
}