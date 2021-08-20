namespace BaseArchitecture.Application.TransferObject.ExternalResponse
{
    public class ServerControlDeviceResponse : BaseResponse

    {
        public Contents Content { get; set; }

        public class Contents
        {
            public string Encontrado { get; set; }
        }
    }
}