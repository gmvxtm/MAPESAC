using System;
using System.Collections.Generic;
using System.Configuration;
using System.Diagnostics;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using BaseArchitecture.Cross.SystemVariable.Constant;
using Castle.MicroKernel.Registration;
using Castle.MicroKernel.SubSystems.Configuration;
using Castle.Windsor;
using FW.Cognito.Integration;
using FW.Cognito.Integration.Controllers;
using NLog;
using Trace = BaseArchitecture.Cross.LoggerTrace.Trace;

namespace BaseArchitecture.Cross.Container
{
    public class LoggerInstaller : IWindsorInstaller
    {
        public async void Install(IWindsorContainer container, IConfigurationStore store)
        {
            container.Register(
                Component.For<Trace>().UsingFactoryMethod((kernel) =>
                    {
                        var stopwatch = new Stopwatch();
                        stopwatch.Start();
                        var credentials = new CognitoRoles().GetCognitoAWSCredentials(IncomeTraceConfigureAws.AwsIdentityPool, IncomeTraceConfigureAws.AwsTokenLogger);

                        var logging = new AWSLogWrapper();
                        logging.Configure(credentials, IncomeTraceConfigureAws.AwsLogGroup, LogLevel.Debug, IncomeTraceConfigureAws.AwsRegion);
                        var logger = LogManager.GetCurrentClassLogger();
                        stopwatch.Stop();
                        logger.Info("Tiempo en obtener las credentials en milisegundos: " + stopwatch.ElapsedMilliseconds);
                        return new Trace() { Logger = logger };
                    })
                    .LifestyleSingleton()
            );
        }
    }
}