using System;
using System.Net.Http;
using System.Threading;
using System.Threading.Tasks;
using System.Web.Cors;
using System.Web.Http.Cors;
using BaseArchitecture.Cross.SystemVariable.Constant;

namespace BaseArchitecture.Cross.Security.Base
{
    [AttributeUsage(AttributeTargets.Method | AttributeTargets.Class)]
    public class CorsPolicyAttribute : Attribute, ICorsPolicyProvider
    {
        private readonly CorsPolicy _policy;

        public CorsPolicyAttribute()
        {
            _policy = new CorsPolicy
            {
                AllowAnyMethod = true,
                AllowAnyHeader = true
            };
            _policy.Origins.Clear();
            var origins = AppSettingValue.AllowedOriginsUrl.Split(',');

            foreach (var origin in origins) _policy.Origins.Add(origin);
        }

        public Task<CorsPolicy> GetCorsPolicyAsync(HttpRequestMessage request, CancellationToken cancellationToken)
        {
            return Task.FromResult(_policy);
        }
    }
}