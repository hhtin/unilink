using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using Unilink.Data.Dto.Pagination;
using Unilink.Data.Dto.Skill;
using Unilink.Data.Entity;

namespace Unilink.Business.Service
{
    public interface ISkillService
    {
        public Task<IEnumerable<Skill>> getAllAsync();
        public Task<IEnumerable<Skill>> getAllAsyncByStatus(bool isActive);
        public Task<Skill> GetAsync(Guid id);
        public Task<int> InsertAsync(InsertSkillDTO entity);
        public Task<int> Update(SkillDTO entity);
        public Task<int> Delete(Guid id);
        public Task<int> HardDelete(Guid id);
        public Task<PaginationResponseDTO<SkillDTO>> Search(PaginationRequestDTO searchDTO);
    }
}
