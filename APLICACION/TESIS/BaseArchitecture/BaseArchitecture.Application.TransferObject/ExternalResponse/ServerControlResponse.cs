using System.Collections.Generic;

namespace BaseArchitecture.Application.TransferObject.ExternalResponse
{
    public class ServerControlResponse
    {
        public Resultado Resultado { get; set; }
        public string Status { get; set; }
        public string Message { get; set; }
    }

    public class Resultado
    {
        public int resultado { get; set; }
        public string Msg { get; set; }
        public List<Info> Info { get; set; }
        public List<PerfilUsuario> Perfiles { get; set; }
    }

    public class Info
    {
        public string Application_Id { get; set; }
        public string Application_Name { get; set; }
        public int IsAutoJoin { get; set; }
        public string Profile_Id_Default { get; set; }
        public string DisplayName { get; set; }
        public string User_Guid { get; set; }
        public string Email { get; set; }
        public string NetLogon { get; set; }
        public string SamAccountName { get; set; }
        public string CodTra { get; set; }
        public string EmployeeId { get; set; }
        public string Position_Id { get; set; }
        public string Prc { get; set; }
        public string Title { get; set; }
        public string Deparment { get; set; }
        public string TelephoneNumber { get; set; }
        public string Mobile { get; set; }
        public string UsandoReemplazo { get; set; }
        public string Picture { get; set; }
    }

    public class PerfilUsuario
    {
        public string Profile_Id { get; set; }
        public string Profile_Name { get; set; }
        public string Tipo { get; set; }
        public string Reemplazado_Nombre { get; set; }
        public string Reemplazado_Cargo { get; set; }
        public List<Opcion> Permisos { get; set; }
    }

    public class Opcion
    {
        public string Option_Id { get; set; }
        public string Option_Name { get; set; }
        public string Option_Url { get; set; }
        public string Option_Id_Parent { get; set; }
        public string Option_Icon { get; set; }
        public string Option_Description { get; set; }
        public string Option_Color1 { get; set; }
        public string Option_Color2 { get; set; }
        public OpcionesAcciones[] Process { get; set; }
    }

    public class OpcionesAcciones
    {
        public string Process_Id { get; set; }
        public string Process_Name { get; set; }
        public bool Process_OnlyRead { get; set; }
    }
}