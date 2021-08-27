namespace BaseArchitecture.Cross.SystemVariable.Enumerator
{
    public class Enumerator
    {
        public enum ResponseCode
        {
            NotAuthorize = 401,
            UnControlledException = 900,
            BadRequest = 400,
            Correct = 1001,
            Incorrect = 1002,
            RequiredAttachment = 1003
        }
    }
}