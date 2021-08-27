using System.Web.Http;
using BaseArchitecture.Application.TransferObject.Response.Access;
using BaseArchitecture.Application.TransferObject.Response.Common;
using BaseArchitecture.Cross.LoggerTrace.Filters;
using BaseArchitecture.Cross.Security.Controllers;
using BaseArchitecture.Cross.Security.InvokePetition;
using BaseArchitecture.Cross.SystemVariable.Constant;

namespace BaseArchitecture.Distributed.ApiGateway.Controllers
{
    [RoutePrefix(IncomeWebApi.PrefixApi.Security)]
    public class SecurityController : BaseWebController
    {
        [HttpGet]
        [RequestLoggerFilter]
        [UnControlledExceptionFilterAttribute]
        [Route(IncomeWebApi.MethodApi.Security.Access)]
        public IHttpActionResult Access()
        {
            var urlApi =
                $"{AppSettingValue.UrlWebApi}/{IncomeWebApi.PrefixApi.Security}/{IncomeWebApi.MethodApi.Security.Access}";
            var result = InvokeWebApi.InvokePostHeaderEntity<Response<AccessResponse>>(urlApi, GetHeaderRequest(), "");
            return Ok(result);
        }
    }
}