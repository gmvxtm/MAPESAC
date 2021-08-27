using Newtonsoft.Json;
using BaseArchitecture.Application.TransferObject.Request.Common;
using BaseArchitecture.Application.TransferObject.Response.Common;
using BaseArchitecture.Cross.Security.InvokePetition;
using BaseArchitecture.Cross.SystemVariable.Constant;
using BaseArchitecture.Repository.IProxy.ServiceProgrammed;

namespace BaseArchitecture.Repository.Proxy.ServiceProgrammed
{
    public class AttentionTask : IAttentionTask
    {
        public Response<int> RegTaskScheduling(TaskSchedulingRequest taskSchedulingRequest, string tokenAuthorization)
        {
            var urlServiceExternal = IncomeServiceProgrammed.MethodServiceProgrammed.RegTaskScheduling;
            var json = JsonConvert.SerializeObject(taskSchedulingRequest);
            return InvokeWebApi.InvokePostEntity<Response<int>>(urlServiceExternal, tokenAuthorization, json);
        }
    }
}