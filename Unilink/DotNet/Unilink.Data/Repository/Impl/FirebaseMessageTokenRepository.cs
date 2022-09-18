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

    public class FirebaseMessageTokenRepository : GenericRepository<FirebaseMessageToken>, IFirebaseMessageTokenRepository
    {

        private readonly ApplicationDbContext _DBContext;
        public FirebaseMessageTokenRepository(ApplicationDbContext context) : base(context)
        {
            this._DBContext = context;
        }
        public async Task<FirebaseMessageToken> GetByMemberId(Guid memberId)
        {
            try
            {
                List<FirebaseMessageToken> list = await _DBContext.Set<FirebaseMessageToken>().Where(e => e.status).Where(e => e.memberId.Equals(memberId)).ToListAsync();
                return list.FirstOrDefault();
            } catch (Exception e)
            {
                throw new Exception(e.Message);
            }
        }
    }
}
