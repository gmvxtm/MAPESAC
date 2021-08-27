using Dapper;
using BaseArchitecture.Application.TransferObject.Request.Demo;
using BaseArchitecture.Application.TransferObject.Response.Common;
using BaseArchitecture.Application.TransferObject.Response.Demo;
using BaseArchitecture.Cross.SystemVariable.Constant;
using BaseArchitecture.Repository.IData.NonTransactional;
using System.Collections.Generic;
using System.Data;
using System.Data.SqlClient;
using System.Linq;

namespace BaseArchitecture.Repository.Data.NonTransactional
{
    public class DemoQuery : IDemoQuery
    {
        public IEnumerable<MasterTableResponse> ListMasterTable(MasterTableRequest masterTableRequest)
        {
            IEnumerable<MasterTableResponse> response;

            using (var connection = new SqlConnection(AppSettingValue.ConnectionDataBase))
            {
                var parameters = new DynamicParameters();
                parameters.Add("@ParamIRecordStatus", masterTableRequest.RecordStatus);

                var resultResponse = connection.QueryAsync<MasterTableResponse>(
                    $"{IncomeDataProcedures.Schema.Demo}.{IncomeDataProcedures.Procedure.ListMasterTable}",
                    parameters,
                    commandType: CommandType.StoredProcedure).Result;

                response = resultResponse;
            }

            return response;
        }

        public Response<PersonResponse> GetPersonById(PersonBaseRequest personBaseRequest)
        {
            Response<PersonResponse> response;

            using (var connection = new SqlConnection(AppSettingValue.ConnectionDataBase))
            {
                var parameters = new DynamicParameters();
                parameters.Add("@ParamIIdPerson", personBaseRequest.IdPerson);

                var resultResponse = connection.QueryAsync<PersonResponse>(
                    $"{IncomeDataProcedures.Schema.Demo}.{IncomeDataProcedures.Procedure.GetPersonById}",
                    parameters,
                    commandType: CommandType.StoredProcedure).Result.FirstOrDefault();

                response = new Response<PersonResponse>()
                {
                    Value = resultResponse
                };
            }

            return response;
        }

        public Response<ProyectoResponse> GetProyectoById(ProyectoRequest proyectoRequest)
        {
            Response<ProyectoResponse> response;

            using (var connection = new SqlConnection(AppSettingValue.ConnectionDataBase))
            {
                var parameters = new DynamicParameters();
                parameters.Add("@IdProyecto", proyectoRequest.IdProyecto);

                var resultResponse = connection.QueryAsync<ProyectoResponse>(
                    $"{IncomeDataProcedures.Schema.Core}.{IncomeDataProcedures.Procedure.GetProyectoById}",
                    parameters,
                    commandType: CommandType.StoredProcedure).Result.FirstOrDefault();

                response = new Response<ProyectoResponse>()
                {
                    Value = resultResponse
                };
            }

            return response;
        }

        public IEnumerable<PersonResponse> ListPersonAll(PersonFilterRequest personFilterRequest)
        {
            IEnumerable<PersonResponse> response;

            using (var connection = new SqlConnection(AppSettingValue.ConnectionDataBase))
            {
                var parameters = new DynamicParameters();
                parameters.Add("@ParamIIdMasterTableTypeDocument", personFilterRequest.IdMasterTableTypeDocument);
                parameters.Add("@ParamIStartDate", personFilterRequest.StartDate);
                parameters.Add("@ParamIEndDate", personFilterRequest.EndDate);
                parameters.Add("@ParamIRecordStatus", personFilterRequest.RecordStatus);

                var resultResponse = connection.QueryAsync<PersonResponse>(
                    $"{IncomeDataProcedures.Schema.Demo}.{IncomeDataProcedures.Procedure.ListPersonAll}",
                    parameters,
                    commandType: CommandType.StoredProcedure).Result;

                response = resultResponse;
            }

            return response;
        }

        public IEnumerable<ProyectoResponse> ListProyectos()
        {
            IEnumerable<ProyectoResponse> response;

            using (var connection = new SqlConnection(AppSettingValue.ConnectionDataBase))
            {
                var parameters = new DynamicParameters();

                var resultResponse = connection.QueryAsync<ProyectoResponse>(
                    $"{IncomeDataProcedures.Schema.Core}.{IncomeDataProcedures.Procedure.ListProyectos}",
                    parameters,
                    commandType: CommandType.StoredProcedure).Result;

                response = resultResponse;
            }

            return response;
        }
    }
}