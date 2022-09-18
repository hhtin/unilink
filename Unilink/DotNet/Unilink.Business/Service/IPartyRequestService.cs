using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using Unilink.Data.Dto.PartyRequest;
using Unilink.Data.Entity;

namespace Unilink.Business.Service
{
    public interface IPartyRequestService 
    {
        public Task<IEnumerable<PartyRequest>> getAll();
        public Task<IEnumerable<PartyRequest>> getAllByRule();
        public Task<int> InsertAsync(PartyRequestInsertDTO dto);
        public Task<int> UpdateAsync(PartyRequestDTO dto);
        public Task<int> DeleteAsync(PartyRequestDTO dto);
    }
}
