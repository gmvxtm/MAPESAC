using System.Diagnostics;
using System.Threading;
using System.Threading.Tasks;
using Amazon.Runtime;
using FW.Cognito.Integration;
using FW.Cognito.Integration.Controllers;
using FW.Cognito.Integration.Models;
using NLog;
using BaseArchitecture.Cross.SystemVariable.Constant;

namespace BaseArchitecture.Cross.Security.Aws
{
    public class AwsHelper
    {
        public UserModel GetAccessCognito(string idToken, string accessToken)
        {
            var oauth = new CognitoOAuth();
            return oauth.LoginFederationClaims(idToken, accessToken);
        }

        public AWSCredentials GetAwsCredentials(string token, string identityPool)
        {
            return new CognitoRoles().GetCognitoAWSCredentials(identityPool, token);
        }

        public void SetLogger(string token, string identityPool)
        {
            Parallel.For(0, 1, index =>
                {
                    var cancellationTokenSource = new CancellationTokenSource();
                    Task.Factory.StartNew(delegate
                        {
                            var stopwatch = new Stopwatch();
                            stopwatch.Start();
                            var credentials = GetAwsCredentials(token, identityPool);
                            var logging = new AWSLogWrapper();
                            logging.Configure(credentials, IncomeTraceConfigureAws.AwsLogGroup, LogLevel.Debug,
                                IncomeTraceConfigureAws.AwsRegion);
                            var logger = LogManager.GetCurrentClassLogger();
                            stopwatch.Stop();
                            logger.Info(
                                $"Tiempo en obtener las credentials en milisegundos: {stopwatch.ElapsedMilliseconds}. TOken: {token}");
                        },
                        cancellationTokenSource.Token,
                        TaskCreationOptions.LongRunning,
                        TaskScheduler.Default);
                }
            );
        }
    }
}