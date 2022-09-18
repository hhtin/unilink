using EntityFrameworkPaginateCore;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using Unilink.Data.Dto.Pagination;
using Unilink.Data.Entity;

namespace Unilink.Data.Repository.Impl
{
    public interface IPostRepository : IGenericRepository<Post>
    {
        Task<Page<Post>> searchPagination(String topic, PaginationRequestDTO paginationRequestDTO);
    }
}
