using System;

namespace BaseArchitecture.Repository.Entity
{
    public class MenuProfile
    {
        public Guid IdMenuProfile { get; set; }
        public string IdMenu { get; set; }
        public string IdProfile { get; set; }
        public string MenuName { get; set; }
        public string UrlName { get; set; }
        public string RecordStatus { get; set; }        
    }
}
