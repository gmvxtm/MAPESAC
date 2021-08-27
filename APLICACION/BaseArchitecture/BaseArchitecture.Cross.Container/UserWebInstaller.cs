using System.Web;
using Castle.MicroKernel.Registration;
using Castle.MicroKernel.SubSystems.Configuration;
using Castle.Windsor;
using BaseArchitecture.Cross.SystemVariable.Variable;

namespace BaseArchitecture.Cross.Container
{
    public class UserWebInstaller : IWindsorInstaller
    {
        public void Install(IWindsorContainer container, IConfigurationStore store)
        {
            container.Register(
                Component.For<IncomeVariable>().UsingFactoryMethod(() =>
                        new IncomeVariable(HttpContext.Current.Request.UserHostName,
                            HttpContext.Current.Request.UserHostAddress))
                    .LifestyleScoped());
        }
    }
}