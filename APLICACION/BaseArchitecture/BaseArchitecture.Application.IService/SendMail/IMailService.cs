using BaseArchitecture.Application.TransferObject.Response.Common;
using BaseArchitecture.Repository.Entity.Tables;
using System.Collections.Generic;

namespace BaseArchitecture.Application.IService.Mail
{
    public interface IMailService
    {
        Response<int> SendEmail(string emailTo,string codeOrder);
        string GetHtml(string codeOrder);
        string GetHtmlOutOfStock(List<ProductOutOfStockEntity> listProductOutOfStock);
    }
}