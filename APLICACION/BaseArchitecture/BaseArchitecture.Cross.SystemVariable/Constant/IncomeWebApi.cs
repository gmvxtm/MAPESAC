namespace BaseArchitecture.Cross.SystemVariable.Constant
{
    public static class IncomeWebApi
    {
        public static class PrefixApi
        {
            public const string Authentication = "api/Authentication";
            public const string Mapesac = "api/Mapesac"; 
            public const string Demo = "api/Demo";
            public const string Security = "api/Security";
            public const string Table = "api/Table";
        }

        public static class MethodApi
        {
            public static class Authentication
            {
                public const string Login = "Login";                
                public const string Swagger = "Swagger";
                public const string Table = "Table";
            }

            public static class Security
            {
                public const string Access = "Access";
            }

            public static class Demo
            {
                public const string ListMasterTable = "ListMasterTable";
                public const string GetPersonById = "GetPersonById";
                public const string ListPersonAll = "ListPersonAll";
                public const string UpdPersonState = "UpdPersonState";
                public const string RegPerson = "RegPerson";
                public const string ListMasterTableByValue = "ListMasterTableByValue";
            }

            public static class Mapesac
            {
                public const string ListProyectos = "ListProyectos";
                public const string GetProyectoById = "GetProyectoById";
                public const string ListProduct = "ListProduct";
                public const string ListSupplies = "ListSupplies";
                public const string ListSuppliesByProduct = "ListSuppliesByProduct";
                public const string MergeOrder = "MergeOrder";
                public const string ListUbi = "ListUbi";
                public const string SendEmail = "SendEmail";
                public const string ListOrder = "ListOrder";
                public const string GetOrderByCodeOrder = "GetOrderByCodeOrder";
                public const string ListOrderByLocation = "ListOrderByLocation";
                public const string ListSubOrderByLocation = "ListSubOrderByLocation";                
                public const string UpdOrderFlow = "UpdOrderFlow";
                public const string UpdSubOrderFlow = "UpdSubOrderFlow";
                public const string UpdDecrease = "UpdDecrease";
                public const string ListSuppliersByIdSupply = "ListSuppliersByIdSupply";
                public const string InsBuySupply = "InsBuySupply";
                public const string RptListProductQuantity = "RptListProductQuantity";
                public const string RptListOrderQuantity = "RptListOrderQuantity";
                public const string RptListOrderQuantityStatus = "RptListOrderQuantityStatus";
                public const string RptListOrderQuantityStatusDelivery = "RptListOrderQuantityStatusDelivery";
                public const string RptListSuppliesMostUsedByMonth = "RptListSuppliesMostUsedByMonth";
                public const string RptListSuppliesDecreaseByMonth = "RptListSuppliesDecreaseByMonth";
                public const string RptGanttOrdersLastMonth = "RptGanttOrdersLastMonth";
                public const string UpdSubOrderFlowDetail = "UpdSubOrderFlowDetail";
                

            }
        }

        public static class MethodAllowAnonymous
        {
            public const string SwaggerAllowAnonymous = MethodApi.Authentication.Swagger;

            public static readonly string LoginAllowAnonymous =
                $"/{PrefixApi.Authentication}/{MethodApi.Authentication.Login}";
            public static readonly string TableAllowAnonymous =
               $"/{PrefixApi.Authentication}/{MethodApi.Authentication.Table}";

            public static readonly string ListProyectosAllowAnonymous =
                $"/{PrefixApi.Mapesac}/{MethodApi.Mapesac.ListProyectos}";
        }
    }
}