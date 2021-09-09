using BaseArchitecture.Application.TransferObject.Request.Base;
using BaseArchitecture.Application.TransferObject.Request.Demo;
using BaseArchitecture.Application.TransferObject.Response.Common;
using BaseArchitecture.Application.TransferObject.Response.Demo;
using System.Collections.Generic;

namespace BaseArchitecture.Application.IService.Demo
{
    public interface IDemoService
    {
        //MasterTableResponse GetMasterById(MasterTableRequest masterTableRequest);
        //Response<IEnumerable<MasterTableResponse>> ListMasterTableByValue(MasterTableRequest masterTableRequest);
        //Response<IEnumerable<MasterTableResponse>> ListMasterTable(MasterTableRequest masterTableRequest);
        Response<CollectionDataResponse<PersonResponse>> ListPersonAll(PersonFilterRequest personFilterRequest);
        Response<List<ProyectoResponse>> ListProyectos();
        Response<ProyectoResponse> GetProyectoById(ProyectoRequest proyectoRequest);
        Response<PersonResponse> GetPersonById(PersonBaseRequest personBaseRequest);
        Response<int> UpdPersonState(PersonBaseRequest personBaseRequest, BaseRecordRequest baseRecordRequest);
        Response<int> RegPerson(PersonRequest personRequest, BaseRecordRequest baseRecordRequest);
    }
}