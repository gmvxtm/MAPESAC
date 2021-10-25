using System.Web.Http;
using BaseArchitecture.Application.IService.Mail;
using BaseArchitecture.Application.IService.Security;
using BaseArchitecture.Application.IService.Table;
using BaseArchitecture.Cross.LoggerTrace.Filters;
using BaseArchitecture.Cross.SystemVariable.Constant;
using BaseArchitecture.Repository.Entity;
using BaseArchitecture.Repository.Entity.Tables;

namespace BaseArchitecture.Distributed.WebApi.Controllers
{
    [AllowAnonymous]
    [ExceptionAnonymousFilter]
    [RoutePrefix(IncomeWebApi.PrefixApi.Authentication)]
    public class AuthenticationController : ApiController
    {
        public ISecurityService SecurityService { get; set; }
        public ITableService TableService { get; set; }
        public IMailService MailService { get; set; }
        //public IDemoService DemoService { get; set; }


        [HttpPost]
        [Route(IncomeWebApi.MethodApi.Demo.ListMasterTableByValue)]
        public IHttpActionResult ListMasterTableByValue(MasterTableEntity masterTableRequest)
        {
            var result = TableService.ListMasterTableByValue(masterTableRequest);
            return Ok(result);
        }

        [HttpPost]
        [Route(IncomeWebApi.MethodApi.Demo.ListMasterTable)]
        public IHttpActionResult ListMasterTable(MasterTableEntity masterTableRequest)
        {
            var result = TableService.ListMasterTable(masterTableRequest);
            return Ok(result);
        }

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
        [Route(IncomeWebApi.MethodApi.Mapesac.SendEmail)]
        public IHttpActionResult SendEmail()
        {
            var result = MailService.SendEmail("","");
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

        [HttpPost]
        [Route(IncomeWebApi.MethodApi.Mapesac.GetOrderByCodeOrder)]
        public IHttpActionResult GetOrderByCodeOrder(OrderEntity orderRequest)
        {
            var result = TableService.GetOrderByCodeOrder(orderRequest);
            return Ok(result);
        }

        [HttpPost]
        [Route(IncomeWebApi.MethodApi.Mapesac.UpdOrderFlow)]
        public IHttpActionResult UpdOrderFlow(OrderFlowEntity orderFlowRequest)
        {
            var result = TableService.UpdOrderFlow(orderFlowRequest);
            return Ok(result);
        }

        [HttpPost]
        [Route(IncomeWebApi.MethodApi.Mapesac.UpdSubOrderFlow)]
        public IHttpActionResult UpdSubOrderFlow(OrderFlowEntity orderFlowRequest)
        {
            var result = TableService.UpdSubOrderFlow(orderFlowRequest);
            return Ok(result);
        }

        [HttpPost]
        [Route(IncomeWebApi.MethodApi.Mapesac.ListOrderByLocation)]
        public IHttpActionResult ListOrderByLocation(OrderEntity orderRequest)
        {
            var result = TableService.ListOrderByLocation(orderRequest);
            return Ok(result);
        }

        [HttpPost]
        [Route(IncomeWebApi.MethodApi.Mapesac.ListSubOrderByLocation)]
        public IHttpActionResult ListSubOrderByLocation(OrderEntity orderRequest)
        {
            var result = TableService.ListSubOrderByLocation(orderRequest);
            return Ok(result);
        }

        [HttpPost]
        [Route(IncomeWebApi.MethodApi.Mapesac.ListSuppliesByProduct)]
        public IHttpActionResult ListSuppliesByProduct(ProductEntity suppliesByProductRequest)
        {
            var result = TableService.ListSuppliesByProduct(suppliesByProductRequest);
            return Ok(result);
        }

        [HttpPost]
        [Route(IncomeWebApi.MethodApi.Mapesac.UpdDecrease)]
        public IHttpActionResult UpdDecrease(DecreaseEntity decreaseRequest)
        {
            var result = TableService.UpdDecrease(decreaseRequest);
            return Ok(result);
        }

        [HttpPost]
        [Route(IncomeWebApi.MethodApi.Mapesac.ListSupplies)]
        public IHttpActionResult ListSupplies()
        {
            var result = TableService.ListSupplies();
            return Ok(result);
        }

        [HttpPost]
        [Route(IncomeWebApi.MethodApi.Mapesac.ListSuppliersByIdSupply)]
        public IHttpActionResult ListSuppliersByIdSupply(SupplyEntity supplyRequest)
        {
            var result = TableService.ListSuppliersByIdSupply(supplyRequest);
            return Ok(result);
        }

        [HttpPost]
        [Route(IncomeWebApi.MethodApi.Mapesac.InsBuySupply)]
        public IHttpActionResult InsBuySupply(BuySupplyEntity buySupplyRequest)
        {
            var result = TableService.InsBuySupply(buySupplyRequest);
            return Ok(result);
        }

        [HttpPost]
        [Route(IncomeWebApi.MethodApi.Mapesac.RptListProductQuantity)]
        public IHttpActionResult RptListProductQuantity()
        {
            var result = TableService.RptListProductQuantity();
            return Ok(result);
        }

        [HttpPost]
        [Route(IncomeWebApi.MethodApi.Mapesac.RptListOrderQuantity)]
        public IHttpActionResult RptListOrderQuantity()
        {
            var result = TableService.RptListOrderQuantity();
            return Ok(result);
        }

        [HttpPost]
        [Route(IncomeWebApi.MethodApi.Mapesac.RptListOrderQuantityStatus)]
        public IHttpActionResult RptListOrderQuantityStatus()
        {
            var result = TableService.RptListOrderQuantityStatus();
            return Ok(result);
        }

        [HttpPost]
        [Route(IncomeWebApi.MethodApi.Mapesac.RptListOrderQuantityStatusDelivery)]
        public IHttpActionResult RptListOrderQuantityStatusDelivery()
        {
            var result = TableService.RptListOrderQuantityStatusDelivery();
            return Ok(result);
        }

        [HttpPost]
        [Route(IncomeWebApi.MethodApi.Mapesac.RptListSuppliesMostUsedByMonth)]
        public IHttpActionResult RptListSuppliesMostUsedByMonth()
        {
            var result = TableService.RptListSuppliesMostUsedByMonth();
            return Ok(result);
        }

        [HttpPost]
        [Route(IncomeWebApi.MethodApi.Mapesac.RptListSuppliesDecreaseByMonth)]
        public IHttpActionResult RptListSuppliesDecreaseByMonth()
        {
            var result = TableService.RptListSuppliesDecreaseByMonth();
            return Ok(result);
        }

        [HttpPost]
        [Route(IncomeWebApi.MethodApi.Mapesac.RptGanttOrdersLastMonth)]
        public IHttpActionResult RptGanttOrdersLastMonth()
        {
            var result = TableService.RptGanttOrdersLastMonth();
            return Ok(result);
        }

        [HttpPost]
        [Route(IncomeWebApi.MethodApi.Mapesac.UpdSubOrderFlowDetail)]
        public IHttpActionResult UpdSubOrderFlowDetail(SubOrderFlowDetailEntity subOrderFlowDetailRequest)
        {
            var result = TableService.UpdSubOrderFlowDetail(subOrderFlowDetailRequest);
            return Ok(result);
        }
    }
}