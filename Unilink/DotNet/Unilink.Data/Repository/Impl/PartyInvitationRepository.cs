using Microsoft.EntityFrameworkCore;
using System;
using System.Collections.Generic;
using System.ComponentModel.DataAnnotations;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using Unilink.Data.Config;
using Unilink.Data.Entity;

namespace Unilink.Data.Repository.Impl
{
    public class PartyInvitationRepository : GenericRepository<PartyInvitation>, IPartyInvitationRepository
    {
        private readonly ApplicationDbContext _DBContext;
        public PartyInvitationRepository(ApplicationDbContext context) : base(context)
        {
            this._DBContext = context;
        }

        public async Task<IEnumerable<PartyInvitation>> GetAllByRule([Range(0, 2)] int type = 0)
        {
            try
            {
                DateTime date = DateTime.Now;
                int year = date.Year;
                int month = date.Month == 1 ? 12 : (date.Month - 1);
                int day = date.Day == 1 ? DateTime.DaysInMonth(year, month) : (date.Day - 1);
                DateTime previousDate = new DateTime(year, month, day, date.Hour, date.Minute, date.Second);
                return await _DBContext.Set<PartyInvitation>().Where(e => e.Status == type).Where(e => e.CreatedDate.CompareTo(previousDate) >= 0).ToListAsync();
            }
            catch (Exception e)
            {
                throw new Exception(e.Message);
            }
        }

        public Task<IEnumerable<PartyInvitation>> GetAllByRule()
        {
            throw new NotImplementedException();
        }
    }
}
