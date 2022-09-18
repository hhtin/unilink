using Microsoft.AspNetCore.Mvc;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Threading.Tasks;
using Unilink.Business.Service;
using Unilink.Data.Dto;
using Unilink.Data.Dto.Pagination;
using Unilink.Data.Dto.Topic;
using Unilink.Data.Entity;
using static Unilink.Api.Config.ResponseFormat;

namespace Unilink.Api.Controllers.v1
{
    [Route("api/v{version:apiVersion}/topics")]
    [ApiController]
    [ApiVersion("1.0")]
    public class TopicController : ControllerBase
    {
        private readonly ITopicService _topicService;
        public TopicController(ITopicService topicService)
        {
            this._topicService = topicService;
        }

        [HttpPost]
        public async Task<IActionResult> CreateTopic(Data.Dto.Topic.InsertTopicDTO insertTopicDTO)
        {
            try
            {
                TopicDTO createdTopic = await _topicService.InsertAsync(insertTopicDTO);
                if(createdTopic != null)
                {
                    return JsonResponse("Create successfully !", 201, createdTopic);
                }
                return JsonResponse("Create fail !", 400, createdTopic);
                
            }
            catch (Exception e)
            {
                return ErrorResponse(e.Message);
            }
        }

        [HttpGet("{id}")]
        public async Task<IActionResult> GetTopicById(Guid id)
        {
            try
            {
                var topic = await _topicService.GetByIdAsync(id);
                if(topic != null)
                {
                    return JsonResponse("Get successfully !", 200, topic);
                }
                return JsonResponse("Not found !", 400, null);

            }
            catch (Exception e)
            {
                return ErrorResponse(e.Message);
            }
        }


        [HttpDelete("{id}")]
        public async Task<IActionResult> DeleteTopicById(Guid id)
        {
            try
            {
                bool checkDelete = await _topicService.DeleteByIdAsync(id);
                if (checkDelete == false)
                {
                    return JsonResponse("Not found !", 400, null);
                }
                return JsonResponse("Delete successfully", 200, null);
            }
            catch (Exception e)
            {
                return ErrorResponse(e.Message);
            }
        }

        [HttpPut]
        public async Task<IActionResult> UpdateTopic(UpdateTopicDTO dto)
        {
            try
            {
                TopicDTO updatedDTO = await _topicService.UpdateByIdAsync(dto);
                if (updatedDTO == null)
                {
                    return JsonResponse("Not found !", 400, null);
                }
                return JsonResponse("Update successfully", 200, updatedDTO);
            }
            catch (Exception e)
            {
                return ErrorResponse(e.Message);
            }
        }

        //[HttpGet]
        //public async Task<IActionResult> SearchTopic([FromQuery] string searchText, [FromQuery] int pageSize, [FromQuery] int curPage,
        //    [FromQuery] string sortBy, [FromQuery] string sortType)
        //{
        //    PaginationRequestDTO requestDTO = new PaginationRequestDTO(searchText, pageSize, curPage, sortBy, sortType);
        //    PaginationResponseDTO<TopicDTO> result = await _topicService.SearchAsync(requestDTO);
        //    if (result != null)
        //        return JsonResponse("search successfully !", 200, result);
        //    return JsonResponse("Search fail !", 400, null);
        //}
        [HttpGet("parties/{partyId}")]
        public async Task<IActionResult> SearchTopicByPartyId(string partyId, [FromQuery] int pageSize, [FromQuery] int curPage,
            [FromQuery] string sortBy, [FromQuery] string sortType)
        {
            PaginationRequestDTO requestDTO = new PaginationRequestDTO(partyId, pageSize, curPage, sortBy, sortType);
            PaginationResponseDTO<TopicDTO> result = await _topicService.SearchAsync(requestDTO);
            if (result != null)
                return JsonResponse("search successfully !", 200, result);
            return JsonResponse("Search fail !", 400, null);
        }

    }
}
