namespace BaseArchitecture.Application.TransferObject.Request.Base
{
    public class BaseRequest
    {
        public BaseRequest()
        {
            Status = "A";
            State = "0";
        }

        public string AccessDevice { get; set; }
        public string Token { get; set; }
        public string UserEdit { get; set; }
        public string Status { get; set; }
        public string State { get; set; }
        public string AwsAccessKey { get; set; }
        public string AwsSecretKey { get; set; }
        public string AwsSessionToken { get; set; }
        public string ProfileId { get; set; }
    }
}