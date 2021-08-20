using System;
using System.Linq;
using System.Net;
using System.Net.Http;
using System.Threading;
using System.Threading.Tasks;
using FW.Cognito.Integration.Controllers;
using Microsoft.IdentityModel.Tokens;
using BaseArchitecture.Cross.SystemVariable.Constant;
using BaseArchitecture.Cross.SystemVariable.Util;
using static BaseArchitecture.Cross.SystemVariable.Constant.IncomeWebApi;

namespace BaseArchitecture.Distributed.WebApi.Security
{
    /// <summary>
    ///     Token validator for Authorization Request using a DelegatingHandler
    /// </summary>
    internal class TokenValidationHandler : DelegatingHandler
    {
        private static bool TryRetrieveToken(HttpRequestMessage request, out string token)
        {
            token = null;
            var absolutePath = request.RequestUri.AbsolutePath;
            if (!request.Headers.TryGetValues("Authorization", out var authHeaders)
                && (absolutePath.Contains(MethodAllowAnonymous.LoginAllowAnonymous )
                || absolutePath.Contains(MethodAllowAnonymous.ListProyectosAllowAnonymous )
                    || absolutePath.ToLower().Contains(MethodAllowAnonymous.SwaggerAllowAnonymous.ToLower())
                    || absolutePath == "/"))
                return false;

            //var enumerable = authHeaders as string[] ?? authHeaders.ToArray();
            //if (enumerable.Count() > 1) return false;
            //var bearerToken = enumerable.ElementAt(0);
            //token = bearerToken.StartsWith("Bearer ") ? bearerToken.Substring(7) : bearerToken;
            return true;
        }

        protected override Task<HttpResponseMessage> SendAsync(HttpRequestMessage request,
            CancellationToken cancellationToken)
        {
            HttpStatusCode statusCode;
            if (!TryRetrieveToken(request, out var token)) return base.SendAsync(request, cancellationToken);

            try
            {
                var oauth = new CognitoOAuth();
                var objectUser = oauth.LoginFederationClaims(token, string.Empty);
                if (objectUser == null)
                    return Task<HttpResponseMessage>.Factory.StartNew(
                        () => new HttpResponseMessage(HttpStatusCode.Unauthorized),
                        cancellationToken);
                if (!objectUser.Iss.Contains(IncomeTraceConfigureAws.AwsUserPool))
                    return Task<HttpResponseMessage>.Factory.StartNew(
                        () => new HttpResponseMessage(HttpStatusCode.Unauthorized),
                        cancellationToken);

                if (General.ValidatedTimeExpire(Convert.ToInt32(objectUser.Exp)))
                    return Task<HttpResponseMessage>.Factory.StartNew(
                        () => new HttpResponseMessage(HttpStatusCode.Unauthorized),
                        cancellationToken);

                return base.SendAsync(request, cancellationToken);
            }
            catch (SecurityTokenValidationException)
            {
                statusCode = HttpStatusCode.Unauthorized;
            }
            catch (Exception)
            {
                statusCode = HttpStatusCode.InternalServerError;
            }

            return Task<HttpResponseMessage>.Factory.StartNew(() => new HttpResponseMessage(statusCode),
                cancellationToken);
        }
    }
}