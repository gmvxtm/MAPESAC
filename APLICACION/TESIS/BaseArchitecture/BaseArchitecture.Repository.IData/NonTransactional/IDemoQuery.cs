using BaseArchitecture.Application.TransferObject.Request.Demo;
using BaseArchitecture.Application.TransferObject.Response.Common;
using BaseArchitecture.Application.TransferObject.Response.Demo;
using System.Collections.Generic;

namespace BaseArchitecture.Repository.IData.NonTransactional
{
    public interface IDemoQuery
    {
        IEnumerable<MasterTableResponse> ListMasterTable(MasterTableRequest masterTableRequest);
        Response<PersonResponse> GetPersonById(PersonBaseRequest personBaseRequest);
        IEnumerable<PersonResponse> ListPersonAll(PersonFilterRequest personFilterRequest);
        IEnumerable<ProyectoResponse> ListProyectos();
        Response<ProyectoResponse> GetProyectoById(ProyectoRequest proyectoRequest);
        
    }
}