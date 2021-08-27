using System;
using System.Collections.Generic;
using System.IO;
using System.Net;
using System.Text;
using Newtonsoft.Json;
using BaseArchitecture.Application.TransferObject.ExternalResponse;
using BaseArchitecture.Application.TransferObject.Request.Common;
using BaseArchitecture.Cross.SystemVariable.Constant;
using BaseArchitecture.Repository.IProxy.Notification;

namespace BaseArchitecture.Repository.Proxy.Notification
{
    public class SendNotification : ISendNotification
    {
        public MailNotificationResponse SendEmail(MailRequest mailRequest, string token)
        {
            var dictionary = new Dictionary<string, object>
            {
                {"AppOrigen", mailRequest.AppOrigin},
                {"CorreoFrom", mailRequest.MailFrom},
                {"CorreoFromAlias", mailRequest.MailFromAlias},
                {"CorreoSubject", mailRequest.MailSubject},
                {"CorreoTo", mailRequest.MailTo},
                {"CorreoCc", mailRequest.MailCc},
                {"CorreoBcc", mailRequest.MailBcc},
                {"CorreoBodyHtml", mailRequest.MailBodyHtml},
                {"CorreoBodyImg", mailRequest.MailBodyImg},
                {"CorreoAttached", mailRequest.MailAttached},
                {"File", mailRequest.FileAttached}
            };


            using (var webClient = new WebClient())
            {
                webClient.Headers.Add(HttpRequestHeader.Authorization, token);
                var boundary = "--------------------------" + DateTime.Now.Ticks.ToString("x");
                webClient.Headers.Add("Content-Type", "multipart/form-data; boundary=" + boundary);
                var fileData = webClient.Encoding.GetString(mailRequest.FileAttached);
                var generatedBodyParam = GeneratedBodyParam(mailRequest, dictionary, boundary, fileData);
                var bytes = webClient.Encoding.GetBytes(generatedBodyParam);
                var responseArray = webClient.UploadData(AppSettingValue.ServiceEmailQueue, "POST", bytes);
                var response = Encoding.ASCII.GetString(responseArray);
                var mailNotificationResponse = JsonConvert.DeserializeObject<MailNotificationResponse>(response);
                return mailNotificationResponse;
            }
        }

        public BaseResponse SendPhone(PhoneRequest phoneRequest, string token)
        {
            var dictionary = new Dictionary<string, object>
            {
                {"AppOrigen", phoneRequest.AppOrigin},
                {"NBody", phoneRequest.NBody},
                {"NTo", phoneRequest.NTo},
                {"NType", phoneRequest.NType}
            };


            using (var webClient = new WebClient())
            {
                webClient.Headers.Add(HttpRequestHeader.Authorization, token);
                var boundary = "--------------------------" + DateTime.Now.Ticks.ToString("x");
                webClient.Headers.Add("Content-Type", "multipart/form-data; boundary=" + boundary);
                var generatedBodyParam = GeneratedBodyParam(dictionary, boundary);
                var bytes = webClient.Encoding.GetBytes(generatedBodyParam);
                var responseArray = webClient.UploadData(AppSettingValue.ServicePhone, "POST", bytes);
                var response = Encoding.ASCII.GetString(responseArray);
                var baseResponse = JsonConvert.DeserializeObject<BaseResponse>(response);
                return baseResponse;
            }
        }

        protected static string GeneratedBodyParam(MailRequest mailRequest, IDictionary<string, object> dictionary,
            string boundary, string fileData)
        {
            var package = new StringBuilder();
            foreach (var entry in dictionary)
            {
                if (entry.Value == null) continue;
                var type = entry.Value.GetType();
                if (type.Name == "Byte[]")
                {
                    var filename = mailRequest.NameFileAttached;
                    if (string.IsNullOrEmpty(mailRequest.NameFileAttached))
                        filename = Path.GetFileName(mailRequest.NameFileAttached);
                    package.Append(
                        $"--{boundary}\r\nContent-Disposition: form-data; name=\"{filename}\"; filename=\"{filename}\"\r\n\r\n{fileData}\r\n");
                }
                else
                {
                    package.Append(
                        $"--{boundary}\r\nContent-Disposition: form-data; name=\"{entry.Key}\"; \r\n\r\n{entry.Value}\r\n");
                }
            }

            package.Append($"--{boundary}--\r\n");
            return package.ToString();
        }

        protected static string GeneratedBodyParam(IDictionary<string, object> dictionary, string boundary)
        {
            var package = new StringBuilder();
            foreach (var entry in dictionary)
            {
                if (entry.Value == null) continue;
                package.Append(
                    $"--{boundary}\r\nContent-Disposition: form-data; name=\"{entry.Key}\"; \r\n\r\n{entry.Value}\r\n");
            }

            package.Append($"--{boundary}--\r\n");
            return package.ToString();
        }
    }
}