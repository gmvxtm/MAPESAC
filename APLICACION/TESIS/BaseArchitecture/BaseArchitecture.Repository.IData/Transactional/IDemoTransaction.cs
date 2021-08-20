using BaseArchitecture.Application.TransferObject.Request.Base;
using BaseArchitecture.Application.TransferObject.Request.Demo;
using BaseArchitecture.Application.TransferObject.Response.Common;
using BaseArchitecture.Repository.Entity.Demo;

namespace BaseArchitecture.Repository.IData.Transactional
{
    public interface IDemoTransaction
    {
        Response<int> RegPerson(PersonEntity personEntity, BaseRecordRequest baseRecordRequest);
        Response<int> UpdPersonState(PersonBaseRequest personBaseRequest, BaseRecordRequest baseRecordRequest);
    }
}