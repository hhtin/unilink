using Microsoft.AspNetCore.Authorization;
using Microsoft.AspNetCore.Http;
using Microsoft.AspNetCore.Mvc;
using Microsoft.Data.SqlClient;
using System;
using System.Collections.Generic;
using System.ComponentModel.DataAnnotations;
using System.Linq;
using System.Threading.Tasks;
using Unilink.Api.Config;
using Unilink.Business.Service;
using Unilink.Business.Service.Impl;
using Unilink.Business.Utils;
using Unilink.Data.Dto.Pagination;
using Unilink.Data.Dto.University;
using Unilink.Data.Entity;
using Unilink.Data.Repository;
using static Unilink.Api.Config.ResponseFormat;

namespace Unilink.Api.Controllers
{
    [Route("api/v{version:apiVersion}/universities")]
    [ApiController]
    [ApiVersion("1.0")]
    public class UniversityController : ControllerBase
    {
        private readonly IUniversityService _universityService;
        public UniversityController(IUniversityService _universityService)
        {
            this._universityService = _universityService;
        }

        [HttpGet("search")]
        public async Task<IActionResult> search(string searchText, int pageSize, int curPage, string sortBy, string sortType)
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
                PaginationResponseDTO<UniversityDTO> result = await _universityService.Search(requestDTO);
                if (result != null)
                    return JsonResponse("Search successfully !", 200, result);
                return JsonResponse("Search fail !", 400, null);
            }
            catch (Exception e)
            {
                return ErrorResponse(e.Message);
            }
        }
        [HttpGet]
        public async Task<IActionResult> GetUniversities(bool isActive, bool isGetAll = true)
        {
            try
            {
                object uniList;
                if (!isGetAll)
                {
                    uniList = await _universityService.getAllAsyncByStatus(isActive);
                } else
                {
                    uniList = await _universityService.getAllAsync();
                }
                return JsonResponse("Get successfully !", 200, uniList);

            }
            catch (Exception e)
            {
                return ErrorResponse(e.Message);
            }
        }
        [HttpGet("{id}")]
        public async Task<IActionResult> GetUniversity(Guid id)
        {
            try
            {
                var uni = await _universityService.GetAsync(id);
                return JsonResponse("Get successfully !", 200, uni);

            }
            catch (Exception e)
            {
                return ErrorResponse(e.Message);
            }
        }

        [HttpDelete("{id}")]
        public async Task<IActionResult> DeleteUniversity(Guid id, bool isHardDelete = false)
        {
            try
            {
                if (isHardDelete)
                {
                    await _universityService.HardDelete(id);
                } else
                {
                    await _universityService.Delete(id);
                }
                return JsonResponse("Delete successfully", 200, null);
            }
            catch (Exception e)
            {
                if (e.Message.Contains("not found")) return JsonResponse(e.Message, 400, null);
                return ErrorResponse(e.Message);
            }
        }
        [HttpPut]
        public async Task<IActionResult> Update(UniversityDTO dto)
        {
            try
            {
                await _universityService.Update(dto);
                return JsonResponse("Update successfully", 200, null);
            }
            catch (Exception e)
            {
                if (e.Message.Contains("not found")) return JsonResponse(e.Message, 400, null);
                return ErrorResponse(e.Message);
            }
        }
        [HttpPost]
        public async Task<IActionResult> Create(InsertUniversityDTO dto)
        {
            try
            {
                await _universityService.InsertAsync(dto);
                return JsonResponse("Create successfully", 200, null);
            }
            catch (Exception e)
            {
                return ErrorResponse(e.Message);
            }

        }
    }
}
