using Microsoft.AspNetCore.Mvc;
using System;
using System.Threading.Tasks;
using Unilink.Business.Service;
using Unilink.Business.Utils;
using Unilink.Data.Dto.Pagination;
using Unilink.Data.Dto.Skill;
using Unilink.Data.Entity;
using static Unilink.Api.Config.ResponseFormat;
namespace Unilink.Api.Controllers
{
    [Route("api/v{version:apiVersion}/skills")]
    [ApiController]
    [ApiVersion("1.0")]
    public class SkillController : ControllerBase
    {
        private readonly ISkillService _skillService;
        public SkillController(ISkillService _skillService)
        {
            this._skillService = _skillService;
        }

        [HttpGet("search")] 
        public async Task<IActionResult> search (string searchText, int pageSize, int curPage, string sortBy, string sortType)
        {
            try
            {
                PaginationRequestDTO requestDTO = new PaginationRequestDTO()
                {
                    searchText = searchText,
                    pageSize = pageSize,
                    curPage = curPage,
                    sortBy = sortBy,
                    sortType = sortType
                };
                PaginationResponseDTO<SkillDTO> result = await _skillService.Search(requestDTO);
                if (result != null)
                    return JsonResponse("Search successfully !", 200, result);
                return JsonResponse("Search fail !", 400, null);
            } catch (Exception e)
            {
                return ErrorResponse(e.Message);
            }
        }
        [HttpGet]
        public async Task<IActionResult> GetSkills(bool isActive, bool isGetAll = true)
        {
            try
            {
                object skillList;
                if(!isGetAll)
                {
                    skillList = await _skillService.getAllAsyncByStatus(isActive);
                } else
                {
                    skillList = await _skillService.getAllAsync();
                }
                return JsonResponse("Get successfully !", 200, skillList);

            } catch (Exception e)
            {
                return ErrorResponse(e.Message);
            }
        }
        [HttpGet("{id}")]
        public async Task<IActionResult> GetSkill(Guid id)
        {
            try
            {
                var skill = await _skillService.GetAsync(id);
                return JsonResponse("Get successfully !", 200, skill);

            }
            catch (Exception e)
            {
                return ErrorResponse(e.Message);
            }
        }

        [HttpDelete("{id}")]
        public async Task<IActionResult> DeleteSkill(Guid id)
        {
            try
            {
                await _skillService.Delete(id);
                return JsonResponse("Delete successfully", 200, null);
            }
            catch (Exception e)
            {
                if (e.Message.Contains("not found")) return JsonResponse(e.Message, 400, null);
                return ErrorResponse(e.Message);
            }
        }
        [HttpPut]
        public async Task<IActionResult> Update(SkillDTO dto)
        {
            try
            {
                await _skillService.Update(dto);
                return JsonResponse("Update successfully", 200, null);
            }
            catch (Exception e)
            {
                if (e.Message.Contains("not found")) return JsonResponse(e.Message, 400, null);
                return ErrorResponse(e.Message);
            }
        }
        [HttpPost]
        public async Task<IActionResult> Create(InsertSkillDTO dto)
        {
            try
            {
                await _skillService.InsertAsync(dto);
                return JsonResponse("Create successfully", 200, null);
            }
            catch (Exception e)
            {
                return ErrorResponse(e.Message);
            }
        }
    }
}
