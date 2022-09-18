using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using Unilink.Data.Dto;
using Unilink.Data.Dto.Major;
using Unilink.Data.Dto.Member;
using Unilink.Data.Dto.Pagination;
using Unilink.Data.Dto.PartyRequest;
using Unilink.Data.Dto.Skill;
using Unilink.Data.Entity;

namespace Unilink.Business.Service
{
    public interface IMemberService
    {
        public Task<Member> InsertAsync(InsertMemberDTO insertMemberDTO, string host);

        public Task<Member> LoginByEmail(string email);

        public Task<SearchMemberResponseDTO> Search(SearchMemberRequestDTO searchDTO);

        public Task<Member> GetAsync(Guid id);

        public Task<MemberDTO> Update(UpdateMemberDTO dto, string host);

        public Task<bool> Delete(Guid id);

        public Task<PaginationResponseDTO<MemberDTO>> Search(PaginationRequestDTO searchDTO);
        public Task requestParty(PartyRequestInsertDTO requestDTO);
        public Task rejectParty(PartyRequestDTO requestDTO);
        public Task<IEnumerable<PartyRequestDTO>> getAllRequestByRule(int type);
        public Task<IEnumerable<PartyRequestDTO>> getAllRequestByRuleAndMemberId(PartyRequestMember dto);
        public Task<List<MemberDTO>> getMemberByPartyId(Guid partyId);
        public Task<MemberDTO> getCurrentMember();
        public Task<List<MajorDTO>> getAllMajorByMemberId(Guid memberId);
        public Task<List<SkillDTO>> getAllSkillsByMemberId(Guid memberId);
    }
}
