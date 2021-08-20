using Castle.MicroKernel.Registration;
using Castle.MicroKernel.SubSystems.Configuration;
using Castle.Windsor;

namespace BaseArchitecture.Cross.Container
{
    public class ServiceInstaller : IWindsorInstaller
    {
        public string NameAssembly { get; set; }

        public void Install(IWindsorContainer container, IConfigurationStore store)
        {
            container.Register(Classes.FromAssemblyNamed(NameAssembly)
                .Pick()
                .LifestyleTransient()
                .WithService
                .DefaultInterfaces()
            );
        }
    }
}