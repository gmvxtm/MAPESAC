namespace BaseArchitecture.Application.TransferObject.Request.External
{
    public class ApplicationProfileRequest
    {
        public string Search { get; set; }
        public string ProfileId { get; set; }
        public string ClientId { get; set; }
        public string Action { get; set; }
        public string UserEdit { get; set; }
        public string Token { get; set; }
    }
}