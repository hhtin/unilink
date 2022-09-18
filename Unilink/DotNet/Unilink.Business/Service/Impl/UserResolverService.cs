
using Microsoft.AspNetCore.Http;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Threading.Tasks;

namespace Unilink.Business.Service.Impl
{
    public class UserResolverService : IUserResolverService
    {
        private readonly IHttpContextAccessor _context;
        public UserResolverService(IHttpContextAccessor context)
        {
            _context = context;
        }

        public Guid GetMemberId()
        {
            var account = _context.HttpContext.Items["User"];
            if (account != null)
            {
                string idString = account?.GetType().GetProperty("id")?.GetValue(account, null).ToString();
                return Guid.Parse(idString);
            }
            return Guid.Empty;
        }
    }
}
