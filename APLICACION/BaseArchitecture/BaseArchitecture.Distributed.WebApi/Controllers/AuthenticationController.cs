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
        public IHttpActionResult Login(UserEntity userRequest)
        {
            //AwsHelper.SetLogger(loginRequest.IdToken, IncomeTraceConfigureAws.AwsIdentityPool);
            var loginResponse = TableService.Login(userRequest);
            if (loginResponse == null) return Unauthorized();
            return Ok(loginResponse);
        }
        [HttpPost]
        [Route(IncomeWebApi.MethodApi.Mapesac.ListProduct)]
        //[RequestLoggerFilterAttribute]
        //[UnControlledExceptionFilterAttribute]
        public IHttpActionResult ListProduct()
        {
            var result = TableService.ListProduct();
            return Ok(result);
        }
        [HttpPost]
        [Route(IncomeWebApi.MethodApi.Mapesac.MergeOrder)]
        //[RequestLoggerFilterAttribute]
        //[UnControlledExceptionFilterAttribute]
        public IHttpActionResult MergeOrder(OrderEntity orderRequest)
        {
            var result = TableService.MergeOrder(orderRequest);
            return Ok(result);
        }


        [HttpPost]
        [Route(IncomeWebApi.MethodApi.Mapesac.ListUbi)]
        public IHttpActionResult ListUbi()
        {
            var result = TableService.ListUbi();
            return Ok(result);
        }

        [HttpPost]
        [Route(IncomeWebApi.MethodApi.Mapesac.ListOrder)]
        public IHttpActionResult ListOrder()
        {
            var result = TableService.ListOrder();
            return Ok(result);
        }
    }
}