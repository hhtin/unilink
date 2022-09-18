using EntityFrameworkPaginateCore;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using Unilink.Data.Dto.Member;
using Unilink.Data.Dto.Pagination;
using Unilink.Data.Dto.Party;
using Unilink.Data.Entity;

namespace Unilink.Data.Repository
{
    public interface IPartyRepository : IGenericRepository<Party>
    {
        Task<Page<Party>> searchPagination(PaginationRequestDTO paginationRequestDTO);
    }
}
