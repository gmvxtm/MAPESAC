using System.Net.Http;
using System.Web.Http.Cors;

namespace BaseArchitecture.Cross.Security.Base
{
    public class CorsPolicyFactory : ICorsPolicyProviderFactory
    {
        private readonly ICorsPolicyProvider _provider = new CorsPolicyAttribute();

        public ICorsPolicyProvider GetCorsPolicyProvider(HttpRequestMessage request)
        {
            return _provider;
        }
    }
}