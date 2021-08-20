using System.Web.Http;
using BaseArchitecture.Application.IService.Security;
using BaseArchitecture.Cross.LoggerTrace.Filters;
using BaseArchitecture.Cross.Security.Controllers;
using BaseArchitecture.Cross.SystemVariable.Constant;

namespace BaseArchitecture.Distributed.WebApi.Controllers
{
    [AllowAnonymous]
    [RequestLoggerFilter]
    [RoutePrefix(IncomeWebApi.PrefixApi.Security)]
    public class SecurityController : BaseWebController
    {
        public ISecurityService SecurityService { get; set; }

        [HttpPost]
        [UnControlledExceptionFilterAttribute]
        [Route(IncomeWebApi.MethodApi.Security.Access)]
        public IHttpActionResult Access()
        {
            var loginResponse = SecurityService.GetProfileSiapp(GetHeaderRequest()).Result;
            return Ok(loginResponse);
        }
    }
}