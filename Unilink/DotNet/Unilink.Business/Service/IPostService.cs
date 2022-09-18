using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using Unilink.Data.Dto.Pagination;
using Unilink.Data.Dto.Post;

namespace Unilink.Business.Service
{
    public interface IPostService
    {
        public Task<PostDTO> InsertAsync(InsertPostDTO dto);
        public Task<PostDTO> UpdateAsync(UpdatePostDTO dto);
        public Task<bool> DeleteAsync(Guid id);
        public Task<PostDTO> GetAsync(Guid id);
        public Task<PaginationResponseDTO<PostDTO>> Search(String topic, PaginationRequestDTO searchDTO);
    }
}
