using Microsoft.EntityFrameworkCore;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using Unilink.Data.Config;
using Unilink.Data.Entity;

namespace Unilink.Data.Repository.Impl
{
    public class RoleRepository : GenericRepository<Role>,IRoleRepository
    {
        public RoleRepository(ApplicationDbContext context) : base(context)
        {

        }

        public async Task<IEnumerable<Role>> GetListAsyncByStatus(bool isActive)
        {
            try
            {
                return await base.GetEntity().Where(x => x.Status == isActive).ToListAsync();
            }
            catch (Exception e)
            {
                throw new Exception(e.Message);
            }
        }
    }
}
