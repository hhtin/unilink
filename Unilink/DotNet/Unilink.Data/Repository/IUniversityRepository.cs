using EntityFrameworkPaginateCore;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using Unilink.Data.Dto.Pagination;
using Unilink.Data.Entity;

namespace Unilink.Data.Repository
{
    public interface IUniversityRepository : IGenericRepository<University>
    {
        Task<Page<University>> searchPagination(PaginationRequestDTO paginationRequestDTO);
        Task<int> disabledEntry(Guid Id);
        Task<IEnumerable<University>> GetListAsyncByStatus(bool isActive);
    }
}
