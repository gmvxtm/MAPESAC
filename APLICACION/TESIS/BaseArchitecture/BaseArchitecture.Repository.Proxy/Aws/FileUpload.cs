using System;
using System.IO;
using System.Threading.Tasks;
using Amazon.S3;
using Amazon.S3.Model;
using Amazon.S3.Transfer;
using BaseArchitecture.Application.TransferObject.Request.Base;
using BaseArchitecture.Application.TransferObject.Response.Common;
using BaseArchitecture.Cross.SystemVariable.Constant;
using BaseArchitecture.Cross.SystemVariable.Model;
using BaseArchitecture.Repository.IProxy.Aws;

namespace BaseArchitecture.Repository.Proxy.Aws
{
    public class FileUpload : IFileUpload

    {
        public FileResponse UploadFileS3(FileModel fileModel, BaseRequest baseRequest)
        {
            if (string.IsNullOrEmpty(fileModel.NameFile)) return new FileResponse();
            var namePhysicalFile = $"{fileModel.NameFile}";
            var amazonS3Config = new AmazonS3Config {ServiceURL = IncomeTraceConfigureAws.AwsRegionEndPointS3};
            var stream = new MemoryStream(fileModel.Buffer);
            using (var client = new AmazonS3Client(
                baseRequest.AwsAccessKey,
                baseRequest.AwsSecretKey,
                baseRequest.AwsSessionToken,
                amazonS3Config))
            {
                var utility = new TransferUtility(client);
                var request = new TransferUtilityUploadRequest
                {
                    BucketName = $"{IncomeTraceConfigureAws.AwsBucketName}",
                    Key = namePhysicalFile,
                    InputStream = stream
                };
                utility.Upload(request);
                return new FileResponse(namePhysicalFile, request.Key);
            }
        }

        public async Task<bool> DeleteFileS3(FileResponse fileResponse, BaseRequest baseRequest)
        {
            var amazonS3Config = new AmazonS3Config {ServiceURL = IncomeTraceConfigureAws.AwsRegionEndPointS3};
            using (var client = new AmazonS3Client(
                baseRequest.AwsAccessKey,
                baseRequest.AwsSecretKey,
                baseRequest.AwsSessionToken,
                amazonS3Config))
            {
                var request = new DeleteObjectRequest
                {
                    BucketName = IncomeTraceConfigureAws.AwsBucketComplete,
                    Key = $"{fileResponse.PathFile}/{fileResponse.NamePhysicalFile}"
                };
                await client.DeleteObjectAsync(request);
                return true;
            }
        }

        public string DownloadFileS3(FileResponse fileResponse, BaseRequest baseRequest)
        {
            var key = $"{fileResponse.PathFile}";
            string urlIng;
            var amazonS3Config = new AmazonS3Config {ServiceURL = IncomeTraceConfigureAws.AwsRegionEndPointS3};
            using (IAmazonS3 client = new AmazonS3Client(
                baseRequest.AwsAccessKey,
                baseRequest.AwsSecretKey,
                baseRequest.AwsSessionToken,
                amazonS3Config))
            {
                urlIng = client.GeneratePreSignedURL(IncomeTraceConfigureAws.AwsBucketName, key,
                    DateTime.Now.AddDays(IncomeTraceConfigureAws.AwsDayExpire), null);
            }

            return urlIng;
        }

        public void DownloadFilePath(FileResponse fileResponse, BaseRequest baseRequest)
        {
            var key = $"{fileResponse.PathFile}";
            var amazonS3Config = new AmazonS3Config {ServiceURL = IncomeTraceConfigureAws.AwsRegionEndPointS3};
            using (IAmazonS3 client = new AmazonS3Client(
                baseRequest.AwsAccessKey,
                baseRequest.AwsSecretKey,
                baseRequest.AwsSessionToken,
                amazonS3Config))
            {
                var utility = new TransferUtility(client);
                utility.Download(fileResponse.NamePhysicalFile, IncomeTraceConfigureAws.AwsBucketName, key);
            }
        }
    }
}