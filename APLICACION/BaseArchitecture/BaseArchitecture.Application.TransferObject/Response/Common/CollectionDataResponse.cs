using System.Collections.Generic;

namespace BaseArchitecture.Application.TransferObject.Response.Common
{
    public class CollectionDataResponse<T>
    {
        public IEnumerable<T> Collection { get; set; }
        public PaginationResponse Pagination { get; set; }
    }
}