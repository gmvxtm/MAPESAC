using System.Web;
using System.Web.Http;

namespace BaseArchitecture.Distributed.ApiGateway
{
    public class WebApiApplication : HttpApplication
    {
        protected void Application_Start()
        {
#if DEBUG
            var listAssembly = new System.Collections.Generic.List<string>
            {
                "BaseArchitecture.Cross.SystemVariable",
                "BaseArchitecture.Application.TransferObject",
                "BaseArchitecture.Cross.Security",
                "BaseArchitecture.Cross.LoggerTrace"
            };
            GlobalConfiguration.Configuration.DependencyResolver =
                Cross.Container.DependenciesConfigurationWeb.ConfigureWebCastleWindsor("BaseArchitecture.Distributed.ApiGateway", listAssembly);
#endif
            GlobalConfiguration.Configure(WebApiConfig.Register);
        }
    }
}