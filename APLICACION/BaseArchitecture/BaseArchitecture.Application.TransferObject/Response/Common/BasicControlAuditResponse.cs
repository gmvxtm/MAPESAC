using System;

namespace BaseArchitecture.Application.TransferObject.Response.Common
{
    public class BasicControlAuditResponse
    {
        public string UserRecordCreation { set; get; }
        public string UserEditRecord { set; get; }
        public string RecordStatus { set; get; }
        public DateTime RecordCreationDate { set; get; }
        public DateTime RecordEditDate { set; get; }
    }
}