using Microsoft.AspNetCore.Http;
using Microsoft.AspNetCore.Mvc;
using Microsoft.Extensions.Configuration;
using System;
using System.Collections.Generic;
using System.ComponentModel.DataAnnotations;
using System.Threading.Tasks;
using Unilink.Business.Service;
using Unilink.Business.utils;
using Unilink.Business.Utils;
using Unilink.Data.Dto.FirebaseMessageToken;
using Unilink.Data.Dto.Major;
using Unilink.Data.Dto.Member;
using Unilink.Data.Dto.MemberDetails;
using Unilink.Data.Dto.Pagination;
using Unilink.Data.Dto.PartyRequest;
using Unilink.Data.Dto.Skill;
using Unilink.Data.Entity;
using static Unilink.Api.Config.ResponseFormat;
namespace Unilink.Api.Controllers
{
    [Route("api/v{version:apiVersion}/members")]
    [ApiController]
    [ApiVersion("1.0")]
    public class MemberController : ControllerBase
    {
        private readonly IMemberService _memberServce;
        private readonly IConfiguration configuration;
        private readonly IUserResolverService _userResolverService;
        private IFirebaseMessageTokenService _firebaseMessageTokenService;
        public MemberController(IMemberService _memberServce,IConfiguration configuration,
            IUserResolverService userResolverService,
            IFirebaseMessageTokenService firebaseMessageTokenService)
        {
            this._memberServce = _memberServce;
            this.configuration = configuration;
            this._userResolverService = userResolverService;
            this._firebaseMessageTokenService = firebaseMessageTokenService;
        }
        [HttpPost]
        public async Task<IActionResult> Create([FromForm] InsertMemberDTO insertMemberDTO, [FromQuery] string deviceToken = "")
        {
            try {
                string host = configuration["Host"];
                Member member = await _memberServce.InsertAsync(insertMemberDTO, host);
                if (member == null) return JsonResponse("Insert failed, try again !",204, null);
                // RedirectAtion
                MemberDTO memberDTO = MapperConfig.GetMapper().Map<MemberDTO>(member);
                FirebaseMessageTokenDTO messageToken = await _firebaseMessageTokenService.GetByMemberId(member.Id);
                if (messageToken == null)
                {
                    if (!deviceToken.Equals(""))
                    {
                        InsertMessageToken insertToken = new InsertMessageToken()
                        {
                            token = deviceToken,
                            memberId = member.Id
                        };
                        await _firebaseMessageTokenService.CreateToken(insertToken);
                        messageToken = await _firebaseMessageTokenService.GetByMemberId(member.Id);
                    }
                }
                else
                {
                    if (!deviceToken.Equals(""))
                    {
                        messageToken.token = deviceToken;
                        await _firebaseMessageTokenService.UpdateToken(messageToken);
                    }
                }
                if (messageToken != null)
                {
                  await FirebaseMessageUtil.sendMessageToOne(messageToken.token, "Unilink Học Nhóm", "Chào mừng bạn đồng hành với chúng tôi,... xem chi tiết tại hộp thư của bạn");
                }
            
                return Created(string.Concat(new[] {
                    host, "/api/",
                    "v",HttpContext.GetRequestedApiVersion().ToString(),
                    "/mails/",
                    member.Email,"?name=",
                    string.Concat(new[] { member.FirstName, " ", member.LastName })
                }), JsonResponse("Insert successfully !", 201, memberDTO).Value);
                } catch (Exception e)
                    {
                        if (e.Message.ToLower().Contains("not found")) return JsonResponse(e.Message, 400, null);
                        return ErrorResponse(e.Message);
             }
        }


        //[HttpGet("search")]
        //public async Task<IActionResult> Search(SearchMemberRequestDTO searchDTO)
        //{
        //    return Ok(await _memberServce.Search(searchDTO));
        //}

        [HttpGet("{id}")]
        public async Task<IActionResult> GetMember(Guid id)
        {
            Member member = await _memberServce.GetAsync(id);
            if (member == null) return JsonResponse("Not found, try again !", 400, null);
            return JsonResponse("Get successfully !", 200, member);
        }

        [HttpDelete("{id}")]
        public async Task<IActionResult> DeleteMember(Guid id)
        {
            bool checkDelete = await _memberServce.Delete(id);
            if (checkDelete == false) return JsonResponse("Delete failed, try again !", 400, null);
            return JsonResponse("Delete successfully !", 200, null);
        }

        [HttpPut]
        public async Task<IActionResult> Update([FromForm] UpdateMemberDTO dto)
        {
            string host = configuration["Host"];
            MemberDTO updatedMember = await _memberServce.Update(dto, host);
            if (updatedMember == null) return JsonResponse("Update failed, try again !", 400, null);
            return JsonResponse("Update successfully !", 200, updatedMember);
        }

        [HttpGet]
        public async Task<IActionResult> SearchMember([FromQuery] string searchText, [FromQuery] int pageSize, [FromQuery] int curPage,
            [FromQuery] string sortBy, [FromQuery] string sortType)
        {
            PaginationRequestDTO requestDTO = new PaginationRequestDTO(searchText, pageSize, curPage, sortBy, sortType);
            PaginationResponseDTO<MemberDTO> result = await _memberServce.Search(requestDTO);
            if (result != null)
                return JsonResponse("search successfully !", 200, result);
            return JsonResponse("Search fail !", 400, null);
        }
        [HttpPost("{id}/parties/{partyId}/request")] 
        public async Task<IActionResult> requestParty(Guid id, Guid partyId)
        {
            try
            {
                PartyRequestInsertDTO requestDTO = new PartyRequestInsertDTO() { MemberId = id, PartyId = partyId };
                await _memberServce.requestParty(requestDTO);
                return JsonResponse("Request successfully !", 200, null);
            } catch (Exception e)
            {
                if (e.Message.ToLower().Contains("not found")) return JsonResponse(e.Message, 400, null);
                return ErrorResponse(e.Message);
            }
        }
        [HttpGet("{id}/parties/request")]
        public async Task<IActionResult> getRequestParty(Guid id, int type)
        {
            try
            {
                PartyRequestMember dto = new PartyRequestMember() { MemberId = id, Status = type };
                List<PartyRequestDTO> list = (List<PartyRequestDTO>) await _memberServce.getAllRequestByRuleAndMemberId(dto);
                return JsonResponse("Get successfully !", 200, list);
            }
            catch (Exception e)
            {
                if (e.Message.ToLower().Contains("not found")) return JsonResponse(e.Message, 400, null);
                return ErrorResponse(e.Message);
            }
        }
        [HttpPut("{id}/parties/{partyId}/reject")]
        public async Task<IActionResult> rejectParty(Guid id, Guid partyId)
        {
            try
            {
                PartyRequestDTO requestDTO = new PartyRequestDTO() { MemberId = id, PartyId = partyId };
                await _memberServce.rejectParty(requestDTO);
                return JsonResponse("Reject successfully !", 200, null);
            }
            catch (Exception e)
            {
                if (e.Message.ToLower().Contains("not found")) return JsonResponse(e.Message, 400, null);
                return ErrorResponse(e.Message);
            }
        }
        [HttpGet("parties/{partyId}")]
        public async Task<IActionResult> getMemberByPartyId(Guid partyId)
        {
            try
            {
                List<MemberDTO> list = await _memberServce.getMemberByPartyId(partyId);
                return JsonResponse("Get successfully !", 200, list);
            }
            catch (Exception e)
            {
                if (e.Message.ToLower().Contains("not found")) return JsonResponse(e.Message, 400, null);
                return ErrorResponse(e.Message);
            }
        }

        [HttpGet("identifier")]
        public async Task<IActionResult> getCurrentId()
        {
            return JsonResponse("Get successfully !", 200, _userResolverService.GetMemberId().ToString());
        }

        //[HttpGet("{id}/majors/")]
        //public async Task<IActionResult> getMajorByMemberId(Guid id)
        //{
        //    try
        //    {
        //        List<MajorDTO> majors = await _memberServce.getAllMajorByMemberId(id);
        //        return JsonResponse("Search successfully !", 200, majors);
        //    }
        //    catch (Exception e)
        //    {
        //        if (e.Message.ToLower().Contains("not found")) return JsonResponse(e.Message, 400, null);
        //        return ErrorResponse(e.Message);
        //    }
        //}

        [HttpGet("{id}/details/")]
        public async Task<IActionResult> getMemberDetailsByMemberId(Guid id)
        {
            try
            {
                List<MajorDTO> majors = await _memberServce.getAllMajorByMemberId(id);
                List<SkillDTO> skills = await _memberServce.getAllSkillsByMemberId(id);
                Member member = await _memberServce.GetAsync(id);
                MemberDetailsDTO details = MapperConfig.GetMapper().Map<MemberDetailsDTO>(member);
                details.skills = skills;
                details.majors = majors;
                return JsonResponse("Search successfully !", 200, details);
            }
            catch (Exception e)
            {
                if (e.Message.ToLower().Contains("not found")) return JsonResponse(e.Message, 400, null);
                return ErrorResponse(e.Message);
            }
        }
        [HttpGet("email")]
        public async Task<IActionResult> getMemberByEmail([FromQuery][EmailAddress][Required] string email)
        {
            try
            {
                Member member = await _memberServce.LoginByEmail(email);
                if (member == null) return JsonResponse("Not found by email", 400, null);
                return JsonResponse("Get successfully !", 200, member);
            } catch (Exception e)
            {
                if (e.Message.ToLower().Contains("not found")) return JsonResponse(e.Message, 400, null);
                return ErrorResponse(e.Message);
            }
        }
        //[HttpGet("{id}/skills/")]
        //public async Task<IActionResult> getSkillsByMemberId(Guid id)
        //{
        //    try
        //    {
        //        List<SkillDTO> skills = await _memberServce.getAllSkillsByMemberId(id);
        //        return JsonResponse("Search successfully !", 200, skills);
        //    }
        //    catch (Exception e)
        //    {
        //        if (e.Message.ToLower().Contains("not found")) return JsonResponse(e.Message, 400, null);
        //        return ErrorResponse(e.Message);
        //    }
        //}
    }
}
