namespace BaseArchitecture.Cross.SystemVariable.Constant
{
    public static class IncomeDataProcedures
    {
        /// <summary>
        /// The names of the database schemas are established
        /// </summary>
        public static class Schema
        {
            public const string Demo = "Demo";
            public const string Core = "Core";
            public const string Dbo = "dbo";
        }

        /// <summary>
        /// The names of the stored procedures will be set separated by type of action
        /// </summary>
        /// <example>
        ///     public const string Get{NameProcedure} = "USP_GET_{NameProcedure}";
        ///     public const string List{NameProcedure} = "USP_LIST_{NameProcedure}";
        /// </example>
        public static class Procedure
        {
            public const string GetPersonById = "USP_GET_PersonById";
            
            public const string ListPersonAll = "USP_LIST_PersonAll";

            public const string RegPerson = "USP_REG_Person";

            public const string UpdPersonState = "USP_UPD_PersonState";

            public const string ListProyectos = "USP_LIST_Proyectos";
            public const string GetProyectoById = "USP_GET_ProyectoById";
            public const string ListMasterTable = "USP_MasterTable_List";            
            public const string Login = "Usp_Login";
            public const string ListProduct = "Usp_List_Product";
            public const string ListSuppliesByProduct = "Usp_List_SuppliesByProduct";
            public const string ListUbi = "Usp_List_Ubi";
            public const string ListOrder = "Usp_List_Order";
            public const string GetOrderByCodeOrder = "Usp_Get_OrderByCodeOrder";
            public const string GetOrderByIdOrder = "Usp_Get_OrderByIdOrder";
            public const string ListOrderByLocation = "Usp_List_OrderByLocation";
            public const string ListSubOrderByLocation = "Usp_List_SubOrderByLocation";

            public const string RptListProductQuantity = "Usp_Rpt_ListProductQuantity";
            public const string RptListOrderQuantity = "Usp_Rpt_ListOrderQuantity";
            public const string RptListOrderQuantityStatus = "Usp_Rpt_ListOrderQuantityStatus";
            public const string RptListOrderQuantityStatusDelivery = "Usp_Rpt_ListOrderQuantityStatusDelivery";
            public const string RptListSuppliesMostUsedByMonth = "Usp_Rpt_ListSuppliesMostUsedByMonth";
            public const string RptListSuppliesDecreaseByMonth = "Usp_Rpt_ListSuppliesDecreasedByMonth";
            public const string RptGanttOrdersLastMonth = "Usp_Rpt_GanttOrdersLastMonth";

            public const string MrgOrder = "Usp_Mrg_Order";
            public const string GenerateOrderFlow = "Usp_Generate_OrderFlow";
            public const string GenerateSubOrderFlow = "Usp_Generate_SubOrderFlow";
            public const string MrgOrderDetail = "Usp_Mrg_OrderDetail";
            public const string MrgCustomer = "Usp_Mrg_Customer";
            public const string UpdOrderFlow = "Usp_Upd_OrderFlow";
            public const string UpdSubOrderFlow = "Usp_Upd_SubOrderFlow";
            public const string ValidateStockByQuantityProduct = "Usp_ValidateStockByQuantityProduct";
            public const string UpdDecrease = "Usp_Upd_Decrease";
            public const string ListSupplies = "Usp_List_Supplies";
            public const string ListSuppliersByIdSupply = "Usp_List_SuppliersByIdSupply";
            public const string InsBuySupply = "Usp_Ins_BuySupply";
            public const string UpdSubOrderFlowDetail = "Usp_Upd_SubOrderFlowDetail";
        }
    }
}