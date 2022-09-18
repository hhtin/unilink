using EntityFrameworkPaginateCore;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using Unilink.Data.Dto;
using Unilink.Data.Dto.Member;
using Unilink.Data.Dto.Pagination;
using Unilink.Data.Dto.PartyRequest;
using Unilink.Data.Entity;

namespace Unilink.Data.Repository
{
    public interface IMemberRepository : IGenericRepository<Member>
    {
        Task<IEnumerable<Member>> SearchAsync(SearchMemberRequestDTO searchMemberDTO);
        Task<double> CountSearchAsync(SearchMemberRequestDTO searchMemberDTO);
        public Task<Member> FindMemberByEmail(string email);

        Task<Page<Member>> searchPagination(PaginationRequestDTO paginationRequestDTO);
    }
}
