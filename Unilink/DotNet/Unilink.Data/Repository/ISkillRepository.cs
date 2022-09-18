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
    public interface ISkillRepository : IGenericRepository<Skill>
    {
        Task<Page<Skill>> searchPagination(PaginationRequestDTO paginationRequestDTO);
        Task<IEnumerable<Skill>> GetListAsyncByStatus(bool isActive);
        Task<IEnumerable<Skill>> GetAllCustomAsync();
    }
}
