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
    }
}
