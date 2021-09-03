using BaseArchitecture.Application.TransferObject.Response.Common;
using BaseArchitecture.Cross.LoggerTrace;
using BaseArchitecture.Repository.IData.NonTransactional;
using BaseArchitecture.Repository.IData.Transactional;
using System;
using System.Web.Http;
using System.Net.Mail;
using System.Net;
using BaseArchitecture.Application.IService.Mail;

namespace BaseArchitecture.Application.Service.Mail
{
    public class MailServices : IMailService
    {
        public IDemoQuery DemoQuery { get; set; }
        public IDemoTransaction DemoTransaction { get; set; }
        public Trace TraceLogger =>
            (Trace)GlobalConfiguration.Configuration.DependencyResolver.GetService(typeof(Trace));
        public Response<int> SendEmail()
        {
            Response<int> response;
            try
            {
                MailMessage message = new MailMessage();
                message.From = new MailAddress("no-reply@mapesac.com");
                message.To.Add(new MailAddress("ppardoz09@gmail.com"));
                message.Subject = "Send Mail Test";
                message.IsBodyHtml = true; //to make message body as html  
                message.Body = GetHtml();

                using (var smtp = new SmtpClient())
                {
                    smtp.Port = 587;//465; //25; 587;
                    smtp.Host = "smtp.gmail.com"; //for gmail host  
                    smtp.EnableSsl = true;
                    smtp.UseDefaultCredentials = false;
                    smtp.Credentials = new NetworkCredential("gmvxtm@gmail.com", "fabito12");
                    smtp.DeliveryMethod = SmtpDeliveryMethod.Network;
                    //smtp. = ServicePointManager.SecurityProtocol SecurityProtocolType.Tls;
                    smtp.Send(message);
                }
                
                response = new Response<int>(1);
            }
            catch (Exception e) 
            {
                var error = e.Message;
                response = new Response<int>(0);
            }
            return response;
        }
        public string GetHtml()
        {
            try
            {
                string messageBody = "<font>The following are the records: </font><br><br>";
                string htmlTableStart = "<table style=\"border-collapse:collapse; text-align:center;\" >";
                string htmlTableEnd = "</table>";
                string htmlHeaderRowStart = "<tr style=\"background-color:#6FA1D2; color:#ffffff;\">";
                string htmlHeaderRowEnd = "</tr>";
                string htmlTrStart = "<tr style=\"color:#555555;\">";
                string htmlTrEnd = "</tr>";
                string htmlBrEnd = "</br>";
                string htmlTdStart = "<td style=\" border-color:#5c87b2; border-style:solid; border-width:thin; padding: 5px;\">";
                string htmlTdEnd = "</td>";
                messageBody += htmlTableStart;
                messageBody += htmlHeaderRowStart;
                messageBody += htmlTdStart + "Estimado Encargado de Ventas " + htmlBrEnd;
                messageBody += "Se ha generado una nueva orden. " + htmlBrEnd;
                messageBody += "Revisar las órdenes pendientes de atención. " + htmlBrEnd;
                messageBody += "Atte.: MAPESAC" + htmlTdEnd;
                messageBody += htmlHeaderRowEnd;
                messageBody = messageBody + htmlTableEnd;
                return messageBody; // return HTML Table as string from this function  
            }
            catch (Exception ex)
            {
                return null;
            }
        }

    }
}