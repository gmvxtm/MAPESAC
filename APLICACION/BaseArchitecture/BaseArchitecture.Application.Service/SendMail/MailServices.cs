using BaseArchitecture.Application.TransferObject.Response.Common;
using BaseArchitecture.Cross.LoggerTrace;
using BaseArchitecture.Repository.IData.NonTransactional;
using BaseArchitecture.Repository.IData.Transactional;
using System;
using System.Web.Http;
using System.Net.Mail;
using System.Net;
using BaseArchitecture.Application.IService.Mail;
using BaseArchitecture.Cross.SystemVariable.Constant;
using BaseArchitecture.Repository.Entity.Tables;
using System.Collections.Generic;

namespace BaseArchitecture.Application.Service.Mail
{
    public class MailServices : IMailService
    {
        public IDemoQuery DemoQuery { get; set; }
        public IDemoTransaction DemoTransaction { get; set; }
        public Trace TraceLogger =>
            (Trace)GlobalConfiguration.Configuration.DependencyResolver.GetService(typeof(Trace));
        public Response<int> SendEmail(string emailTo, string body)
        {
            Response<int> response;
            string emails = "";
            try
            {
                //if (!string.IsNullOrEmpty(emailTo))
                //    emails = emailTo + "; " + AppSettingValue.EmailSalesResponsible;
                MailMessage message = new MailMessage();
                message.From = new MailAddress("no-reply@mapesac.com");
                message.To.Add(new MailAddress(emailTo));
                message.CC.Add(new MailAddress(AppSettingValue.EmailSalesResponsible));
                message.Subject = "Send Mail Test";
                message.IsBodyHtml = true;
                message.Body = body;
                //message.Body = GetHtml(codeOrder);

                using (var smtp = new SmtpClient())
                {
                    smtp.Port = 587;
                    smtp.Host = "smtp.gmail.com";
                    smtp.EnableSsl = true;
                    smtp.UseDefaultCredentials = false;  
                    smtp.Credentials = new NetworkCredential("no.reply.MAPESAC@gmail.com", "mp123456*");
                    smtp.DeliveryMethod = SmtpDeliveryMethod.Network;
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
        public string GetHtml(string codeOrder)
        {
            try
            {
                string messageBody = "";
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
                messageBody += htmlTdStart + "Estimado Encargado de Ventas " + htmlBrEnd + "<br>";

                messageBody += "Se ha generado una nueva orden " + codeOrder + ". " + htmlBrEnd + "<br>";
                messageBody += "Revisar las órdenes pendientes de atención. " + htmlBrEnd + "<br>";
                messageBody += "Atte.: MAPESAC" + htmlTdEnd;
                messageBody += htmlHeaderRowEnd;
                messageBody = messageBody + htmlTableEnd;
                return messageBody;
            }
            catch (Exception ex)
            {
                return null;
            }
        }

        public string GetHtmlOutOfStock(List<ProductOutOfStockEntity> listProductOutOfStock)
        {
            try
            {
                string messageBody = "";
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
                messageBody += htmlTdStart + "Estimado Encargado de Almacén " + htmlBrEnd + "<br>";
                messageBody += "Los siguientes insumos se encuentran por debajo del Stock Mínimo" + htmlBrEnd + "<br>";
                messageBody += htmlTdEnd;
                messageBody += htmlTrStart;
                messageBody += htmlTdStart + "Insumo" + htmlTdEnd;
                messageBody += htmlTdStart + "Stock" + htmlTdEnd;
                messageBody += htmlTdStart + "Stock Mínimo" + htmlTdEnd;
                messageBody += htmlTdStart + "Unidad de Medida" + htmlTdEnd;
                messageBody += htmlTrEnd;
                foreach(var item in listProductOutOfStock)
                {
                    messageBody += htmlTrStart;
                    messageBody += htmlTdStart + item.Name + htmlTdEnd;
                    messageBody += htmlTdStart + item.Stock + htmlTdEnd;
                    messageBody += htmlTdStart + item.MinimumStock + htmlTdEnd;
                    messageBody += htmlTdStart + item.MeasureUnit + htmlTdEnd;
                    messageBody += htmlTrEnd;
                }
                messageBody += "Favor de realizar el estudio de mercado respectivo y programar la compra de dichos insumos." + htmlBrEnd + "<br>";
                messageBody += "Atte.: MAPESAC" + htmlTdEnd;
                messageBody += htmlHeaderRowEnd;
                messageBody = messageBody + htmlTableEnd;
                return messageBody;
            }
            catch (Exception ex)
            {
                return null;
            }
        }

    }
}