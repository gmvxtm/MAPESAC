using BaseArchitecture.Application.TransferObject.Request.Common;
using BaseArchitecture.Application.TransferObject.Response.Common;

namespace BaseArchitecture.Repository.IProxy.ServiceProgrammed
{
    public interface IAttentionTask
    {
        Response<int> RegTaskScheduling(TaskSchedulingRequest taskSchedulingRequest, string tokenAuthorization);
    }
}