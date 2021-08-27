using AutoMapper;

namespace BaseArchitecture.Cross.Mapper.Generic
{
    public abstract class TrimmingFormat : IValueFormatter
    {
        public string FormatValue(ResolutionContext context)
        {
            return context.IsSourceValueNull ? null : ((string) context.SourceValue).Trim();
        }
    }
}