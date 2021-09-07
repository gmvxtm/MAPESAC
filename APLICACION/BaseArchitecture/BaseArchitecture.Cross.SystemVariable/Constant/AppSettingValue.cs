using System.Configuration;

namespace BaseArchitecture.Cross.SystemVariable.Constant
{
    public static class AppSettingValue
    {
        public const string NameApplication = "BaseArchitecture";
        public const string Unauthorized = "401";
        public const string Error = "Error";
        public static readonly string UrlSiapps = ConfigurationManager.AppSettings.Get("URL_SIAPPS");

        public static readonly string UrlServiceUserProfile =
            ConfigurationManager.AppSettings.Get("URL_SERVICE_USER_PROFILE");

        public static readonly string ServiceEmailQueue =
            ConfigurationManager.AppSettings.Get("URL_SERVICE_EMAIL_QUEUE");

        public static readonly string ServicePhone = ConfigurationManager.AppSettings.Get("URL_SERVICE_PHONE_QUEUE");
        public static readonly string UrlWebApi = ConfigurationManager.AppSettings.Get("URL_WEB_API");
        public static readonly string AllowedOriginsUrl = ConfigurationManager.AppSettings.Get("ALLOWED_ORIGINS_URL");
        public static readonly string LogFilePath = ConfigurationManager.AppSettings.Get("LOG_FILE_PATH");
        public static readonly string FileTemp = ConfigurationManager.AppSettings.Get("FILE_TEMP");
        public static readonly string EmailSalesResponsible = ConfigurationManager.AppSettings.Get("EMAIL_SALES_RESPONSIBLE");

        public static readonly string ConnectionDataBase =
            ConfigurationManager.ConnectionStrings["CONNECTION_DATA_BASE"] != null
                ? ConfigurationManager.ConnectionStrings["CONNECTION_DATA_BASE"].ConnectionString
                : "";

        public static class FormatType
        {
            public const string DecimalFormat = "#,##0.0";
            public const string DateFormat = "dd/mm/yyyy";
        }

        public static class ExtensionFile
        {
            public const string PowerPoint = ".pptx";
        }
    }

    public static class MediaType
    {
        public const string ContentTypeJson = "application/json; charset=utf-8";
        public static readonly string ApplicationJson = "application/json";

        public static readonly string ExcelContentType =
            "application/vnd.openxmlformats-officedocument.spreadsheetml.sheet";
    }

    public static class RecordStatusBase
    {
        public const string Active = "A";
        public const string Delete = "D";
    }

    public static class TypeMessagePhoneBase
    {
        public const string Sms = "SMS";
        public const string Call = "CALL";
    }

    public static class ProfileActionBase
    {
        public const string ToAssign = "A";
        public const string Replace = "R";
        public const string Disable = "I";
    }
}