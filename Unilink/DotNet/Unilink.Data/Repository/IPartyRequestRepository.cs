using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using Unilink.Data.Dto.PartyRequest;
using Unilink.Data.Entity;

namespace Unilink.Data.Repository
{
    public interface IPartyRequestRepository : IGenericRepository<PartyRequest>
    {
        public Task<IEnumerable<PartyRequest>> GetAllByRule(int type);
        public Task<PartyRequest> GetEntryByRule(PartyRequestDTO dto);
        public Task<IEnumerable<PartyRequest>> GetEntriesByRuleAndMemberId(PartyRequestMember dto);
        public Task<List<PartyRequest>> GetEntriesByRuleAndPartyId(PartyRequestParty dto);
        public Task UpdateBlock(PartyRequest dto);
    }
}
