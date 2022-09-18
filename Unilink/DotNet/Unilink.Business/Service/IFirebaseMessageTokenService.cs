using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using Unilink.Data.Dto.FirebaseMessageToken;
using Unilink.Data.Entity;

namespace Unilink.Business.Service
{
    public interface IFirebaseMessageTokenService
    {
        public Task<FirebaseMessageTokenDTO> GetByMemberId(Guid memberId);
        public Task<int> UpdateToken(FirebaseMessageTokenDTO dto);
        public Task<int> CreateToken(InsertMessageToken insertDTO);
    }
}
