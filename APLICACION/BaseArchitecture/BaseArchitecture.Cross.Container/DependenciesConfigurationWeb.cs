using Castle.MicroKernel.Resolvers.SpecializedResolvers;
using Castle.Windsor;
using System.Collections.Generic;
using System.Web.Http.Dependencies;

namespace BaseArchitecture.Cross.Container
{
    public static class DependenciesConfigurationWeb
    {
        public static IDependencyResolver ConfigureWebCastleWindsor(string nameAssembly, IEnumerable<string> listAssembly)
        {
            var container = new WindsorContainer();
            container.Install(new UserWebInstaller());
            var assemblyInstaller1 = new WebApiInstaller
            {
                NameAssembly = nameAssembly
            };
            container.Install(assemblyInstaller1);
            DependenciesGlobalService.LoadServiceInstaller(container, listAssembly);
            container.Kernel.Resolver.AddSubResolver(new CollectionResolver(container.Kernel, true));
            var dependencyResolver = new WindsorDependencyResolver(container);

            return dependencyResolver;
        }
    }
}