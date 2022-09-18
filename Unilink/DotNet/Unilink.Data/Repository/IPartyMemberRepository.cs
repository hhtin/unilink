using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using Unilink.Data.Entity;

namespace Unilink.Data.Repository
{
    public interface IPartyMemberRepository : IGenericRepository<PartyMember>
    {
        public Task AddBlock(PartyMember dto);
        public Task<IEnumerable<PartyMember>> getMemberByPartyId(Guid partyId);
        public Task<IEnumerable<PartyMember>> getPartyByMemberId(Guid memberId);
    }
}
