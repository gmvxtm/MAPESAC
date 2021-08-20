using BaseArchitecture.Application.TransferObject.Request.Demo;
using BaseArchitecture.Repository.Entity.Demo;
using map = AutoMapper;
namespace BaseArchitecture.Cross.Mapper.Mapping
{
    public class MappingBase
    {
        public MappingBase()
        {
            map.Mapper.CreateMap<PersonRequest, PersonEntity>();
        }

    }
}