using System.Configuration;

namespace BaseArchitecture.Cross.SystemVariable.Constant
{
    public static class IncomeServiceProgrammed
    {
        public const string IdApplication = "BaseArchitecture";

        public static readonly string UrlServiceProgrammed =
            ConfigurationManager.AppSettings.Get("URL_SERVICE_PROGRAMMED");

        public static class MethodService
        {
            public static readonly string RegTaskScheduling =
                ConfigurationManager.AppSettings.Get("SERVICE_PROGRAMMED_REG_TASK_SCHEDULING");
        }

        public static class MethodServiceProgrammed
        {
            public static readonly string RegTaskScheduling =
                $"{UrlServiceProgrammed}{MethodService.RegTaskScheduling}";
        }

        public static class Process
        {
            public const string SendMail = "10001";
            public const string GeneratedPresentation = "10002";
        }

        public static class ProcessName
        {
            public const string SendMail = "Envio notificaciones";
            public const string GeneratedPresentation = "Generación de presentaciones pptx";
        }
    }
}