using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using Unilink.Data.Dto;
using Unilink.Data.Dto.Major;
using Unilink.Data.Dto.Pagination;
using Unilink.Data.Entity;

namespace Unilink.Business.Service
{
    public interface IMajorService
    {
        public Task<IEnumerable<Major>> getAllAsync();
        public Task<IEnumerable<Major>> getAllAsyncByStatus(bool isActive);
        public Task<Major> GetAsync(Guid id);
        public Task<int> InsertAsync(InsertMajorDTO entity);
        public Task<int> Update(MajorDTO entity);
        public Task<int> Delete(Guid id);
        public Task<int> HardDelete(Guid id);

        //public Task<SearchMajorResponseDTO> Search(SearchMajorRequestDTO searchDTO);
        public Task<PaginationResponseDTO<MajorDTO>> Search(PaginationRequestDTO searchDTO);
    }
}
