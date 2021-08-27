using System;
using System.Configuration;

namespace BaseArchitecture.Cross.SystemVariable.Constant
{
    public static class IncomeTraceConfigureAws
    {
        public static readonly string AwsIdentityPool = ConfigurationManager.AppSettings.Get("AWS_IDENTITY_POOL");
        public static readonly string AwsClientId = ConfigurationManager.AppSettings.Get("AWS_CLIENT_ID");
        public static readonly string AwsUserPool = ConfigurationManager.AppSettings.Get("AWS_USER_POOL");
        public static readonly string AwsLogGroup = ConfigurationManager.AppSettings.Get("AWS_LOG_GROUP");
        public static readonly string AwsRegion = ConfigurationManager.AppSettings.Get("AWS_REGION");

        public static readonly string AwsBucketName = ConfigurationManager.AppSettings.Get("AWS_BUCKET_NAME");
        public static readonly string AwsBucketFolder = ConfigurationManager.AppSettings.Get("AWS_BUCKET_FOLDER");

        public static readonly string AwsBucketComplete =
            $"{ConfigurationManager.AppSettings["AWS_BUCKET_NAME"]}/{ConfigurationManager.AppSettings["AWS_BUCKET_FOLDER"]}";

        public static readonly string AwsRegionEndPointS3 =
            ConfigurationManager.AppSettings.Get("AWS_REGION_END_POINT_S3");

        public static readonly int AwsDayExpire =
            Convert.ToInt32(ConfigurationManager.AppSettings.Get("AWS_DAYS_EXPIRE"));
    }
}