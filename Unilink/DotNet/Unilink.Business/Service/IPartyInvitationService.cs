using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using Unilink.Data.Dto.PartyInvitation;
using Unilink.Data.Entity;

namespace Unilink.Business.Service
{
    public interface IPartyInvitationService
    {
        public Task<IEnumerable<PartyInvitation>> getAll();
        public Task<IEnumerable<PartyInvitation>> getAllByRule();
        public Task<int> InsertAsync(PartyInvitationInsertDTO dto);
        public Task<int> UpdateAsync(PartyInvitationDTO dto);
        public Task<int> DeleteAsync(PartyInvitationDTO dto);

    }
}
