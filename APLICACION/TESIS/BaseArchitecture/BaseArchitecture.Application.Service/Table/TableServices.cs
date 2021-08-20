using Newtonsoft.Json;
using BaseArchitecture.Application.IService.Demo;
using BaseArchitecture.Application.TransferObject.Request.Base;
using BaseArchitecture.Application.TransferObject.Request.Demo;
using BaseArchitecture.Application.TransferObject.Response.Common;
using BaseArchitecture.Application.TransferObject.Response.Demo;
using BaseArchitecture.Cross.LoggerTrace;
using BaseArchitecture.Repository.Entity.Demo;
using BaseArchitecture.Repository.IData.NonTransactional;
using BaseArchitecture.Repository.IData.Transactional;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Transactions;
using System.Web.Http;
using map = AutoMapper;
using Util = BaseArchitecture.Cross.SystemVariable.Util;
using BaseArchitecture.Repository.Entity;

namespace BaseArchitecture.Application.Service.Table
{
    public class TableServices : ITableService
    {
        //public IDemoQuery DemoQuery { get; set; }
        //public IDemoTransaction DemoTransaction { get; set; }
        public ITableQuery TableQuery { get; set; }



        /// <summary>
        ///     Method that get MasterTableResponse by IdMasterTable
        /// </summary>
        /// <param name="masterTableRequest">Params entry</param>
        /// <remarks>
        ///     The method GetMasterById get list MasterTable and filter by IdMasterTable
        /// </remarks>
        /// <returns>Return entity MasterTableResponse</returns>
        public MasterTableEntity GetMasterById(MasterTableEntity masterTableRequest)
        {
            var result = GetAllMaster();
            return result.FirstOrDefault(x => x.IdMasterTable == masterTableRequest.IdMasterTable);
        }

        public Response<IEnumerable<MasterTableEntity>> ListMasterTable(MasterTableEntity masterTableRequest)
        {
            var result = GetAllMaster();
            var masterTableResponses =
                result.Where(x => x.IdMasterTableParent == masterTableRequest.IdMasterTableParent).ToList();

            return new Response<IEnumerable<MasterTableEntity>> { Value = masterTableResponses };
        }

        public Response<IEnumerable<MasterTableEntity>> ListMasterTableByValue(MasterTableEntity masterTableRequest)
        {
            var result = GetAllMaster();
            var masterTableResponses = result.Where(x => x.IdMasterTableParent == masterTableRequest.IdMasterTableParent
                                                         && x.Value == masterTableRequest.Value).ToList();

            return new Response<IEnumerable<MasterTableEntity>> { Value = masterTableResponses };
        }

        private IEnumerable<MasterTableEntity> GetAllMaster()
        {
            return TableQuery.ListMasterTable();
        }
    }
}