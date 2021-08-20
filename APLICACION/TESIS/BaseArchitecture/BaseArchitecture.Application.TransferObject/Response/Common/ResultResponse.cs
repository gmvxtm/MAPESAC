using BaseArchitecture.Cross.SystemVariable.Enumerator;

namespace BaseArchitecture.Application.TransferObject.Response.Common
{
    public class ResultResponse
    {
        public ResultResponse(int idResult, int codeResult, string messageResult)
        {
            IdResult = idResult;
            CodeResult = codeResult;
            MessageResult = messageResult;
        }

        public ResultResponse()
        {
            IdResult = 1;
            CodeResult = (int) Enumerator.ResponseCode.Correct;
            MessageResult = "Ok";
        }

        public ResultResponse(string messageResult)
        {
            IdResult = 0;
            CodeResult = (int) Enumerator.ResponseCode.Incorrect;
            MessageResult = messageResult;
        }

        public int Id { get; set; }
        public int IdResult { get; set; }
        public int CodeResult { get; set; }
        public string MessageResult { get; set; }
    }
}