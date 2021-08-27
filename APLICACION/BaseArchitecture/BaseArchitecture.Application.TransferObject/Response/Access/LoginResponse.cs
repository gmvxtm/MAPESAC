namespace BaseArchitecture.Application.TransferObject.Response.Access
{
    public class LoginResponse
    {
        public LoginResponse()
        {
        }

        public LoginResponse(string token, string accessDevice, bool state)
        {
            AccessDevice = accessDevice;
            Token = token;
            State = state;
        }

        public bool State { get; set; }
        public string AccessDevice { get; set; }
        public string Token { get; set; }
        public string User { get; set; }
        public string UserEdit { get; set; }
        public string EmployeeId { get; set; }
        public string Title { get; set; }
        public string AwsSessionToken { get; set; }
        public string AwsAccessKey { get; set; }
        public string AwsSecretKey { get; set; }
        public string ProfileId { get; set; }
    }
}