using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using Unilink.Data.Dto.Role;
using Unilink.Data.Entity;

namespace Unilink.Business.Service
{
    public interface IRoleService
    {
        public Task<IEnumerable<Role>> getAllAsync();
        public Task<IEnumerable<Role>> getAllAsyncByStatus(bool isActive);
        public Task<Role> GetAsync(Guid id);
        public Task<int> InsertAsync(InsertRoleDTO entity);
        public Task<int> Update(RoleDTO entity);
        public Task<int> Delete(Guid id);
        public Task<int> HardDelete(Guid id);
    }
}
