using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace BaseArchitecture.Repository.Entity.Tables
{
    public class MenuLogin
    {
        public MenuLogin()
        {
            UserEntity = new UserEntity();
            ListMenuProfile = new List<MenuProfile>();

        }

        public UserEntity UserEntity { get; set; }
        public IEnumerable<MenuProfile> ListMenuProfile { get; set; }
    }
}
