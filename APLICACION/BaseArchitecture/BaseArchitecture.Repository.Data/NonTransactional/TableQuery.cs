using BaseArchitecture.Application.TransferObject.Response.Common;
using BaseArchitecture.Cross.SystemVariable.Constant;
using BaseArchitecture.Repository.Entity;
using BaseArchitecture.Repository.Entity.Tables;
using BaseArchitecture.Repository.IData.NonTransactional;
using Dapper;
using System;
using System.Collections.Generic;
using System.Data;
using System.Data.SqlClient;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace BaseArchitecture.Repository.Data.NonTransactional
{
    public class TableQuery : ITableQuery
    {
        public IEnumerable<MasterTableEntity> ListMasterTable()
        {
            IEnumerable<MasterTableEntity> response;

            using (var connection = new SqlConnection(AppSettingValue.ConnectionDataBase))
            {
                var parameters = new DynamicParameters();
                parameters.Add("@ParamIRecordStatus", "A");
                var resultResponse = connection.QueryAsync<MasterTableEntity>(
                    $"{IncomeDataProcedures.Schema.Dbo}.{IncomeDataProcedures.Procedure.ListMasterTable}",
                    parameters,
                    commandType: CommandType.StoredProcedure).Result;

                response = resultResponse;
            }

            return response;
        }
        public Response<MenuLogin> Login(UserEntity userRequest)
        {
            Response<MenuLogin> response;

            using (var connection = new SqlConnection(AppSettingValue.ConnectionDataBase))
            {
                var parameters = new DynamicParameters();
                    parameters.Add("@ParamIUsername", userRequest.Username);
                    parameters.Add("@ParamIPassword", userRequest.Password);
                var basicResponse = new MenuLogin();
                using (var list = connection.QueryMultipleAsync(
                                    sql: $"{IncomeDataProcedures.Schema.Dbo}.{IncomeDataProcedures.Procedure.Login}",
                                    param: parameters,
                                    commandType: CommandType.StoredProcedure).Result)
                {
                    basicResponse.UserEntity = list.Read<UserEntity>().ToList().FirstOrDefault();
                    basicResponse.ListMenuProfile = list.Read<MenuProfile>().ToList();                    

                }
                response = new Response<MenuLogin>
                {
                    Value = basicResponse
                };
                
            }

            return response;
        }
        public IEnumerable<ProductEntity> ListProduct()
        {
            IEnumerable<ProductEntity> response;

            using (var connection = new SqlConnection(AppSettingValue.ConnectionDataBase))
            {
                var parameters = new DynamicParameters();

                var resultResponse = connection.QueryAsync<ProductEntity>(
                    $"{IncomeDataProcedures.Schema.Dbo}.{IncomeDataProcedures.Procedure.ListProduct}",
                    parameters,
                    commandType: CommandType.StoredProcedure).Result;

                response = resultResponse;
            }

            return response;
        }
        public Response<UbiEntity> ListUbi()
        {
            Response<UbiEntity> response;
            using (var connection = new SqlConnection(AppSettingValue.ConnectionDataBase))
            {
                var parameters = new DynamicParameters();
                
                var basicResponse = new UbiEntity();
                using (var list = connection.QueryMultipleAsync(
                                    sql: $"{IncomeDataProcedures.Schema.Dbo}.{IncomeDataProcedures.Procedure.ListUbi}",
                                    param: parameters,
                                    commandType: CommandType.StoredProcedure).Result)
                {                    
                    basicResponse.ListDepartmentEntity = list.Read<DepartmentEntity>().ToList();
                    basicResponse.ListProvinceEntity = list.Read<ProvinceEntity>().ToList();
                    basicResponse.ListDistrictEntity= list.Read<DistrictEntity>().ToList();

                }
                response = new Response<UbiEntity>
                {
                    Value = basicResponse
                };
            }
            return response;
        }

        public Response<OrderListEntity> ListOrder()
        {
            Response<OrderListEntity> response;

            using (var connection = new SqlConnection(AppSettingValue.ConnectionDataBase))
            {
                var parameters = new DynamicParameters();
                var basicResponse = new OrderListEntity();
                using (var list = connection.QueryMultipleAsync(
                                    sql: $"{IncomeDataProcedures.Schema.Dbo}.{IncomeDataProcedures.Procedure.ListOrder}",
                                    param: parameters,
                                    commandType: CommandType.StoredProcedure).Result)
                {
                    basicResponse.ListOrderEntity = list.Read<OrderEntity>().ToList();

                }
                response = new Response<OrderListEntity>
                {
                    Value = basicResponse
                };

            }

            return response;
        }

        public Response<OrderListByLocationEntity> ListOrderByLocation(OrderEntity orderRequest)
        {
            Response<OrderListByLocationEntity> response;

            using (var connection = new SqlConnection(AppSettingValue.ConnectionDataBase))
            {
                var parameters = new DynamicParameters();
                parameters.Add("@ParamILocationOrder", orderRequest.LocationOrder);
                var basicResponse = new OrderListByLocationEntity();
                using (var list = connection.QueryMultipleAsync(
                                    sql: $"{IncomeDataProcedures.Schema.Dbo}.{IncomeDataProcedures.Procedure.ListOrderByLocation}",
                                    param: parameters,
                                    commandType: CommandType.StoredProcedure).Result)
                {
                    basicResponse.ListOrderEntity = list.Read<OrderEntity>().ToList();
                    basicResponse.ListTotalOrderEntity = list.Read<TotalOrderEntity>().ToList();

                }
                response = new Response<OrderListByLocationEntity>
                {
                    Value = basicResponse
                };

            }

            return response;
        }

        public Response<OrderEntity> GetOrderByCodeOrder(OrderEntity orderRequest)
        {
            Response<OrderEntity> response;
            using (var connection = new SqlConnection(AppSettingValue.ConnectionDataBase))
            {
                var parameters = new DynamicParameters();
                parameters.Add("@ParamICodeOrder", orderRequest.CodeOrder);
                var basicResponse = new OrderEntity();
                using (var list = connection.QueryMultipleAsync(
                                    sql: $"{IncomeDataProcedures.Schema.Dbo}.{IncomeDataProcedures.Procedure.GetOrderByCodeOrder}",
                                    param: parameters,
                                    commandType: CommandType.StoredProcedure).Result)
                {                    
                    basicResponse = list.Read<OrderEntity>().ToList().FirstOrDefault();
                    basicResponse.ListOrderStatus = list.Read<OrderStatusEntity>().ToList();
                    basicResponse.CustomerEntity = list.Read<CustomerEntity>().ToList().FirstOrDefault();
                    basicResponse.ListOrderDetail = list.Read<OrderDetailEntity>().ToList();
                }
                response = new Response<OrderEntity>
                {
                    Value = basicResponse
                };
            }
            return response;
        }
    }
}
