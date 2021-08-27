using System.Web;
using System.Web.Http;
using BaseArchitecture.Application.TransferObject.Response.Access;
using BaseArchitecture.Application.TransferObject.Response.Common;
using BaseArchitecture.Cross.LoggerTrace.Filters;
using BaseArchitecture.Cross.Security.Aws;
using BaseArchitecture.Cross.Security.InvokePetition;
using BaseArchitecture.Cross.SystemVariable.Constant;

namespace BaseArchitecture.Distributed.ApiGateway.Controllers
{
    [AllowAnonymous]
    [ExceptionAnonymousFilter]
    [RoutePrefix(IncomeWebApi.PrefixApi.Authentication)]
    public class AuthenticationController : ApiController
    {
        public AwsHelper AwsHelper { get; set; }

        /// <summary>
        /// Method that allows authentication within the BaseArchitecture system
        /// </summary>
        /// <returns></returns>
        [HttpGet]
        [Route(IncomeWebApi.MethodApi.Authentication.Login)]
        public IHttpActionResult Login()
        {
            var postData = HttpContext.Current.Request.Params["loginRequest"];
            var urlApi =
                $"{AppSettingValue.UrlWebApi}/{IncomeWebApi.PrefixApi.Authentication}/{IncomeWebApi.MethodApi.Authentication.Login}";
            var result = InvokeWebApi.InvokePostAnonymousEntity<Response<LoginResponse>>(urlApi, postData);
            AwsHelper.SetLogger(result.Value.Token, IncomeTraceConfigureAws.AwsIdentityPool);
            return Ok(result);
        }
    }
}