using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;

namespace BaseArchitecture.Presentation.UploadS3.Models
{
    public class LoginRequest
    {
        public string IdToken { get; set; }

        public string AccessToken { get; set; }

        public string ExpiresIn { get; set; }

        public string Device { get; set; }

        public string PreferredUser { get; set; }
    }
}