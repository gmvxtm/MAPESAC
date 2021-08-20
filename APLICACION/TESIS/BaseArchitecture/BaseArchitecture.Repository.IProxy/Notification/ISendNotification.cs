using BaseArchitecture.Application.TransferObject.ExternalResponse;
using BaseArchitecture.Application.TransferObject.Request.Common;

namespace BaseArchitecture.Repository.IProxy.Notification
{
    public interface ISendNotification
    {
        MailNotificationResponse SendEmail(MailRequest mailRequest, string token);
        BaseResponse SendPhone(PhoneRequest phoneRequest, string token);
    }
}