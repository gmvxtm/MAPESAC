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
        }
    }
}