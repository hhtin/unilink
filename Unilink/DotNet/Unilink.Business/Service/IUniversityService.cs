using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using Unilink.Data.Dto.Pagination;
using Unilink.Data.Dto.University;
using Unilink.Data.Entity;

namespace Unilink.Business.Service
{
    public interface IUniversityService
    {
        public Task<IEnumerable<University>> getAllAsync();
        public Task<IEnumerable<University>> getAllAsyncByStatus(bool isActive);
        public Task<University> GetAsync(Guid id);
        public Task<int> InsertAsync(InsertUniversityDTO entity);
        public Task<int> Update(UniversityDTO entity);
        public Task<int> Delete(Guid id);
        public Task<int> HardDelete(Guid id);
        public Task<PaginationResponseDTO<UniversityDTO>> Search(PaginationRequestDTO searchDTO);
    }
}
