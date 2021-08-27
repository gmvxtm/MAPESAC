using BaseArchitecture.Application.TransferObject.Request.Base;
using BaseArchitecture.Cross.SystemVariable.Model;
using System;
using System.Collections.Generic;

namespace BaseArchitecture.Application.TransferObject.Request.Demo
{
    public class PersonFilterRequest
    {
        public string IdMasterTableTypeDocument { get; set; }
        public DateTime StartDate { get; set; }
        public DateTime EndDate { get; set; }
        public string RecordStatus { get; set; }
        public List<FilterColumn> FilterColumn { get; set; }
        public PaginationRequest Pagination { get; set; }
    }
}
