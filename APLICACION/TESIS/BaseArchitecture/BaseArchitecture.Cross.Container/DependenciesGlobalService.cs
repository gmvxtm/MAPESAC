using Castle.Windsor;
using System.Collections.Generic;

namespace BaseArchitecture.Cross.Container
{
    public static class DependenciesGlobalService
    {
        public static void LoadServiceInstaller(WindsorContainer container, IEnumerable<string> listAssembly)
        {
            var assemblyInstaller = new ServiceInstaller();
            foreach (var nameAssembly in listAssembly)
            {
                assemblyInstaller.NameAssembly = nameAssembly;
                container.Install(assemblyInstaller);
            }
        }
    }
}
