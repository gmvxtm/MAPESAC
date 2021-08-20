using Microsoft.Owin;
using Owin;
using BaseArchitecture.Distributed.ApiGateway;
using System.Web.Http;

[assembly: OwinStartup(typeof(Startup))]

namespace BaseArchitecture.Distributed.ApiGateway
{
    public class Startup
    {
        public void Configuration(IAppBuilder app)
        {
            app.UseWebApi(GlobalConfiguration.Configuration);
#if !DEBUG
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
        }
    }
}