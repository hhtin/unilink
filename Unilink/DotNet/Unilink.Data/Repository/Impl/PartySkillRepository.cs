using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using Unilink.Data.Config;
using Unilink.Data.Entity;

namespace Unilink.Data.Repository.Impl
{
    public class PartySkillRepository : GenericRepository<PartySkill>, IPartySkillRepository
    {
        private readonly ApplicationDbContext _DBContext;
        public PartySkillRepository(ApplicationDbContext context) : base(context)
        {
            this._DBContext = context;
        }
    }
}
