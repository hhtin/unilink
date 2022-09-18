using Microsoft.AspNetCore.Mvc;
using Microsoft.Extensions.Configuration;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Threading.Tasks;
using Unilink.Business.Service;
using Unilink.Data.Dto.Pagination;
using Unilink.Data.Dto.Post;
using static Unilink.Api.Config.ResponseFormat;

namespace Unilink.Api.Controllers.v1
{
    [Route("api/v{version:apiVersion}/posts")]
    [ApiController]
    [ApiVersion("1.0")]
    public class PostController : ControllerBase
    {
        private readonly IPostService _postService;

        public PostController(IPostService postService)
        {
            this._postService = postService;
        }

        [HttpPost]
        public async Task<IActionResult> CreatePost(InsertPostDTO insertPostDTO)
        {
            try
            {
                PostDTO insertedPostDTO = await _postService.InsertAsync(insertPostDTO);
                if (insertedPostDTO == null)
                    return JsonResponse("Insert failed, try again !", 400, null);
                return JsonResponse("Insert successfully !", 201, insertedPostDTO);
            
            }
            catch(Exception e)
            {
                return ErrorResponse(e.Message);
            }

        }

        [HttpGet("{id}")]
        public async Task<IActionResult> GetPost(Guid id)
        {
            try
            {
                PostDTO post = await _postService.GetAsync(id);
                if (post != null)
                {
                    return JsonResponse("Get successfully !", 200, post);
                }
                return JsonResponse("Not found !", 400, null);

            }
            catch (Exception e)
            {
                return ErrorResponse(e.Message);
            }
        }

        [HttpDelete("{id}")]
        public async Task<IActionResult> DeletePostById(Guid id)
        {
            try
            {
                bool checkDelete = await _postService.DeleteAsync(id);
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
        public async Task<IActionResult> UpdatePost(UpdatePostDTO dto)
        {
            try
            {
                PostDTO updatedDTO = await _postService.UpdateAsync(dto);
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

        [HttpGet]
        public async Task<IActionResult> SearchPost([FromQuery] String topic, [FromQuery] string searchText, [FromQuery] int pageSize, [FromQuery] int curPage,
            [FromQuery] string sortBy, [FromQuery] string sortType)
        {
            try
            {
                PaginationRequestDTO requestDTO = new PaginationRequestDTO(searchText, pageSize, curPage, sortBy, sortType);
                PaginationResponseDTO<PostDTO> result = await _postService.Search(topic,requestDTO);
                if (result != null)
                    return JsonResponse("search successfully !", 200, result);
                return JsonResponse("Search fail !", 400, null);
            }
            catch (Exception e)
            {
                return ErrorResponse(e.Message);
            }
        }


    }
}
