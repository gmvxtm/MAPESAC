using System.Net;
using System.Net.Http;
using System.Net.Http.Formatting;
using System.Threading;
using System.Threading.Tasks;
using System.Web.Http;
using System.Web.Http.Filters;
using Newtonsoft.Json;
using BaseArchitecture.Cross.SystemVariable.Enumerator;
using BaseArchitecture.Cross.SystemVariable.Model;
using BaseArchitecture.Cross.SystemVariable.Variable;

namespace BaseArchitecture.Cross.LoggerTrace.Filters
{
    public class UnControlledExceptionFilterAttribute : ExceptionFilterAttribute
    {
        #region Method Async

        public override async Task OnExceptionAsync(HttpActionExecutedContext actionExecutedContext,
            CancellationToken cancellationToken)
        {
            var errorResponse = new ErrorModel
            {
                ResponseCode = Enumerator.ResponseCode.UnControlledException,
                UniqueIdentifier = IncomeVariable.UniqueIdentifier,
                Message = "Error no uncontrolled"
            };
            var statusCode = actionExecutedContext.ActionContext.Response?.StatusCode ??
                             ((HttpWebResponse) ((WebException) actionExecutedContext.Exception).Response).StatusCode;
            actionExecutedContext.ActionContext.Response = actionExecutedContext.ActionContext.Request.CreateResponse
            (statusCode, errorResponse,
                JsonMediaTypeFormatter.DefaultMediaType);

            await base.OnExceptionAsync(actionExecutedContext, cancellationToken);
            await TraceLogger.RegisterExceptionAsync(actionExecutedContext.Exception, IncomeVariable);

            var incomeTraceLogger = new IncomeTraceLogger
            {
                Url = actionExecutedContext.Request.RequestUri.AbsoluteUri,
                Method = actionExecutedContext.Request.Method.Method,
                Body = JsonConvert.SerializeObject(errorResponse),
                StatusCode = (int) actionExecutedContext.Response.StatusCode,
                Type = "Response Error"
            };
            await TraceLogger.RegisterApiTraceAsync(incomeTraceLogger, IncomeVariable);
        }

        #endregion

        #region General Properties

        public IncomeVariable IncomeVariable =>
            (IncomeVariable) GlobalConfiguration.Configuration.DependencyResolver.GetService(typeof(IncomeVariable));

        public Trace TraceLogger =>
            (Trace) GlobalConfiguration.Configuration.DependencyResolver.GetService(typeof(Trace));

        #endregion
    }
}