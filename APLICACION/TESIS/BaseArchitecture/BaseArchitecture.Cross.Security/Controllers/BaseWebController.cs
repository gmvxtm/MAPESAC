using System.Web.Http;
using BaseArchitecture.Application.TransferObject.Request.Base;

namespace BaseArchitecture.Cross.Security.Controllers
{
    public class BaseWebController : ApiController
    {
        #region Properties

        public BaseRequest GetHeaderRequest()
        {
            var result = new BaseRequest
            {
                //Token = Request.Headers.Authorization.Scheme,
                //UserEdit = ((string[]) Request.Headers.GetValues("UserEdit"))[0],
                //AccessDevice = ((string[]) Request.Headers.GetValues("AccessDevice"))[0],
                //AwsAccessKey = ((string[]) Request.Headers.GetValues("AwsAccessKey"))[0],
                //AwsSecretKey = ((string[]) Request.Headers.GetValues("AwsSecretKey"))[0],
                //AwsSessionToken = ((string[]) Request.Headers.GetValues("AwsSessionToken"))[0],
                //ProfileId = ((string[]) Request.Headers.GetValues("ProfileId"))[0]
            };
            return result;
        }

        public BaseServiceRequest GetHeaderServiceRequest()
        {
            var result = new BaseServiceRequest
            {
                Token = Request.Headers.Authorization.Scheme,
                IdPetition = ((string[]) Request.Headers.GetValues("IdPetition"))[0],
                IdApplication = ((string[]) Request.Headers.GetValues("IdApplication"))[0],
                IdentityPool = ((string[]) Request.Headers.GetValues("IdentityPool"))[0]
            };
            return result;
        }

        #endregion
    }
}