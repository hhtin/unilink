using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using Unilink.Business.Utils;
using Unilink.Data.Dto.PartyRequest;
using Unilink.Data.Entity;
using Unilink.Data.Repository;

namespace Unilink.Business.Service.Impl
{
    public class PartyRequestService : IPartyRequestService
    {
        private readonly IPartyRequestRepository _request;
        public PartyRequestService(IPartyRequestRepository request)
        {
            this._request = request;
        }
        public async Task<int> DeleteAsync(PartyRequestDTO dto)
        {
            try
            {
                PartyRequest entry = MapperConfig.GetMapper().Map<PartyRequest>(dto);
                entry.Status = 2;
                int count = await _request.Update(entry);
                return count;
            }
            catch (Exception e)
            {
                throw new Exception(e.Message);
            }
        }

        public async Task<IEnumerable<PartyRequest>> getAll()
        {
            try
            {
                return await _request.GetAllAsync();
            }
            catch (Exception e)
            {
                throw new Exception(e.Message);
            }
        }

        public async Task<IEnumerable<PartyRequest>> getAllByRule()
        {
            try
            {
                return await _request.GetAllByRule(0);
            }
            catch (Exception e)
            {
                throw new Exception(e.Message);
            }
        }

        public async Task<int> InsertAsync(PartyRequestInsertDTO dto)
        {
            try
            {
                PartyRequest entry = MapperConfig.GetMapper().Map<PartyRequest>(dto);
                entry.Status = 0;
                entry.CreatedDate = new DateTime();
                int count = await _request.InsertAsync(entry);
                return count;
            }
            catch (Exception e)
            {
                throw new Exception(e.Message);
            }
        }

        public async Task<int> UpdateAsync(PartyRequestDTO dto)
        {
            try
            {
                PartyRequest entry = MapperConfig.GetMapper().Map<PartyRequest>(dto);
                int count = await _request.Update(entry);
                return count;
            }
            catch (Exception e)
            {
                throw new Exception(e.Message);
            }
        }
    }
}
