using Microsoft.AspNetCore.Mvc;
using System;
using System.Threading.Tasks;
using Unilink.Business.Service;
using Unilink.Business.Utils;
using Unilink.Data.Dto.Major;
using Unilink.Data.Dto.Pagination;
using Unilink.Data.Entity;
using static Unilink.Api.Config.ResponseFormat;
namespace Unilink.Api.Controllers
{
    [Route("api/v{version:apiVersion}/majors")]
    [ApiController]
    [ApiVersion("1.0")]
    public class MajorController : ControllerBase
    {
        private readonly IMajorService _majorService;
        public MajorController(IMajorService _majorService)
        {
            this._majorService = _majorService;
        }

        [HttpGet]
        public async Task<IActionResult> GetMajors(bool isActive, bool isGetAll = true)
        {
            try
            {
                object majorList;
                if (!isGetAll)
                {
                    majorList = await _majorService.getAllAsyncByStatus(isActive);
                }
                else
                {
                    majorList = await _majorService.getAllAsync();
                }
                return JsonResponse("Get successfully !", 200, majorList);
            } catch (Exception e)
            {
                return ErrorResponse(e.Message);
            }
        }
        [HttpGet("search")]
        public async Task<IActionResult> Search([FromQuery] string searchText, [FromQuery] int pageSize, [FromQuery] int curPage,
            [FromQuery] string sortBy, [FromQuery] string sortType)
        {
            try
            {
                PaginationRequestDTO requestDTO = new PaginationRequestDTO(searchText, pageSize, curPage, sortBy, sortType);
                PaginationResponseDTO<MajorDTO> result = await _majorService.Search(requestDTO);
                if (result != null)
                    return JsonResponse("Search successfully !", 200, result);
                return JsonResponse("Search fail !", 400, null);
                //var listMajor = await _majorService.Search(searchDTO);
                //return JsonResponse("Get successfully !", 200, listMajor);
            }
            catch (Exception e)
            {
                return ErrorResponse(e.Message);
            }
        }
        [HttpGet("{id}")]
        public async Task<IActionResult> GetMajor(Guid id)
        {
            try
            {
                var major = await _majorService.GetAsync(id);
                return JsonResponse("Get successfully !", 200, major);
            }
            catch (Exception e)
            {
                return ErrorResponse(e.Message);
            }
        }

        [HttpDelete("{id}")]
        public async Task<IActionResult> DeleteMajor(Guid id)
        {
            try
            {
                await _majorService.Delete(id);
                return JsonResponse("Delete successfully !", 200, null);
            }
            catch (Exception e)
            {
                if (e.Message.Contains("not found")) return JsonResponse(e.Message, 400, null);
                return ErrorResponse(e.Message);
            }
        }
        [HttpPut]
        public async Task<IActionResult> Update(MajorDTO dto)
        {
            try
            {
                await _majorService.Update(dto);
                return JsonResponse("Update successfully !", 200, null);
            }
            catch (Exception e)
            {
                if (e.Message.Contains("not found")) return JsonResponse(e.Message, 400, null);
                return ErrorResponse(e.Message);
            }
        }
        [HttpPost]
        public async Task<IActionResult> Create(InsertMajorDTO dto)
        {
            try
            {
                await _majorService.InsertAsync(dto);
                return JsonResponse("Create successfully !", 200, null);
            }
            catch (Exception e)
            {
                return ErrorResponse(e.Message);
            }
        }
    }
}
