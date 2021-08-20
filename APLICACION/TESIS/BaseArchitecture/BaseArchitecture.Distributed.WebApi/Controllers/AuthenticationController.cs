using System.Web.Http;
using BaseArchitecture.Application.IService.Security;
using BaseArchitecture.Application.TransferObject.Request.Access;
using BaseArchitecture.Cross.LoggerTrace.Filters;
using BaseArchitecture.Cross.Security.Aws;
using BaseArchitecture.Cross.SystemVariable.Constant;

namespace BaseArchitecture.Distributed.WebApi.Controllers
{
    [AllowAnonymous]
    [ExceptionAnonymousFilter]
    [RoutePrefix(IncomeWebApi.PrefixApi.Authentication)]
    public class AuthenticationController : ApiController
    {
        public ISecurityService SecurityService { get; set; }
        public AwsHelper AwsHelper { get; set; }

        [HttpPost]
        [Route(IncomeWebApi.MethodApi.Authentication.Login)]
        public IHttpActionResult Login(LoginRequest loginRequest)
        {
            AwsHelper.SetLogger(loginRequest.IdToken, IncomeTraceConfigureAws.AwsIdentityPool);
            var loginResponse = SecurityService.GetUserAccess(loginRequest).Result;
            if (loginResponse == null) return Unauthorized();
            return Ok(loginResponse);
        }
    }
}