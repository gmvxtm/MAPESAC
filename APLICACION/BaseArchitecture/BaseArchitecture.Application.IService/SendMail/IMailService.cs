using BaseArchitecture.Application.TransferObject.Response.Common;

namespace BaseArchitecture.Application.IService.Mail
{
    public interface IMailService
    {
        Response<int> SendEmail();
    }
}