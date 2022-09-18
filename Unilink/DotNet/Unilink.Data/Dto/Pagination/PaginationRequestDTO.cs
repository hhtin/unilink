using System;
using System.Collections.Generic;
using System.ComponentModel.DataAnnotations;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace Unilink.Data.Dto.Pagination
{
    public class PaginationRequestDTO
    {
        public PaginationRequestDTO() { }

        public PaginationRequestDTO(string searchText, int pageSize, int curPage, string sortBy, string sortType) {
            this.curPage = curPage;
            this.pageSize = pageSize;
            this.sortBy = sortBy;
            this.sortType = sortType;
            this.searchText = searchText;
        }

        public string searchText { get; set; }

        public int pageSize { get; set; }

        public int curPage { get; set; }

        public string sortBy { get; set; }

        public string sortType { get; set; }
    }
}
