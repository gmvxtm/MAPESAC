using BaseArchitecture.Application.TransferObject.Response.Common;
using BaseArchitecture.Cross.SystemVariable.Constant;
using BaseArchitecture.Repository.Entity;
using BaseArchitecture.Repository.Entity.Tables;
using BaseArchitecture.Repository.IData.Transactional;
using Dapper;
using System;
using System.Data;
using System.Data.SqlClient;
using System.Linq;

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

        public Response<int> GenerateSubOrderFlow(OrderEntity orderEntity)
        {
            Response<int> response;
            using (var connection = new SqlConnection(AppSettingValue.ConnectionDataBase))
            {
                orderEntity.DateOrder = DateTime.Now;
                var parameters = new DynamicParameters();
                parameters.Add("@ParamIIdOrder", orderEntity.IdOrder);
                var result = connection.Execute(
                    $"{IncomeDataProcedures.Schema.Dbo}.{IncomeDataProcedures.Procedure.GenerateSubOrderFlow}",
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

        public Response<int> UpdSubOrderFlow(OrderFlowEntity orderFlowRequest)
        {
            Response<int> response;
            using (var connection = new SqlConnection(AppSettingValue.ConnectionDataBase))
            {
                var parameters = new DynamicParameters();
                parameters.Add("@ParamICodeSubOrder", orderFlowRequest.CodeOrder);
                parameters.Add("@ParamIStatus", orderFlowRequest.Status);
                

                var result = connection.Execute(
                    $"{IncomeDataProcedures.Schema.Dbo}.{IncomeDataProcedures.Procedure.UpdSubOrderFlow}",
                    parameters,
                    commandType: CommandType.StoredProcedure);

                response = new Response<int>(result);
            }

            return response;
        }

        public Response<ResponseValidateStockEntity> ValidateAndUpdateStock(string listProductJson)
        {
            Response<ResponseValidateStockEntity> response;

            using (var connection = new SqlConnection(AppSettingValue.ConnectionDataBase))
            {
                var parameters = new DynamicParameters();
                parameters.Add("@ParamIProductJson", listProductJson);

                var basicResponse = new ResponseValidateStockEntity();
                using (var list = connection.QueryMultipleAsync(
                                    sql: $"{IncomeDataProcedures.Schema.Dbo}.{IncomeDataProcedures.Procedure.ValidateStockByQuantityProduct}",
                                    param: parameters,
                                    commandType: CommandType.StoredProcedure).Result)
                {
                    basicResponse.ValidateStock = list.Read<ValidateStock>().ToList().FirstOrDefault();
                    basicResponse.ListProductOutOfStock = list.Read<ProductOutOfStockEntity>().ToList();

                }
                response = new Response<ResponseValidateStockEntity>
                {
                    Value = basicResponse
                };

            }

            return response;
        }

        public Response<int> UpdDecrease(DecreaseEntity decreaseRequest)
        {
            Response<int> response;
            using (var connection = new SqlConnection(AppSettingValue.ConnectionDataBase))
            {
                var parameters = new DynamicParameters();
                parameters.Add("@ParamICodeSubOrder", decreaseRequest.CodeSubOrder);
                parameters.Add("@ParamIIdOrderDetail", decreaseRequest.IdOrderDetail);
                parameters.Add("@ParamIQuantityDecrease", decreaseRequest.QuantityDecrease);

                var result = connection.Execute(
                    $"{IncomeDataProcedures.Schema.Dbo}.{IncomeDataProcedures.Procedure.UpdDecrease}",
                    parameters,
                    commandType: CommandType.StoredProcedure);

                response = new Response<int>(result);
            }

            return response;
        }

        public Response<int> IndBuySupply(BuySupplyEntity buySupplyRequest)
        {
            Response<int> response;
            using (var connection = new SqlConnection(AppSettingValue.ConnectionDataBase))
            {
                var parameters = new DynamicParameters();
                parameters.Add("@ParamIIdSupply", buySupplyRequest.IdSupply);
                parameters.Add("@ParamIIdSupplier", buySupplyRequest.IdSupplier);
                parameters.Add("@ParamIUnitPrice", buySupplyRequest.UnitPrice);
                parameters.Add("@ParamIQuantity", buySupplyRequest.Quantity);
                parameters.Add("@ParamITotalPrice", buySupplyRequest.TotalPrice);

                var result = connection.Execute(
                    $"{IncomeDataProcedures.Schema.Dbo}.{IncomeDataProcedures.Procedure.InsBuySupply}",
                    parameters,
                    commandType: CommandType.StoredProcedure);

                response = new Response<int>(result);
            }

            return response;
        }

        public Response<int> UpdSubOrderFlowDetail(SubOrderFlowDetailEntity subOrderFlowDetailRequest)
        {
            Response<int> response;
            using (var connection = new SqlConnection(AppSettingValue.ConnectionDataBase))
            {
                var parameters = new DynamicParameters();
                parameters.Add("@ParamIIdSubOrderFlowDetail", subOrderFlowDetailRequest.IdSubOrderFlowDetail);
                parameters.Add("@ParamIQuantityReturn", subOrderFlowDetailRequest.QuantityReturn);


                var result = connection.Execute(
                    $"{IncomeDataProcedures.Schema.Dbo}.{IncomeDataProcedures.Procedure.UpdSubOrderFlowDetail}",
                    parameters,
                    commandType: CommandType.StoredProcedure);

                response = new Response<int>(result);
            }

            return response;
        }
    }
}
