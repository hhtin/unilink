using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using Unilink.Data.Dto.Pagination;
using Unilink.Data.Dto.Party;
using Unilink.Data.Dto.PartyRequest;
using Unilink.Data.Entity;

namespace Unilink.Business.Service
{
    public interface IPartyService
    {
        //public Task<IEnumerable<Party>> getAllAsync();
        public Task<PartyDTO> InsertAsync(InsertPartyDTO dto, string host);
        public Task<PartyDTO> UpdateAsync(UpdatePartyDTO dto, string host);
        public Task<bool> DeleteAsync(Guid id);
        public Task<PartyDTO> GetAsync(Guid id);
        public Task<PaginationResponseDTO<PartyDTO>> Search(PaginationRequestDTO searchDTO);
        public Task<List<PartyRequestDTO>> getAllRequestByRuleAndPartyId(PartyRequestParty dto);
        public Task rejectMember(PartyRequestDTO requestDTO);
        public Task acceptMember(PartyRequestDTO requestDTO);
        public Task<List<PartyDTO>> getPartyByMemberId(Guid memberId);
    }
}
