using System.Threading.Tasks;
using BaseArchitecture.Application.TransferObject.Request.Access;
using BaseArchitecture.Application.TransferObject.Request.Base;
using BaseArchitecture.Application.TransferObject.Response.Access;
using BaseArchitecture.Application.TransferObject.Response.Common;

namespace BaseArchitecture.Application.IService.Security
{
    public interface ISecurityService
    {
        Task<Response<LoginResponse>> GetUserAccess(LoginRequest loginRequest);
        Task<Response<AccessResponse>> GetProfileSiapp(BaseRequest baseRequest);
    }
}