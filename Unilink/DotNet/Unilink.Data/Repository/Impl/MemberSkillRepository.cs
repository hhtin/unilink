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
    public class MemberSkillRepository : GenericRepository<MemberSkill>, IMemberSkillRepository
    {
        private readonly ApplicationDbContext _DBContext;

        public MemberSkillRepository(ApplicationDbContext context) : base(context)
        {
            this._DBContext = context;
        }

        public bool deleteMemberSkills(List<MemberSkill> memberSkills)
        {
            try
            {
                _DBContext.MemberSkills.RemoveRange(memberSkills.ToArray());
                _DBContext.SaveChanges();
                return true;
            }
            catch (Exception e)
            {
                throw new Exception(e.Message);
            }
        }

        public async Task<IEnumerable<MemberSkill>> getSkillsByMemberId(Guid memberId)
        {
            try
            {
                return await base.GetEntity()
                    .Include(p => p.Skill).Where(p => p.MemberId == memberId).Where(p => p.Skill.Status == true).ToListAsync();
            }
            catch (Exception e)
            {
                throw new Exception(e.Message);
            }
        }
    }
}
