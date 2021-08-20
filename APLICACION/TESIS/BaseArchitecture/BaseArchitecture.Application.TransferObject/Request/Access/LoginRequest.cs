namespace BaseArchitecture.Application.TransferObject.Request.Access
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