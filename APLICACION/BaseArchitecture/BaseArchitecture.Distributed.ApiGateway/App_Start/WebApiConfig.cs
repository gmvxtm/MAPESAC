using System.Web.Http;
using BaseArchitecture.Cross.Security.Base;

namespace BaseArchitecture.Distributed.ApiGateway
{
    public static class WebApiConfig
    {
        public static void Register(HttpConfiguration config)
        {
            config.MapHttpAttributeRoutes();
            config.SetCorsPolicyProviderFactory(new CorsPolicyFactory());
            config.EnableCors();
        }
    }
}