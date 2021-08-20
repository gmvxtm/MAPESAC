using BaseArchitecture.Cross.Mapper.Generic;

namespace BaseArchitecture.Cross.Mapper.Mapping
{
    public class GeneralMapping
    {
        protected GeneralMapping()
        {
        }

        public static void Create()
        {
            LengthLimitedSingletonCollection<MappingBase>.GetInstance();
        }
    }
}