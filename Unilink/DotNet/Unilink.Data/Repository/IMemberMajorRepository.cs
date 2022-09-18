using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using Unilink.Data.Entity;
using Unilink.Data.Repository.Impl;

namespace Unilink.Data.Repository
{
    public interface IMemberMajorRepository : IGenericRepository<MemberMajor>
    {
        public Task<IEnumerable<MemberMajor>> getMajorByMemberId(Guid memberId);

        public bool deleteMemberMajors(List<MemberMajor> memberMajors);
    }
}
