namespace BaseArchitecture.Cross.SystemVariable.Model
{
    public class ErrorModel
    {
        public string UniqueIdentifier { get; set; }
        public Enumerator.Enumerator.ResponseCode ResponseCode { get; set; }
        public string Message { get; set; }
    }
}