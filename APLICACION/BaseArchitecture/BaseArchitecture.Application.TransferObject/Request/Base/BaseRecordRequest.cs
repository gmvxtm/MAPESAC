using System;
using BaseArchitecture.Cross.SystemVariable.Constant;

namespace BaseArchitecture.Application.TransferObject.Request.Base
{
    public class BaseRecordRequest
    {
        public BaseRecordRequest(string recordStatus, string userRecord)
        {
            RecordStatus = recordStatus;
            UserRecord = userRecord;
            RecordDate = DateTime.Now;
        }

        public BaseRecordRequest(string userRecord)
        {
            RecordStatus = RecordStatusBase.Active;
            UserRecord = userRecord;
            RecordDate = DateTime.Now;
        }

        public BaseRecordRequest()
        {
            RecordStatus = RecordStatusBase.Active;
            RecordDate = DateTime.Now;
        }

        public string RecordStatus { get; protected set; }
        public string UserRecord { get; set; }
        public string TokenId { get; set; }
        public DateTime RecordDate { get; set; }
    }
}