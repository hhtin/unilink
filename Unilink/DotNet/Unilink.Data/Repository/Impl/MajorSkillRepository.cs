using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using Unilink.Data.Config;
using Unilink.Data.Entity;

namespace Unilink.Data.Repository.Impl
{
    public class MajorSkillRepository : GenericRepository<MajorSkill>, IMajorSkillRepository
    {
        private readonly ApplicationDbContext _DBContext;
        public MajorSkillRepository(ApplicationDbContext context) : base(context)
        {
            this._DBContext = context;
        }
    }
}
