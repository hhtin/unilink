using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using Unilink.Business.Utils;
using Unilink.Data.Dto.Role;
using Unilink.Data.Entity;
using Unilink.Data.Repository;

namespace Unilink.Business.Service.Impl
{
    public class RoleService : IRoleService
    {
        private IRoleRepository _roleRepository;
        
        public RoleService(IRoleRepository roleRepository)
        {
            this._roleRepository = roleRepository;
        }

        public async Task<int> Delete(Guid id)
        {
            try
            {
                Role role = await _roleRepository.GetAsync(id);
                if (role == null) throw new Exception("Not found role with following id !");
                role.Status = false;
                return await _roleRepository.Update(role);
            }
            catch (Exception e)
            {
                throw new Exception(e.Message);
            }
        }

        public async Task<IEnumerable<Role>> getAllAsync()
        {
            try
            {
                return await _roleRepository.GetAllAsync();
            }
            catch (Exception e)
            {
                throw new Exception(e.Message);
            }
        }

        public async Task<IEnumerable<Role>> getAllAsyncByStatus(bool isActive)
        {
            try
            {
                return await _roleRepository.GetListAsyncByStatus(isActive);
            }
            catch (Exception e)
            {
                throw new Exception(e.Message);
            }
        }

        public async Task<Role> GetAsync(Guid id)
        {
            try
            {
                return await _roleRepository.GetAsync(id);
            }
            catch (Exception e)
            {
                throw new Exception(e.Message);
            }
        }

        public async Task<int> HardDelete(Guid id)
        {
            try
            {
                Role role = await _roleRepository.GetAsync(id);
                if (role == null) throw new Exception("Not found role with following id !");
                return await _roleRepository.Delete(id);
            }
            catch (Exception e)
            {
                throw new Exception(e.Message);
            }
        }

        public async Task<int> InsertAsync(InsertRoleDTO insertRoleDTO)
        {
            try
            {
                Role role = MapperConfig.GetMapper().Map<Role>(insertRoleDTO);
                role.Id = Guid.NewGuid();
                role.Status = true;
                return await _roleRepository.InsertAsync(role);
            }
            catch (Exception e)
            {
                throw new Exception(e.Message);
            }
        }

        public async Task<int> Update(RoleDTO roleDTO)
        {
            try
            {
                Role role = await _roleRepository.GetAsync(roleDTO.Id);
                if (role == null) throw new Exception("Not found role with following id !");
                role = MapperConfig.GetMapper().Map<Role>(roleDTO);
                return await _roleRepository.Update(role);
            } catch (Exception e)
            {
                throw new Exception(e.Message);
            }
        }
    }
}
