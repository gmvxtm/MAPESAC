using System.Threading.Tasks;
using BaseArchitecture.Application.TransferObject.ExternalResponse;
using BaseArchitecture.Application.TransferObject.Request.Access;
using BaseArchitecture.Application.TransferObject.Request.External;

namespace BaseArchitecture.Repository.IProxy.Siapp
{
    public interface ISiapp
    {
        Task<ServerControlResponse> GetUserSiapp(LoginRequest loginRequest);
        ProfileSiappsResponse SetUserProfileSiapp(ApplicationProfileRequest applicationProfileRequest);
    }
}