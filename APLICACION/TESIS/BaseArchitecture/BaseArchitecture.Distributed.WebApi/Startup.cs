using Microsoft.Owin;
using Owin;
using BaseArchitecture.Distributed.WebApi;
using System.Web.Http;

[assembly: OwinStartup(typeof(Startup))]

namespace BaseArchitecture.Distributed.WebApi
{
    public class Startup
    {
        public void Configuration(IAppBuilder app)
        {
            app.UseWebApi(GlobalConfiguration.Configuration);
#if !DEBUG
            var listAssembly = new System.Collections.Generic.List<string>
            {
                "BaseArchitecture.Application.IService",
                "BaseArchitecture.Application.Service",
                "BaseArchitecture.Cross.Mapper",
                "BaseArchitecture.Repository.IProxy",
                "BaseArchitecture.Repository.Proxy",
                "BaseArchitecture.Cross.SystemVariable",
                "BaseArchitecture.Application.TransferObject",
                "BaseArchitecture.Repository.Entity",
                "BaseArchitecture.Repository.IData",
                "BaseArchitecture.Repository.Data",
                "BaseArchitecture.Cross.LoggerTrace",
                "BaseArchitecture.Cross.Security"
            };
            Cross.Mapper.Mapping.GeneralMapping.Create();
            GlobalConfiguration.Configuration.DependencyResolver =
 Cross.Container.DependenciesConfigurationWeb.ConfigureWebCastleWindsor("BaseArchitecture.Distributed.WebApi", listAssembly);
#endif
        }
    }
}