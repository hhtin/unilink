using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace Unilink.Data.Dto.Pagination
{
    public class PaginationResponseDTO<T>
    {
        public string searchText { get; set; }

        public int PageIndex { get; set; }

        public int totalPage { get; set; }

        public int Limit { get; set; }

        public string sortBy { get; set; }

        public string sortType { get; set; }

        public List<T> Data { get; set; }
    }
}
