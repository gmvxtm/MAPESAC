namespace BaseArchitecture.Application.TransferObject.ExternalResponse
{
    public class ProfileSiappsResponse
    {
        public Content Content { get; set; }
        public string Status { get; set; }
        public string Msg { get; set; }
    }

    public class Content
    {
        public string ProfileId { get; set; }
    }
}