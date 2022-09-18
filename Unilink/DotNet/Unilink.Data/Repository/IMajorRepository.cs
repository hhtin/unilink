using EntityFrameworkPaginateCore;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using Unilink.Data.Dto;
using Unilink.Data.Dto.Major;
using Unilink.Data.Dto.Pagination;
using Unilink.Data.Entity;

namespace Unilink.Data.Repository
{
    public interface IMajorRepository:IGenericRepository<Major>
    {
        Task<IEnumerable<Major>> SearchAsync(SearchMajorRequestDTO searchMajorDTO);
        Task<double> CountSearchAsync(SearchMajorRequestDTO searchMajorDTO);
        Task<Page<Major>> searchPagination(PaginationRequestDTO validatedPagination);
        Task<IEnumerable<Major>> GetListAsyncByStatus(bool isActive);
        Task<IEnumerable<Major>> GetAllCustomAsync();
        Task<Major> GetCustomAsync(Guid id);
    }
}
