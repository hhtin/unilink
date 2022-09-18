using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using Unilink.Data.Entity;

namespace Unilink.Data.Repository
{
    public interface IMemberSkillRepository : IGenericRepository<MemberSkill>
    {
        public Task<IEnumerable<MemberSkill>> getSkillsByMemberId(Guid memberId);

        public bool deleteMemberSkills(List<MemberSkill> memberSkills);
    }
}
