using System.Web.Http;
using BaseArchitecture.Application.IService.Demo;
using BaseArchitecture.Application.IService.Security;
using BaseArchitecture.Application.IService.Table;
using BaseArchitecture.Application.TransferObject.Request.Access;
using BaseArchitecture.Application.TransferObject.Request.Demo;
using BaseArchitecture.Cross.LoggerTrace.Filters;
using BaseArchitecture.Cross.Security.Aws;
using BaseArchitecture.Cross.SystemVariable.Constant;
using BaseArchitecture.Repository.Entity;


namespace BaseArchitecture.Distributed.WebApi.Controllers
{
    [AllowAnonymous]
    [ExceptionAnonymousFilter]
    [RoutePrefix(IncomeWebApi.PrefixApi.Table)]    
    public class TableContoller : ApiController
    {
        public IDemoService DemoService { get; set; }
        public ITableService TableService { get; set; }

        [HttpPost]
        [Route(IncomeWebApi.MethodApi.Demo.ListMasterTableByValue)]        
        public IHttpActionResult ListMasterTableByValue(MasterTableRequest masterTableRequest)
        {
            var result = DemoService.ListMasterTableByValue(masterTableRequest);
            return Ok(result);
        }

        [HttpPost]
        [Route(IncomeWebApi.MethodApi.Demo.ListMasterTable)]
        public IHttpActionResult ListMasterTable(MasterTableRequest masterTableRequest)
        {
            var result = DemoService.ListMasterTable(masterTableRequest);
            return Ok(result);
        }

        [HttpPost]
        [Route(IncomeWebApi.MethodApi.Demo.GetPersonById)]
        public IHttpActionResult GetPersonById(PersonBaseRequest personBaseRequest)
        {
            var result = DemoService.GetPersonById(personBaseRequest);
            return Ok(result);
        }

        [HttpPost]
        [Route(IncomeWebApi.MethodApi.Demo.ListPersonAll)]
        public IHttpActionResult ListPersonAll(PersonFilterRequest personFilterRequest)
        {
            var result = DemoService.ListPersonAll(personFilterRequest);
            return Ok(result);
        }



        [HttpPost]
        [Route(IncomeWebApi.MethodApi.Mapesac.ListProyectos)]
        public IHttpActionResult ListProyectos()
        {
            var result = DemoService.ListProyectos();
            return Ok(result);
        }

        [HttpPost]
        [Route(IncomeWebApi.MethodApi.Mapesac.GetProyectoById)]
        public IHttpActionResult GetProyectoById(ProyectoRequest proyectoRequest)
        {
            var result = DemoService.GetProyectoById(proyectoRequest);
            return Ok(result);
        }

        [HttpPost]
        [Route(IncomeWebApi.MethodApi.Authentication.Login)]
        public IHttpActionResult Login(UserEntity userRequest)
        {
            var result = TableService.Login(userRequest);
            return Ok(result);
        }

        [HttpPost]
        [Route(IncomeWebApi.MethodApi.Mapesac.ListProduct)]
        public IHttpActionResult ListProduct()
        {            
            var result = TableService.ListProduct();
            return Ok(result);
        }

        [HttpPost]
        [Route(IncomeWebApi.MethodApi.Mapesac.ListUbi)]
        public IHttpActionResult ListUbi()
        {
            var result = TableService.ListUbi();
            return Ok(result);
        }
    }
}