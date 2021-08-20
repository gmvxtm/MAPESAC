namespace BaseArchitecture.Application.TransferObject.Request.Base
{
    public class PaginationRequest
    {
        public int CurrentPage { get; set; }
        public int RowsPerPage { get; set; }
        public string ColumnOrder { get; set; }
        public string TypeOrder { get; set; }
    }
}