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
    public class MemberMajorRepository : GenericRepository<MemberMajor>, IMemberMajorRepository
    {
        private readonly ApplicationDbContext _DBContext;

        public MemberMajorRepository(ApplicationDbContext context) : base(context)
        {
            this._DBContext = context;
        }

        public bool deleteMemberMajors(List<MemberMajor> memberMajors)
        {
            try
            {
                _DBContext.MemberMajors.RemoveRange(memberMajors.ToArray());
                _DBContext.SaveChanges();
                return true;
            }
            catch (Exception e)
            {
                throw new Exception(e.Message);
            }
        }

        public async Task<IEnumerable<MemberMajor>> getMajorByMemberId(Guid memberId)
        {
            try
            {
                return await base.GetEntity()
                    .Include(p => p.Major).Where(p => p.MemberId == memberId).Where(p => p.Major.Status == true).ToListAsync();
            }
            catch (Exception e)
            {
                throw new Exception(e.Message);
            }
        }
    }
}
