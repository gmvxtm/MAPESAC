using System.Threading.Tasks;
using BaseArchitecture.Application.TransferObject.Request.Base;
using BaseArchitecture.Application.TransferObject.Response.Common;
using BaseArchitecture.Cross.SystemVariable.Model;

namespace BaseArchitecture.Repository.IProxy.Aws
{
    public interface IFileUpload
    {
        FileResponse UploadFileS3(FileModel fileModel, BaseRequest baseRequest);
        Task<bool> DeleteFileS3(FileResponse fileResponse, BaseRequest baseRequest);
        string DownloadFileS3(FileResponse fileResponse, BaseRequest baseRequest);
        void DownloadFilePath(FileResponse fileResponse, BaseRequest baseRequest);
    }
}