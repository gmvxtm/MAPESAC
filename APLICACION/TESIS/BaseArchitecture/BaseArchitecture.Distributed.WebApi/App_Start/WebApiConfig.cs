using System.Web.Http;
using BaseArchitecture.Cross.Security.Base;
using BaseArchitecture.Distributed.WebApi.Security;

namespace BaseArchitecture.Distributed.WebApi
{
    public static class WebApiConfig
    {
        public static void Register(HttpConfiguration config)
        {
            // Web API configuration and services
            //descomentar
            //config.MessageHandlers.Add(new TokenValidationHandler());

            // Web API routes
            config.MapHttpAttributeRoutes();
            config.SetCorsPolicyProviderFactory(new CorsPolicyFactory());
            config.EnableCors();
        }
    }
}