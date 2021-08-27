using System;

namespace BaseArchitecture.Application.TransferObject.Request.Demo
{
    public class PersonRequest
    {
        public int IdPerson { get; set; }
        public string CodeAntamina { get; set; }
        public string IdMasterTableTypeDocument { get; set; }
        public string DocumentNumber { get; set; }
        public string FirstName { get; set; }
        public string LastFirstName { get; set; }
        public string LastSecondName { get; set; }
        public decimal MonthlyIncome { get; set; }
        public string Email { get; set; }
        public DateTime? BirthDay { get; set; }
    }
}
