using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using Unilink.Data.Dto.Pagination;
using Unilink.Data.Dto.Topic;

namespace Unilink.Business.Service
{
    public interface ITopicService
    {
        public Task<TopicDTO> InsertAsync(InsertTopicDTO insertTopicDTO);

        public Task<TopicDTO> GetByIdAsync(Guid id);

        public Task<bool> DeleteByIdAsync(Guid id);

        public Task<TopicDTO> UpdateByIdAsync(UpdateTopicDTO updateTopicDTO);

        public Task<PaginationResponseDTO<TopicDTO>> SearchAsync(PaginationRequestDTO requestDTO);
    }
}
