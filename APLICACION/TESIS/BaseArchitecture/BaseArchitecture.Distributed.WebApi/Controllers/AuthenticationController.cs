using System.Web.Http;
using BaseArchitecture.Application.IService.Security;
using BaseArchitecture.Application.IService.Table;
using BaseArchitecture.Application.TransferObject.Request.Access;
using BaseArchitecture.Cross.LoggerTrace.Filters;
using BaseArchitecture.Cross.Security.Aws;
using BaseArchitecture.Cross.SystemVariable.Constant;
using BaseArchitecture.Repository.Entity;

namespace BaseArchitecture.Distributed.WebApi.Controllers
{
    [AllowAnonymous]
    [ExceptionAnonymousFilter]
    [RoutePrefix(IncomeWebApi.PrefixApi.Authentication)]
    public class AuthenticationController : ApiController
    {
        public ISecurityService SecurityService { get; set; }
        public ITableService TableService { get; set; }
        
        //public AwsHelper AwsHelper { get; set; }

        [HttpPost]
        [Route(IncomeWebApi.MethodApi.Authentication.Login)]
        public IHttpActionResult Login(UserEntity userEntity)
        {
            //AwsHelper.SetLogger(loginRequest.IdToken, IncomeTraceConfigureAws.AwsIdentityPool);
            var loginResponse = TableService.Login(userEntity);
            if (loginResponse == null) return Unauthorized();
            return Ok(loginResponse);
        }
    }
}