using BaseArchitecture.Application.TransferObject.Request.Base;

namespace BaseArchitecture.Application.TransferObject.Request.Demo
{
    public class MasterTableRequest : BaseRecordRequest
    {
        public string IdMasterTable { set; get; }
        public string IdMasterTableParent { set; get; }
        public string Value { set; get; }
    }
}