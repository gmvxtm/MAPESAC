using System.Web;
using System.Web.Http;

namespace BaseArchitecture.Distributed.WebApi
{
    public class WebApiApplication : HttpApplication
    {
        protected void Application_Start()
        {
            GlobalConfiguration.Configure(WebApiConfig.Register);
#if DEBUG
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