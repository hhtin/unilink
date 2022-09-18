using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using Unilink.Business.Utils;
using Unilink.Data.Dto.PartyInvitation;
using Unilink.Data.Entity;
using Unilink.Data.Repository;
using Unilink.Data.Repository.Impl;

namespace Unilink.Business.Service.Impl
{
    public class PartyInvitationService : IPartyInvitationService
    {
        private readonly IPartyInvitationRepository _invitation;
        public PartyInvitationService(IPartyInvitationRepository invitation)
        {
            this._invitation = invitation;
        }
        public async Task<int> DeleteAsync(PartyInvitationDTO dto)
        {
            try
            {
                PartyInvitation entry = MapperConfig.GetMapper().Map<PartyInvitation>(dto);
                entry.Status = 2;
                int count = await _invitation.Update(entry);
                return count;
            }
            catch (Exception e)
            {
                throw new Exception(e.Message);
            }
        }


        public async Task<IEnumerable<PartyInvitation>> getAll()
        {
            try
            {
                return await _invitation.GetAllAsync();
            }
            catch (Exception e)
            {
                throw new Exception(e.Message);
            }
        }

        public async Task<IEnumerable<PartyInvitation>> getAllByRule()
        {
            try
            {
                return await _invitation.GetAllByRule();
            }
            catch (Exception e)
            {
                throw new Exception(e.Message);
            }
        }

        public async Task<int> InsertAsync(PartyInvitationInsertDTO dto)
        {
            try
            {
                PartyInvitation entry = MapperConfig.GetMapper().Map<PartyInvitation>(dto);
                entry.Status = 0;
                entry.CreatedDate = new DateTime();
                int count = await _invitation.InsertAsync(entry);
                return count;
            } catch (Exception e)
            {
                throw new Exception(e.Message);
            }
        }


        public async Task<int> UpdateAsync(PartyInvitationDTO dto)
        {
            try
            {
                PartyInvitation entry = MapperConfig.GetMapper().Map<PartyInvitation>(dto);
                int count = await _invitation.Update(entry);
                return count;
            }
            catch (Exception e)
            {
                throw new Exception(e.Message);
            }
        }

    }
}
