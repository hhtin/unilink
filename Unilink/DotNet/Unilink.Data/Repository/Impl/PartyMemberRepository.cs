using Microsoft.EntityFrameworkCore;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using Unilink.Data.Config;
using Unilink.Data.Entity;

namespace Unilink.Data.Repository.Impl
{

    public class PartyMemberRepository : GenericRepository<PartyMember>, IPartyMemberRepository
    {
        public PartyMemberRepository(ApplicationDbContext context) : base(context)
        {
        }

        public async Task AddBlock(PartyMember dto)
        {
            try
            {
                await base.GetEntity().AddAsync(dto);
            }
            catch (Exception e)
            {
                if (base.GetDBContext() != null)
                {
                    await base.GetDBContext().DisposeAsync();
                }
                throw new Exception(e.Message);
            }
        }

        public async Task<IEnumerable<PartyMember>> getMemberByPartyId(Guid partyId)
        {
            try
            {
                return await base.GetEntity().Include(p => p.Member).Where(p => p.PartyId == partyId).Where(p => p.JoinDate == p.OutDate).ToListAsync();
            } catch (Exception e)
            {
                throw new Exception(e.Message);
            }
        }

        public async Task<IEnumerable<PartyMember>> getPartyByMemberId(Guid memberId)
        {
            try
            {
                return await base.GetEntity().Include(p => p.Party).Where(p => p.MemberId == memberId).Where(p => p.JoinDate == p.OutDate).ToListAsync();
            }
            catch (Exception e)
            {
                throw new Exception(e.Message);
            }
        }
    }
}
