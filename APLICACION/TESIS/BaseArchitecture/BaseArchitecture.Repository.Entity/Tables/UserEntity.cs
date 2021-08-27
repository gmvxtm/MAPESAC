using System;

namespace BaseArchitecture.Repository.Entity
{
    public class UserEntity
    {
        public Guid IdUser { get; set; }
        public string Username { get; set; }
        public string Password { get; set; }
        public string RecordStatus { get; set; }
        public string IdProfile { get; set; }
    }
}
