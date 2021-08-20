using BaseArchitecture.Repository.Entity.Demo;

namespace BaseArchitecture.Application.TransferObject.Response.Demo
{
    public class PersonResponse : PersonEntity
    {
        public string NameMasterTableTypeDocument { get; set; }
    }
}