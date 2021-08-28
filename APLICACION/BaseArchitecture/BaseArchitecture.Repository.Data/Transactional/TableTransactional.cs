using BaseArchitecture.Application.TransferObject.Response.Common;
using BaseArchitecture.Cross.SystemVariable.Constant;
using BaseArchitecture.Repository.Entity;
using BaseArchitecture.Repository.IData.NonTransactional;
using Dapper;
using System.Collections.Generic;
using System.Data;
using System.Data.SqlClient;

namespace BaseArchitecture.Repository.Data.Transactional
{
    public class TableTransactional : ITableTransactional
    {
        public Response<int> MrgOrder(OrderEntity orderEntity)
        {
            Response<int> response;
            using (var connection = new SqlConnection(AppSettingValue.ConnectionDataBase))
            {
                var parameters = new DynamicParameters();
                parameters.Add("@ParamIIdOrder", orderEntity.IdOrder);
                parameters.Add("@ParamIDateOrder", orderEntity.DateOrder);
                parameters.Add("@ParamICodeOrder", orderEntity.CodeOrder);
                parameters.Add("@ParamITotal", orderEntity.Total);
                parameters.Add("@ParamIStatus", orderEntity.Status);
                parameters.Add("@ParamIIdCustomer", orderEntity.IdCustomer);

                var result = connection.Execute(
                    $"{IncomeDataProcedures.Schema.Dbo}.{IncomeDataProcedures.Procedure.MrgOrder}",
                    parameters,
                    commandType: CommandType.StoredProcedure);

                response = new Response<int>(result);
            }
            return response;
        }
        public Response<int> UpdPersonState(PersonBaseRequest personBaseRequest, BaseRecordRequest baseRecordRequest)
        {
            Response<int> response;
            using (var connection = new SqlConnection(AppSettingValue.ConnectionDataBase))
            {
                var parameters = new DynamicParameters();
                parameters.Add("@ParamIIdPerson", personBaseRequest.IdPerson);
                parameters.Add("@ParamIRecordStatus", personBaseRequest.RecordStatus);
                parameters.Add("@ParamIUserEditRecord", baseRecordRequest.UserRecord);
                parameters.Add("@ParamIRecordEditDate", baseRecordRequest.RecordDate);

                var result = connection.Execute(
                    $"{IncomeDataProcedures.Schema.Demo}.{IncomeDataProcedures.Procedure.UpdPersonState}",
                    parameters,
                    commandType: CommandType.StoredProcedure);

                response = new Response<int>(result);
            }

            return response;
        }
    }
}
