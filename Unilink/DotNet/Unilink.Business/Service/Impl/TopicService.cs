using EntityFrameworkPaginateCore;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using Unilink.Business.Utils;
using Unilink.Data.Dto.Pagination;
using Unilink.Data.Dto.Topic;
using Unilink.Data.Entity;
using Unilink.Data.Repository;

namespace Unilink.Business.Service.Impl
{
    public class TopicService : ITopicService
    {
        private ITopicRepository _topicRepository;
        private IPartyRepository _partyRepository;
        public TopicService(ITopicRepository topicRepository, IPartyRepository partyRepository)
        {
            this._topicRepository = topicRepository;
            this._partyRepository = partyRepository;
        }

        public async Task<bool> DeleteByIdAsync(Guid id)
        {
            try
            {
                Topic existedTopic = await _topicRepository.GetAsync(id);
                if (existedTopic != null && existedTopic.Status == true)
                {
                    existedTopic.Status = false;
                    int count = await _topicRepository.Update(existedTopic);
                    return true;
                }
                return false;
            }
            catch (Exception e)
            {
                throw new Exception(e.Message);
            }
        }

        public async Task<TopicDTO> GetByIdAsync(Guid id)
        {
            try
            {
                Topic existedTopic = await _topicRepository.GetAsync(id);
                if (existedTopic != null && existedTopic.Status == true)
                {
                    return MapperConfig.GetMapper().Map<TopicDTO>(existedTopic);
                }
                return null;
            }
            catch (Exception e)
            {
                throw new Exception(e.Message);
            }
        }

        public async Task<TopicDTO> InsertAsync(InsertTopicDTO insertTopicDTO)
        {
            try
            {
                Party party = await _partyRepository.GetAsync(insertTopicDTO.PartyId);
                if(party == null)
                {
                    return null;
                }

                Topic topic = MapperConfig.GetMapper().Map<Topic>(insertTopicDTO);
                topic.Id = Guid.NewGuid();
                topic.Status = true;
                topic.CreateDate = DateTime.Now;
                topic.UpdateDate = DateTime.Now;
                int count = await _topicRepository.InsertAsync(topic);

                if (count == 0)
                {
                    return null;
                }
                return MapperConfig.GetMapper().Map<TopicDTO>(topic);
            }
            catch (Exception e)
            {
                throw new Exception(e.Message);
            }
        }

        public async Task<PaginationResponseDTO<TopicDTO>> SearchAsync(PaginationRequestDTO requestDTO)
        {
            try
            {
                PaginationRequestDTO validatedPagination = new PaginationUtils().validatePaginationParam(requestDTO, "Topic");
                Page<Topic> topicPage = await _topicRepository.searchPagination(validatedPagination);
                PaginationResponseDTO<TopicDTO> pagination = new PaginationResponseDTO<TopicDTO>();
                if (topicPage != null)
                {
                    List<TopicDTO> dataList = new List<TopicDTO>();
                    topicPage.Results.ToList().ForEach(e => dataList.Add(MapperConfig.GetMapper().Map<TopicDTO>(e)));
                    pagination.Data = dataList;
                    pagination.PageIndex = validatedPagination.curPage;
                    pagination.Limit = topicPage.PageSize;
                    pagination.totalPage = topicPage.PageCount;
                    pagination.sortBy = validatedPagination.sortBy;
                    pagination.sortType = validatedPagination.sortType;
                    pagination.searchText = requestDTO.searchText;
                    return pagination;
                }
                return null;
            }
            catch (Exception e)
            {
                throw new Exception(e.Message);
            }
        }

        public async Task<TopicDTO> UpdateByIdAsync(UpdateTopicDTO updateTopicDTO)
        {
            try
            {
                Topic existedTopic = await _topicRepository.GetAsync(updateTopicDTO.Id);
                if (existedTopic == null || existedTopic.Status == false)
                {
                    return null;
                }

                existedTopic.UpdateDate = DateTime.Now;
                existedTopic.Title = updateTopicDTO.Title;
                existedTopic.Description = updateTopicDTO.Description;

                int count = await _topicRepository.Update(existedTopic);

                if (count == 0)
                {
                    return null;
                }
                return MapperConfig.GetMapper().Map<TopicDTO>(existedTopic);
            }
            catch (Exception e)
            {
                throw new Exception(e.Message);
            }
        }
    }
}
