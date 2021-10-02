using System.Collections.Generic;

namespace BaseArchitecture.Repository.Entity.Tables
{
    public class ResponseValidateStock
    {
        public ResponseValidateStock()
        {
            ValidateStock = new ValidateStock();
            ListProductOutOfStock = new List<ProductOutOfStock>();
        }

        public ValidateStock ValidateStock { get; set; }
        public IEnumerable<ProductOutOfStock> ListProductOutOfStock { get; set; }
    }
}
