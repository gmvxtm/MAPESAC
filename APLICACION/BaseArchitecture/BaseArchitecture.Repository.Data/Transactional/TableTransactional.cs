using BaseArchitecture.Application.TransferObject.Response.Common;
using BaseArchitecture.Cross.SystemVariable.Constant;
using BaseArchitecture.Repository.Entity;
using BaseArchitecture.Repository.Entity.Tables;
using BaseArchitecture.Repository.IData.Transactional;
using Dapper;
using System;
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
                orderEntity.DateOrder = DateTime.Now;
                var parameters = new DynamicParameters();
                parameters.Add("@ParamIIdOrder", orderEntity.IdOrder);
                parameters.Add("@ParamIDateOrder", orderEntity.DateOrder);
                parameters.Add("@ParamITotal", orderEntity.Total);
                parameters.Add("@ParamIStatusOrder", orderEntity.StatusOrder);
                parameters.Add("@ParamILocationOrder", orderEntity.LocationOrder);
                parameters.Add("@ParamIIdCustomer", orderEntity.IdCustomer);
                parameters.Add("@ParamIBusinessNumber", orderEntity.BusinessNumber);
                parameters.Add("@ParamIBusinessName", orderEntity.BusinessName);
                parameters.Add("@ParamIRecordStatus", orderEntity.RecordStatus);
                var result = connection.Execute(
                    $"{IncomeDataProcedures.Schema.Dbo}.{IncomeDataProcedures.Procedure.MrgOrder}",
                    parameters,
                    commandType: CommandType.StoredProcedure);

                response = new Response<int>(result);
            }
            return response;
        }
        public Response<int> GenerateOrderFlow(OrderEntity orderEntity)
        {
            Response<int> response;
            using (var connection = new SqlConnection(AppSettingValue.ConnectionDataBase))
            {
                orderEntity.DateOrder = DateTime.Now;
                var parameters = new DynamicParameters();
                parameters.Add("@ParamIIdOrder", orderEntity.IdOrder);
                var result = connection.Execute(
                    $"{IncomeDataProcedures.Schema.Dbo}.{IncomeDataProcedures.Procedure.GenerateOrderFlow}",
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

        public Response<int> MergeCustomer(CustomerEntity customerEntity)
        {
            Response<int> response;
            using (var connection = new SqlConnection(AppSettingValue.ConnectionDataBase))
            {
                var parameters = new DynamicParameters();
                parameters.Add("@ParamIIdCustomer", customerEntity.IdCustomer);
                parameters.Add("@ParamIFirstName", customerEntity.FirstName);
                parameters.Add("@ParamILastName", customerEntity.LastName);
                parameters.Add("@ParamIDocumentNumber", customerEntity.DocumentNumber);
                parameters.Add("@ParamIPhoneNumber", customerEntity.PhoneNumber);
                parameters.Add("@ParamIEmail", customerEntity.Email);
                parameters.Add("@ParamIIdDistrict", customerEntity.IdDistrict);                
                parameters.Add("@ParamIRecordStatus", customerEntity.RecordStatus);
                var result = connection.Execute(
                    $"{IncomeDataProcedures.Schema.Dbo}.{IncomeDataProcedures.Procedure.MrgCustomer}",
                    parameters,
                    commandType: CommandType.StoredProcedure);

                response = new Response<int>(result);
            }
            return response;
        }

        public Response<int> UpdOrderFlow(OrderFlowEntity orderFlowRequest)
        {
            Response<int> response;
            using (var connection = new SqlConnection(AppSettingValue.ConnectionDataBase))
            {
                var parameters = new DynamicParameters();
                parameters.Add("@ParamIIdOrder", orderFlowRequest.IdOrder);
                parameters.Add("@ParamILocationOrder", orderFlowRequest.LocationOrder);
                parameters.Add("@ParamIAnswer", orderFlowRequest.Answer);

                var result = connection.Execute(
                    $"{IncomeDataProcedures.Schema.Dbo}.{IncomeDataProcedures.Procedure.UpdOrderFlow}",
                    parameters,
                    commandType: CommandType.StoredProcedure);

                response = new Response<int>(result);
            }

            return response;
        }
    }
}
