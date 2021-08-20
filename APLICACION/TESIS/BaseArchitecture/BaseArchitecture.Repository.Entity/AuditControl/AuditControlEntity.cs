using System;
using BaseArchitecture.Cross.SystemVariable.Constant;

namespace BaseArchitecture.Repository.Entity.AuditControl
{
    public class AuditControlEntity
    {
        public AuditControlEntity()
        {
            RecordCreationDate = DateTime.Now;
            RecordStatus = RecordStatusBase.Active;
        }

        public string RecordStatus { get; set; }
        public string UserRecordCreation { get; set; }
        public DateTime RecordCreationDate { get; set; }
        public string UserEditRecord { get; set; }
        public DateTime RecordEditDate { get; set; }
    }
}