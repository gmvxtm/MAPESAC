using System;
using System.IO;
using System.Net;
using System.Net.Http;
using System.Net.Http.Formatting;
using System.Threading;
using System.Threading.Tasks;
using System.Web.Http;
using System.Web.Http.Controllers;
using System.Web.Http.Filters;
using Newtonsoft.Json;
using BaseArchitecture.Cross.SystemVariable.Enumerator;
using BaseArchitecture.Cross.SystemVariable.Model;
using BaseArchitecture.Cross.SystemVariable.Variable;

namespace BaseArchitecture.Cross.LoggerTrace.Filters
{
    public class RequestLoggerFilterAttribute : ActionFilterAttribute
    {
        #region General Properties

        public IncomeVariable IncomeVariable =>
            (IncomeVariable) GlobalConfiguration.Configuration.DependencyResolver.GetService(typeof(IncomeVariable));

        public Trace TraceLogger =>
            (Trace) GlobalConfiguration.Configuration.DependencyResolver.GetService(typeof(Trace));

        #endregion

        #region Method Async

        public override async Task OnActionExecutingAsync(HttpActionContext actionContext,
            CancellationToken cancellationToken)
        {
            var owinRequestContext = actionContext.ControllerContext.Request.GetOwinContext();

            var bodyStreamRequest = new StreamReader(owinRequestContext.Request.Body);
            bodyStreamRequest.BaseStream.Seek(0, SeekOrigin.Begin);
            var bodyTextRequest = await bodyStreamRequest.ReadToEndAsync();
            bodyStreamRequest.BaseStream.Seek(0, SeekOrigin.Begin);

            var incomeTraceLogger = new IncomeTraceLogger
            {
                Url = actionContext.Request.RequestUri.AbsoluteUri,
                Method = actionContext.Request.Method.Method,
                Body = bodyTextRequest,
                Header = JsonConvert.SerializeObject(actionContext.ControllerContext.Request.Headers),
                Type = "Request"
            };

            await TraceLogger.RegisterApiTraceAsync(incomeTraceLogger, IncomeVariable);


            if (!actionContext.ModelState.IsValid)
            {
                if (actionContext.ModelState.Count > 0)
                {
                    var modelException = new Exception();
                    foreach (var item in actionContext.ModelState) modelException.Data.Add(item.Key, item.Value);
                    await TraceLogger.RegisterExceptionAsync(modelException, IncomeVariable);
                }

                actionContext.Response = actionContext.Request.CreateResponse(HttpStatusCode.BadRequest, new ErrorModel
                {
                    ResponseCode = Enumerator.ResponseCode.BadRequest,
                    UniqueIdentifier = IncomeVariable.UniqueIdentifier,
                    Message = "Error no requestLogger"
                }, JsonMediaTypeFormatter.DefaultMediaType);

                var executedContext = new HttpActionExecutedContext(actionContext, null);
                await OnActionExecutedAsync(executedContext, cancellationToken);
            }
        }

        public override async Task OnActionExecutedAsync(HttpActionExecutedContext actionExecutedContext,
            CancellationToken cancellationToken)
        {
            if (actionExecutedContext.Response != null &&
                actionExecutedContext.Response.TryGetContentValue(out object responseContent))
            {
                var incomeTraceLogger = new IncomeTraceLogger
                {
                    Url = actionExecutedContext.Request.RequestUri.AbsoluteUri,
                    Method = actionExecutedContext.Request.Method.Method,
                    Body = JsonConvert.SerializeObject(responseContent),
                    StatusCode = (int) actionExecutedContext.Response.StatusCode,
                    Type = "Response"
                };
                await TraceLogger.RegisterApiTraceAsync(incomeTraceLogger, IncomeVariable);
            }

            await base.OnActionExecutedAsync(actionExecutedContext, cancellationToken);
        }

        #endregion
    }
}