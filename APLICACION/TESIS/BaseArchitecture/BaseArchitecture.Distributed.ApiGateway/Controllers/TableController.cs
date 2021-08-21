using BaseArchitecture.Application.TransferObject.Request.Demo;
using BaseArchitecture.Application.TransferObject.Response.Common;
using BaseArchitecture.Application.TransferObject.Response.Demo;
using BaseArchitecture.Cross.LoggerTrace.Filters;
using BaseArchitecture.Cross.Security.Controllers;
using BaseArchitecture.Cross.Security.InvokePetition;
using BaseArchitecture.Cross.SystemVariable.Constant;
using BaseArchitecture.Repository.Entity;
using System.Collections.Generic;
using System.Web;
using System.Web.Http;

namespace BaseArchitecture.Distributed.ApiGateway.Controllers
{
    [RoutePrefix(IncomeWebApi.PrefixApi.Mapesac)]
    public class TableController : BaseWebController
    {
        [HttpGet]
        [RequestLoggerFilter]
        [UnControlledExceptionFilterAttribute]
        [Route(IncomeWebApi.MethodApi.Demo.ListMasterTable)]
        public IHttpActionResult ListMasterTable()
        {
            var postData = HttpContext.Current.Request.Params["masterTableRequest"];
            var urlApi =
                $"{AppSettingValue.UrlWebApi}/{IncomeWebApi.PrefixApi.Demo}/{IncomeWebApi.MethodApi.Demo.ListMasterTable}";
            var result =
                InvokeWebApi.InvokePostHeaderEntity<Response<IEnumerable<MasterTableResponse>>>(urlApi,
                    GetHeaderRequest(),
                    postData);
            return Ok(result);
        }

        [HttpGet]
        [RequestLoggerFilterAttribute]
        [UnControlledExceptionFilterAttribute]
        [Route(IncomeWebApi.MethodApi.Demo.ListMasterTableByValue)]
        public IHttpActionResult ListMasterTableByValue()
        {
            var postData = HttpContext.Current.Request.Params["masterTableRequest"];
            var urlApi =
                $"{AppSettingValue.UrlWebApi}/{IncomeWebApi.PrefixApi.Demo}/{IncomeWebApi.MethodApi.Demo.ListMasterTableByValue}";
            var result =
                InvokeWebApi.InvokePostHeaderEntity<Response<IEnumerable<MasterTableResponse>>>(urlApi,
                    GetHeaderRequest(),
                    postData);
            return Ok(result);
        }

        [HttpGet]
        [RequestLoggerFilterAttribute]
        [UnControlledExceptionFilterAttribute]
        [Route(IncomeWebApi.MethodApi.Demo.GetPersonById)]
        public IHttpActionResult GetPersonById()
        {
            var postData = HttpContext.Current.Request.Params["personBaseRequest"];
            var urlApi =
                $"{AppSettingValue.UrlWebApi}/{IncomeWebApi.PrefixApi.Demo}/{IncomeWebApi.MethodApi.Demo.GetPersonById}";
            var result =
                InvokeWebApi.InvokePostHeaderEntity<Response<PersonResponse>>(urlApi,
                    GetHeaderRequest(),
                    postData);
            return Ok(result);
        }

        [HttpGet]
        [RequestLoggerFilterAttribute]
        [UnControlledExceptionFilterAttribute]
        [Route(IncomeWebApi.MethodApi.Demo.ListPersonAll)]
        public IHttpActionResult ListPersonAll()
        {
            var postData = HttpContext.Current.Request.Params["personFilterRequest"];
            var urlApi =
                $"{AppSettingValue.UrlWebApi}/{IncomeWebApi.PrefixApi.Demo}/{IncomeWebApi.MethodApi.Demo.ListPersonAll}";
            var result =
                InvokeWebApi.InvokePostHeaderEntity<Response<CollectionDataResponse<PersonResponse>>>(urlApi,
                    GetHeaderRequest(),
                    postData);
            return Ok(result);
        }

        [HttpPost]
        [RequestLoggerFilterAttribute]
        [UnControlledExceptionFilterAttribute]
        [Route(IncomeWebApi.MethodApi.Demo.RegPerson)]
        public IHttpActionResult RegPerson(PersonRequest personRequest)
        {
            var postData = Newtonsoft.Json.JsonConvert.SerializeObject(personRequest);
            var urlApi =
                $"{AppSettingValue.UrlWebApi}/{IncomeWebApi.PrefixApi.Demo}/{IncomeWebApi.MethodApi.Demo.RegPerson}";
            var result =
                InvokeWebApi.InvokePostHeaderEntity<Response<int>>(urlApi, GetHeaderRequest(),
                    postData);
            return Ok(result);
        }

        [HttpPost]
        [RequestLoggerFilterAttribute]
        [UnControlledExceptionFilterAttribute]
        [Route(IncomeWebApi.MethodApi.Demo.UpdPersonState)]
        public IHttpActionResult UpdPersonState(PersonBaseRequest personBaseRequest)
        {
            var postData = Newtonsoft.Json.JsonConvert.SerializeObject(personBaseRequest);
            var urlApi =
                $"{AppSettingValue.UrlWebApi}/{IncomeWebApi.PrefixApi.Demo}/{IncomeWebApi.MethodApi.Demo.UpdPersonState}";
            var result =
                InvokeWebApi.InvokePostHeaderEntity<Response<int>>(urlApi, GetHeaderRequest(),
                    postData);
            return Ok(result);
        }

        [HttpGet]
        [RequestLoggerFilterAttribute]
        [UnControlledExceptionFilterAttribute]
        [Route(IncomeWebApi.MethodApi.Mapesac.ListProyectos)]
        public IHttpActionResult ListProyectos()
        {
            var urlApi =
                $"{AppSettingValue.UrlWebApi}/{IncomeWebApi.PrefixApi.Mapesac}/{IncomeWebApi.MethodApi.Mapesac.ListProyectos}";
            var result =
                InvokeWebApi.InvokePostAnonymousEntity<Response<List<ProyectoResponse>>>(urlApi, string.Empty);
            return Ok(result);
        }

        [HttpGet]
        [RequestLoggerFilterAttribute]
        [UnControlledExceptionFilterAttribute]
        [Route(IncomeWebApi.MethodApi.Mapesac.GetProyectoById)]
        public IHttpActionResult GetProyectoById()
        {
            var postData = HttpContext.Current.Request.Params["proyectoRequest"];
            var urlApi =
                $"{AppSettingValue.UrlWebApi}/{IncomeWebApi.PrefixApi.Mapesac}/{IncomeWebApi.MethodApi.Mapesac.GetProyectoById}";
            var result =
              InvokeWebApi.InvokePostAnonymousEntity<Response<ProyectoResponse>>(urlApi, postData);
            return Ok(result);
        }

        [HttpGet]
        [RequestLoggerFilterAttribute]
        [UnControlledExceptionFilterAttribute]
        [Route(IncomeWebApi.MethodApi.Authentication.Login)]
        public IHttpActionResult Login()
        {
            var postData = HttpContext.Current.Request.Params["userRequest"];
            var urlApi =
                $"{AppSettingValue.UrlWebApi}/{IncomeWebApi.PrefixApi.Authentication}/{IncomeWebApi.MethodApi.Authentication.Login}";
            var result =
              InvokeWebApi.InvokePostAnonymousEntity<Response<UserEntity>>(urlApi, postData);
            return Ok(result);
        }
    }
}