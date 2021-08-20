using System.Collections.Generic;

namespace BaseArchitecture.Application.TransferObject.Response.Access
{
    public class OptionResponse
    {
        public string OptionId { get; set; }
        public string OptionName { get; set; }
        public string OptionUrl { get; set; }
        public string OptionIdParent { get; set; }
        public string OptionIcon { get; set; }
        public string OptionDescription { get; set; }
        public string OptionColor1 { get; set; }
        public string OptionColor2 { get; set; }
        public List<ProcessResponse> Process { get; set; }
    }
}