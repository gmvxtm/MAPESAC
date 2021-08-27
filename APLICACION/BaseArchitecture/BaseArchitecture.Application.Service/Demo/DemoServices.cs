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

namespace BaseArchitecture.Application.Service.Demo
{
    public class DemoServices : IDemoService
    {
        public IDemoQuery DemoQuery { get; set; }
        public IDemoTransaction DemoTransaction { get; set; }
        public Trace TraceLogger =>
            (Trace)GlobalConfiguration.Configuration.DependencyResolver.GetService(typeof(Trace));
        public Response<CollectionDataResponse<PersonResponse>> ListPersonAll(PersonFilterRequest personFilterRequest)
        {
            var result = DemoQuery.ListPersonAll(personFilterRequest).ToList();
            var typeOrder = (personFilterRequest.Pagination.TypeOrder == "desc")
                ? Util.Extension.TypeOrder.Desc
                : Util.Extension.TypeOrder.Asc;
            var pros = Util.Page<PersonResponse>.CreateInstance(personFilterRequest.Pagination.CurrentPage,
                personFilterRequest.Pagination.RowsPerPage, result);
            var listResult = pros.Filter(personFilterRequest.FilterColumn)
                .Order(personFilterRequest.Pagination.ColumnOrder, typeOrder)
                .Pagination().Collection;
            var collectionDataResponse = new CollectionDataResponse<PersonResponse>()
            {
                Collection = listResult,
                Pagination = new PaginationResponse()
                {
                    QuantityRows = pros.QuantityRows,
                    TotalPages = pros.TotalPages
                }
            };

            var response = new Response<CollectionDataResponse<PersonResponse>>()
            {
                Value = collectionDataResponse
            };
            return response;
        }

        public Response<List<ProyectoResponse>> ListProyectos()
        {
            var result = DemoQuery.ListProyectos().ToList();

            var response = new Response<List<ProyectoResponse>>()
            {
                Value = result
            };
            return response;
        }

        public Response<ProyectoResponse> GetProyectoById(ProyectoRequest proyectoRequest)
        {
            var result = DemoQuery.GetProyectoById(proyectoRequest);
            return result;
        }

        

        public Response<PersonResponse> GetPersonById(PersonBaseRequest personBaseRequest)
        {
            var result = DemoQuery.GetPersonById(personBaseRequest);
            return result;
        }

        public Response<int> RegPerson(PersonRequest personRequest, BaseRecordRequest baseRecordRequest)
        {
            var result = new Response<int>(1);
            using (var transaction = new TransactionScope())
            {
                try
                {
                    var personEntity =
                        map.Mapper.Map<PersonRequest, PersonEntity>(personRequest);
                    DemoTransaction.RegPerson(personEntity, baseRecordRequest);
                    transaction.Complete();
                }
                catch (Exception e)
                {
                    TraceLogger.RegisterExceptionDemand(JsonConvert.SerializeObject(e));
                    result = new Response<int>(0);
                }
            }

            return result;
        }

        public Response<int> UpdPersonState(PersonBaseRequest personBaseRequest, BaseRecordRequest baseRecordRequest)
        {
            var result = new Response<int>(1);
            using (var transaction = new TransactionScope())
            {
                try
                {
                    DemoTransaction.UpdPersonState(personBaseRequest, baseRecordRequest);
                    transaction.Complete();
                }
                catch (Exception e)
                {
                    TraceLogger.RegisterExceptionDemand(JsonConvert.SerializeObject(e));
                    result = new Response<int>(0);
                }
            }

            return result;
        }


        /// <summary>
        ///     Method that get MasterTableResponse by IdMasterTable
        /// </summary>
        /// <param name="masterTableRequest">Params entry</param>
        /// <remarks>
        ///     The method GetMasterById get list MasterTable and filter by IdMasterTable
        /// </remarks>
        /// <returns>Return entity MasterTableResponse</returns>
        public MasterTableResponse GetMasterById(MasterTableRequest masterTableRequest)
        {
            var result = GetAllMaster(masterTableRequest);
            return result.FirstOrDefault(x => x.IdMasterTable == masterTableRequest.IdMasterTable);
        }

        public Response<IEnumerable<MasterTableResponse>> ListMasterTable(MasterTableRequest masterTableRequest)
        {
            var result = GetAllMaster(masterTableRequest);
            var masterTableResponses =
                result.Where(x => x.IdMasterTableParent == masterTableRequest.IdMasterTableParent).ToList();

            return new Response<IEnumerable<MasterTableResponse>> { Value = masterTableResponses };
        }

        public Response<IEnumerable<MasterTableResponse>> ListMasterTableByValue(MasterTableRequest masterTableRequest)
        {
            var result = GetAllMaster(masterTableRequest);
            var masterTableResponses = result.Where(x => x.IdMasterTableParent == masterTableRequest.IdMasterTableParent
                                                         && x.Value == masterTableRequest.Value).ToList();

            return new Response<IEnumerable<MasterTableResponse>> { Value = masterTableResponses };
        }

        private IEnumerable<MasterTableResponse> GetAllMaster(MasterTableRequest masterTableRequest)
        {
            return DemoQuery.ListMasterTable(masterTableRequest);
        }
    }
}