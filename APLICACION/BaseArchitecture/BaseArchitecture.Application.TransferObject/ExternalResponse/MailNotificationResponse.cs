namespace BaseArchitecture.Application.TransferObject.ExternalResponse
{
    public class MailNotificationResponse
    {
        public int NumRespuesta { get; set; }
        public int CodigoError { get; set; }
        public string MsgRespuesta { get; set; }
        public string Status { get; set; }
    }
}