using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using Unilink.Data.Entity;

namespace Unilink.Data.Repository
{
    public interface IRoleRepository : IGenericRepository<Role>
    {
        Task<IEnumerable<Role>> GetListAsyncByStatus(bool isActive);
    }
}
