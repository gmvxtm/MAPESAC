using BaseArchitecture.Application.TransferObject.Response.Common;
using BaseArchitecture.Cross.SystemVariable.Constant;
using BaseArchitecture.Repository.Entity;
using BaseArchitecture.Repository.IData.Transactional;
using Dapper;
using System.Data;
using System.Data.SqlClient;

namespace BaseArchitecture.Repository.Data.Transactional
{
    public class TableTransactional : ITableTransaction
    {
        public Response<int> MergeOrder(OrderEntity orderEntity)
        {
            Response<int> response;
            using (var connection = new SqlConnection(AppSettingValue.ConnectionDataBase))
            {
                var parameters = new DynamicParameters();
                parameters.Add("@ParamIIdOrder", orderEntity.IdOrder);
                parameters.Add("@ParamIDateOrder", orderEntity.DateOrder);
                parameters.Add("@ParamITotal", orderEntity.Total);
                parameters.Add("@ParamIStatus", orderEntity.Status);
                parameters.Add("@ParamIIdCustomer", orderEntity.IdCustomer);
                parameters.Add("@ParamIRecordStatus", orderEntity.RecordStatus);
                var result = connection.Execute(
                    $"{IncomeDataProcedures.Schema.Dbo}.{IncomeDataProcedures.Procedure.MrgOrder}",
                    parameters,
                    commandType: CommandType.StoredProcedure);

                response = new Response<int>(result);
            }
            return response;
        }
        public Response<int> MergeOrderDetail(OrderDetailEntity orderDetailEntity)
        {
            Response<int> response;
            using (var connection = new SqlConnection(AppSettingValue.ConnectionDataBase))
            {
                var parameters = new DynamicParameters();
                parameters.Add("@ParamIIdOrderDetail", orderDetailEntity.IdOrderDetail);
                parameters.Add("@ParamIIdOrder", orderDetailEntity.IdOrder);
                parameters.Add("@ParamIIdProduct", orderDetailEntity.IdProduct);
                parameters.Add("@ParamIDescription", orderDetailEntity.Description);
                parameters.Add("@ParamIQuantity", orderDetailEntity.Quantity);
                parameters.Add("@ParamIRecordStatus", orderDetailEntity.RecordStatus);

                var result = connection.Execute(
                    $"{IncomeDataProcedures.Schema.Dbo}.{IncomeDataProcedures.Procedure.MrgOrderDetail}",
                    parameters,
                    commandType: CommandType.StoredProcedure);

                response = new Response<int>(result);
            }

            return response;
        }
    }
}
