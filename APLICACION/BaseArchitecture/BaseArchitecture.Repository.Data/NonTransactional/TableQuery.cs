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

        public Response<SubOrderListByLocationEntity> ListSubOrderByLocation(OrderEntity orderRequest)
        {
            Response<SubOrderListByLocationEntity> response;

            using (var connection = new SqlConnection(AppSettingValue.ConnectionDataBase))
            {
                var parameters = new DynamicParameters();
                parameters.Add("@ParamIIdLocation", orderRequest.LocationOrder);
                var basicResponse = new SubOrderListByLocationEntity();
                using (var list = connection.QueryMultipleAsync(
                                    sql: $"{IncomeDataProcedures.Schema.Dbo}.{IncomeDataProcedures.Procedure.ListSubOrderByLocation}",
                                    param: parameters,
                                    commandType: CommandType.StoredProcedure).Result)
                {
                    basicResponse.ListSubOrderEntity = list.Read<SubOrderEntity>().ToList();
                    basicResponse.ListSubOrderFlowDetailEntity = list.Read<SubOrderFlowDetailEntity>().ToList();
                    basicResponse.ListTotalOrderEntity = list.Read<TotalOrderEntity>().ToList();
                }
                response = new Response<SubOrderListByLocationEntity>
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

        public Response<OrderEntity> GetOrderByIdOrder(Guid idOrder)
        {
            Response<OrderEntity> response;
            using (var connection = new SqlConnection(AppSettingValue.ConnectionDataBase))
            {
                var parameters = new DynamicParameters();
                parameters.Add("@ParamIIdOrder", idOrder);
                var basicResponse = new OrderEntity();
                using (var list = connection.QueryMultipleAsync(
                                    sql: $"{IncomeDataProcedures.Schema.Dbo}.{IncomeDataProcedures.Procedure.GetOrderByIdOrder}",
                                    param: parameters,
                                    commandType: CommandType.StoredProcedure).Result)
                {
                    basicResponse.ListOrderDetail = list.Read<OrderDetailEntity>().ToList();
                }
                response = new Response<OrderEntity>
                {
                    Value = basicResponse
                };
            }
            return response;
        }

        public IEnumerable<SupplyEntity> ListSuppliesByProduct(ProductEntity suppliesByProductRequest)
        {
            IEnumerable<SupplyEntity> response;

            using (var connection = new SqlConnection(AppSettingValue.ConnectionDataBase))
            {
                var parameters = new DynamicParameters();
                parameters.Add("@ParamIIdProduct", suppliesByProductRequest.IdProduct);
                var resultResponse = connection.QueryAsync<SupplyEntity>(
                    $"{IncomeDataProcedures.Schema.Dbo}.{IncomeDataProcedures.Procedure.ListSuppliesByProduct}",
                    parameters,
                    commandType: CommandType.StoredProcedure).Result;

                response = resultResponse;
            }

            return response;
        }
        public IEnumerable<SupplyEntity> ListSupplies()
        {
            IEnumerable<SupplyEntity> response;

            using (var connection = new SqlConnection(AppSettingValue.ConnectionDataBase))
            {
                var parameters = new DynamicParameters();

                var resultResponse = connection.QueryAsync<SupplyEntity>(
                    $"{IncomeDataProcedures.Schema.Dbo}.{IncomeDataProcedures.Procedure.ListSupplies}",
                    parameters,
                    commandType: CommandType.StoredProcedure).Result;

                response = resultResponse;
            }

            return response;
        }
        public IEnumerable<SupplierEntity> ListSuppliersByIdSupply(SupplyEntity supplyRequest)
        {
            IEnumerable<SupplierEntity> response;

            using (var connection = new SqlConnection(AppSettingValue.ConnectionDataBase))
            {
                var parameters = new DynamicParameters();
                parameters.Add("@ParamIIdSupply", supplyRequest.IdSupply);

                var resultResponse = connection.QueryAsync<SupplierEntity>(
                    $"{IncomeDataProcedures.Schema.Dbo}.{IncomeDataProcedures.Procedure.ListSuppliersByIdSupply}",
                    parameters,
                    commandType: CommandType.StoredProcedure).Result;

                response = resultResponse;
            }

            return response;
        }

        public IEnumerable<RptListProductQuantityEntity> RptListProductQuantity()
        {
            IEnumerable<RptListProductQuantityEntity> response;

            using (var connection = new SqlConnection(AppSettingValue.ConnectionDataBase))
            {
                var parameters = new DynamicParameters();

                var resultResponse = connection.QueryAsync<RptListProductQuantityEntity>(
                    $"{IncomeDataProcedures.Schema.Dbo}.{IncomeDataProcedures.Procedure.RptListProductQuantity}",
                    parameters,
                    commandType: CommandType.StoredProcedure).Result;

                response = resultResponse;
            }

            return response;
        }

        public IEnumerable<RptListOrderQuantityEntity> RptListOrderQuantity()
        {
            IEnumerable<RptListOrderQuantityEntity> response;

            using (var connection = new SqlConnection(AppSettingValue.ConnectionDataBase))
            {
                var parameters = new DynamicParameters();

                var resultResponse = connection.QueryAsync<RptListOrderQuantityEntity>(
                    $"{IncomeDataProcedures.Schema.Dbo}.{IncomeDataProcedures.Procedure.RptListOrderQuantity}",
                    parameters,
                    commandType: CommandType.StoredProcedure).Result;

                response = resultResponse;
            }

            return response;
        }

        public IEnumerable<RptListOrderQuantityStatusEntity> RptListOrderQuantityStatus()
        {
            IEnumerable<RptListOrderQuantityStatusEntity> response;

            using (var connection = new SqlConnection(AppSettingValue.ConnectionDataBase))
            {
                var parameters = new DynamicParameters();

                var resultResponse = connection.QueryAsync<RptListOrderQuantityStatusEntity>(
                    $"{IncomeDataProcedures.Schema.Dbo}.{IncomeDataProcedures.Procedure.RptListOrderQuantityStatus}",
                    parameters,
                    commandType: CommandType.StoredProcedure).Result;

                response = resultResponse;
            }

            return response;
        }

        public IEnumerable<RptListOrderQuantityStatusDeliveryEntity> RptListOrderQuantityStatusDelivery()
        {
            IEnumerable<RptListOrderQuantityStatusDeliveryEntity> response;

            using (var connection = new SqlConnection(AppSettingValue.ConnectionDataBase))
            {
                var parameters = new DynamicParameters();

                var resultResponse = connection.QueryAsync<RptListOrderQuantityStatusDeliveryEntity>(
                    $"{IncomeDataProcedures.Schema.Dbo}.{IncomeDataProcedures.Procedure.RptListOrderQuantityStatusDelivery}",
                    parameters,
                    commandType: CommandType.StoredProcedure).Result;

                response = resultResponse;
            }

            return response;
        }

        public IEnumerable<RptListSuppliesMostUsedByMonthEntity> RptListSuppliesMostUsedByMonth()
        {
            IEnumerable<RptListSuppliesMostUsedByMonthEntity> response;

            using (var connection = new SqlConnection(AppSettingValue.ConnectionDataBase))
            {
                var parameters = new DynamicParameters();

                var resultResponse = connection.QueryAsync<RptListSuppliesMostUsedByMonthEntity>(
                    $"{IncomeDataProcedures.Schema.Dbo}.{IncomeDataProcedures.Procedure.RptListSuppliesMostUsedByMonth}",
                    parameters,
                    commandType: CommandType.StoredProcedure).Result;

                response = resultResponse;
            }

            return response;
        }

        public IEnumerable<RptListSuppliesDecreaseByMonthEntity> RptListSuppliesDecreaseByMonth()
        {
            IEnumerable<RptListSuppliesDecreaseByMonthEntity> response;

            using (var connection = new SqlConnection(AppSettingValue.ConnectionDataBase))
            {
                var parameters = new DynamicParameters();

                var resultResponse = connection.QueryAsync<RptListSuppliesDecreaseByMonthEntity>(
                    $"{IncomeDataProcedures.Schema.Dbo}.{IncomeDataProcedures.Procedure.RptListSuppliesDecreaseByMonth}",
                    parameters,
                    commandType: CommandType.StoredProcedure).Result;

                response = resultResponse;
            }

            return response;
        }

        public IEnumerable<RptGanttOrdersLastMonthEntity> RptGanttOrdersLastMonth()
        {
            IEnumerable<RptGanttOrdersLastMonthEntity> response;

            using (var connection = new SqlConnection(AppSettingValue.ConnectionDataBase))
            {
                var parameters = new DynamicParameters();

                var resultResponse = connection.QueryAsync<RptGanttOrdersLastMonthEntity>(
                    $"{IncomeDataProcedures.Schema.Dbo}.{IncomeDataProcedures.Procedure.RptGanttOrdersLastMonth}",
                    parameters,
                    commandType: CommandType.StoredProcedure).Result;

                response = resultResponse;
            }

            return response;
        }

    }
}
