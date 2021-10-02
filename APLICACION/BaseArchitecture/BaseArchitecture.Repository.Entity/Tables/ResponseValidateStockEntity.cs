using System.Collections.Generic;

namespace BaseArchitecture.Repository.Entity.Tables
{
    public class ResponseValidateStockEntity
    {
        public ResponseValidateStockEntity()
        {
            ValidateStock = new ValidateStock();
            ListProductOutOfStock = new List<ProductOutOfStockEntity>();
        }

        public ValidateStock ValidateStock { get; set; }
        public IEnumerable<ProductOutOfStockEntity> ListProductOutOfStock { get; set; }
    }
}
