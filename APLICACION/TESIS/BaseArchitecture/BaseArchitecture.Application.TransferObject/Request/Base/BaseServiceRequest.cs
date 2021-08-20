namespace BaseArchitecture.Application.TransferObject.Request.Base
{
    public class BaseServiceRequest
    {
        public string Token { get; set; }
        public string IdApplication { get; set; }
        public string IdPetition { get; set; }
        public string IdentityPool { get; set; }
    }
}