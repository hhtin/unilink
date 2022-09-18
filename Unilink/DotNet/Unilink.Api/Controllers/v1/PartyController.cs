using Microsoft.AspNetCore.Mvc;
using Microsoft.Extensions.Configuration;
using System;
using System.Collections.Generic;
using System.Threading.Tasks;
using Unilink.Business.Service;
using Unilink.Data.Dto.Pagination;
using Unilink.Data.Dto.Party;
using Unilink.Data.Dto.PartyRequest;
using static Unilink.Api.Config.ResponseFormat;

namespace Unilink.Api.Controllers.v1
{
    [Route("api/v{version:apiVersion}/parties")]
    [ApiController]
    [ApiVersion("1.0")]
    public class PartyController : ControllerBase
    {
        private readonly IPartyService _partyService;
        private readonly IConfiguration _configuration;
        public PartyController(IPartyService partyService, IConfiguration configuration)
        {
            this._partyService = partyService;
            this._configuration = configuration;
        }

        [HttpPost]
        public async Task<IActionResult> Create([FromForm] InsertPartyDTO insertPartyDTO)
        {
            string host = _configuration["Host"];
            var party = await _partyService.InsertAsync(insertPartyDTO, host);
            if (party == null) return JsonResponse("Insert failed, try again !", 204, null);
            return JsonResponse("Insert successfully !", 201, party);
        }

        [HttpDelete("{id}")]
        public async Task<IActionResult> DeleteParty(Guid id)
        {
            bool checkDelete = await _partyService.DeleteAsync(id);
            if (checkDelete == false) return JsonResponse("Not found !", 400, null);
            return JsonResponse("Deleted !", 200, null);
        }

        [HttpGet("{id}")]
        public async Task<IActionResult> GetParty(Guid id)
        {
            PartyDTO dto = await _partyService.GetAsync(id);
            if (dto == null) return JsonResponse("Not found !", 400, null);
            return JsonResponse("Get success !", 200, dto);
        }

        [HttpPut]
        public async Task<IActionResult> UpdateParty([FromForm] UpdatePartyDTO updatePartyDTO)
        {
            string host = _configuration["Host"];
            var party = await _partyService.UpdateAsync(updatePartyDTO, host);
            if (party == null) return JsonResponse("Not found !", 400, null);
            return JsonResponse("Update successfully !", 200, party);
        }

        [HttpGet]
        public async Task<IActionResult> SearchParty([FromQuery] string searchText, [FromQuery] int pageSize, [FromQuery] int curPage,
            [FromQuery] string sortBy, [FromQuery] string sortType)
        {
            PaginationRequestDTO requestDTO = new PaginationRequestDTO(searchText, pageSize, curPage, sortBy, sortType);
            PaginationResponseDTO<PartyDTO> result = await _partyService.Search(requestDTO);
            if(result != null)
                return JsonResponse("search successfully !", 200, result);
            return JsonResponse("Search fail !", 400, null);
        }
        [HttpGet("{id}/members/request")]
        public async Task<IActionResult> getRequestMember(Guid id, int type)
        {
            try
            {
                PartyRequestParty dto = new PartyRequestParty() { PartyId = id, Status = type };
                List<PartyRequestDTO> list = (List<PartyRequestDTO>)await _partyService.getAllRequestByRuleAndPartyId(dto);
                return JsonResponse("Get successfully !", 200, list);
            }
            catch (Exception e)
            {
                if (e.Message.ToLower().Contains("not found")) return JsonResponse(e.Message, 400, null);
                return ErrorResponse(e.Message);
            }
        }
        [HttpPut("{id}/members/{memberId}/reject")]
        public async Task<IActionResult> rejectParty(Guid id, Guid memberId)
        {
            try
            {
                PartyRequestDTO requestDTO = new PartyRequestDTO() { MemberId = memberId, PartyId = id };
                await _partyService.rejectMember(requestDTO);
                return JsonResponse("Reject successfully !", 200, null);
            }
            catch (Exception e)
            {
                if (e.Message.ToLower().Contains("not found")) return JsonResponse(e.Message, 400, null);
                return ErrorResponse(e.Message);
            }
        }
        [HttpPost("{id}/members/{memberId}/accept")]
        public async Task<IActionResult> requestParty(Guid id, Guid memberId)
        {
            try
            {
                PartyRequestDTO requestDTO = new PartyRequestDTO() { MemberId = memberId, PartyId = id };
                await _partyService.acceptMember(requestDTO);
                return JsonResponse("Accept successfully !", 200, null);
            }
            catch (Exception e)
            {
                if (e.Message.ToLower().Contains("not found")) return JsonResponse(e.Message, 400, null);
                return ErrorResponse(e.Message);
            }
        }
        [HttpGet("members/{memberId}")]
        public async Task<IActionResult> getMemberByPartyId(Guid memberId)
        {
            try
            {
                List<PartyDTO> list = await _partyService.getPartyByMemberId(memberId);
                return JsonResponse("Get successfully !", 200, list);
            }
            catch (Exception e)
            {
                if (e.Message.ToLower().Contains("not found")) return JsonResponse(e.Message, 400, null);
                return ErrorResponse(e.Message);
            }
        }

    }
}
