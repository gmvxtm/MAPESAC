using BaseArchitecture.Application.IService.Demo;
using BaseArchitecture.Application.TransferObject.Request.Base;
using BaseArchitecture.Application.TransferObject.Request.Demo;
using BaseArchitecture.Cross.LoggerTrace.Filters;
using BaseArchitecture.Cross.Security.Controllers;
using BaseArchitecture.Cross.SystemVariable.Constant;
using BaseArchitecture.Repository.Entity;
using System.Web.Http;

namespace BaseArchitecture.Distributed.WebApi.Controllers
{
    [AllowAnonymous]
    [RoutePrefix(IncomeWebApi.PrefixApi.Mapesac)]
    public class TableContoller : BaseWebController
    {
        public IDemoService DemoService { get; set; }
        public ITableService TableService { get; set; }

        [HttpPost]
        [Route(IncomeWebApi.MethodApi.Demo.ListMasterTableByValue)]
        [RequestLoggerFilter]
        [UnControlledExceptionFilterAttribute]
        public IHttpActionResult ListMasterTableByValue(MasterTableRequest masterTableRequest)
        {
            var result = DemoService.ListMasterTableByValue(masterTableRequest);
            return Ok(result);
        }

        [HttpPost]
        [Route(IncomeWebApi.MethodApi.Demo.ListMasterTable)]
        [RequestLoggerFilterAttribute]
        [UnControlledExceptionFilterAttribute]
        public IHttpActionResult ListMasterTable(MasterTableRequest masterTableRequest)
        {
            var result = DemoService.ListMasterTable(masterTableRequest);
            return Ok(result);
        }

        [HttpPost]
        [Route(IncomeWebApi.MethodApi.Demo.GetPersonById)]
        [RequestLoggerFilterAttribute]
        [UnControlledExceptionFilterAttribute]
        public IHttpActionResult GetPersonById(PersonBaseRequest personBaseRequest)
        {
            var result = DemoService.GetPersonById(personBaseRequest);
            return Ok(result);
        }

        [HttpPost]
        [Route(IncomeWebApi.MethodApi.Demo.ListPersonAll)]
        [RequestLoggerFilterAttribute]
        [UnControlledExceptionFilterAttribute]
        public IHttpActionResult ListPersonAll(PersonFilterRequest personFilterRequest)
        {
            var result = DemoService.ListPersonAll(personFilterRequest);
            return Ok(result);
        }

        [HttpPost]
        [Route(IncomeWebApi.MethodApi.Demo.UpdPersonState)]
        [RequestLoggerFilterAttribute]
        [UnControlledExceptionFilterAttribute]
        public IHttpActionResult UpdPersonState(PersonBaseRequest personBaseRequest)
        {
            var baseRequest = GetHeaderRequest();
            var baseRecordRequest = new BaseRecordRequest(personBaseRequest.RecordStatus, baseRequest.UserEdit)
            {
                TokenId = baseRequest.Token
            };
            var result = DemoService.UpdPersonState(personBaseRequest, baseRecordRequest);
            return Ok(result);
        }

        [HttpPost]
        [Route(IncomeWebApi.MethodApi.Demo.RegPerson)]
        [RequestLoggerFilterAttribute]
        [UnControlledExceptionFilterAttribute]
        public IHttpActionResult RegPerson(PersonRequest personRequest)
        {
            var baseRequest = GetHeaderRequest();
            var baseRecordRequest = new BaseRecordRequest(baseRequest.UserEdit)
            {
                TokenId = baseRequest.Token
            };
            var result = DemoService.RegPerson(personRequest, baseRecordRequest);
            return Ok(result);
        }

        [HttpPost]
        [Route(IncomeWebApi.MethodApi.Mapesac.ListProyectos)]
        [RequestLoggerFilterAttribute]
        [UnControlledExceptionFilterAttribute]
        public IHttpActionResult ListProyectos()
        {
            var result = DemoService.ListProyectos();
            return Ok(result);
        }

        [HttpPost]
        [Route(IncomeWebApi.MethodApi.Mapesac.GetProyectoById)]
        [RequestLoggerFilterAttribute]
        [UnControlledExceptionFilterAttribute]
        public IHttpActionResult GetProyectoById(ProyectoRequest proyectoRequest)
        {
            var result = DemoService.GetProyectoById(proyectoRequest);
            return Ok(result);
        }

        [HttpPost]
        [Route(IncomeWebApi.MethodApi.Authentication.Login)]
        [RequestLoggerFilterAttribute]
        [UnControlledExceptionFilterAttribute]
        public IHttpActionResult Login(UserEntity userRequest)
        {
            var result = TableService.Login(userRequest);
            return Ok(result);
        }
    }
}