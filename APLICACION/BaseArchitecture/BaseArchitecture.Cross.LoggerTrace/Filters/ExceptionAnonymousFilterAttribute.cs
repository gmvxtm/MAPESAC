using System;
using System.Net;
using System.Net.Http;
using System.Web.Http.Filters;
using BaseArchitecture.Cross.SystemVariable.Constant;

namespace BaseArchitecture.Cross.LoggerTrace.Filters
{
    public class ExceptionAnonymousFilterAttribute : ExceptionFilterAttribute
    {
        public override void OnException(HttpActionExecutedContext actionExecutedContext)
        {
            if (actionExecutedContext.Exception.Message.IndexOf(AppSettingValue.Unauthorized,
                StringComparison.Ordinal) != -1)
            {
                actionExecutedContext.Response = new HttpResponseMessage(HttpStatusCode.Unauthorized);
            }
            else
            {
                if (actionExecutedContext.Exception is NotImplementedException)
                    actionExecutedContext.Response = new HttpResponseMessage(HttpStatusCode.NotImplemented);
                actionExecutedContext.Response = new HttpResponseMessage(HttpStatusCode.InternalServerError);
            }
        }
    }
}