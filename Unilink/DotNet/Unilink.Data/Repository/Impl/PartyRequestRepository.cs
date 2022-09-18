using Microsoft.EntityFrameworkCore;
using System;
using System.Collections;
using System.Collections.Generic;
using System.ComponentModel.DataAnnotations;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using Unilink.Data.Config;
using Unilink.Data.Dto.PartyRequest;
using Unilink.Data.Entity;

namespace Unilink.Data.Repository.Impl
{
    public class PartyRequestRepository : GenericRepository<PartyRequest>, IPartyRequestRepository
    {
        private readonly ApplicationDbContext _DBContext;
        public PartyRequestRepository(ApplicationDbContext context) : base(context)
        {
            this._DBContext = context;
        }

        public async Task<IEnumerable<PartyRequest>> GetAllByRule([Range(0,2)] int type = 0)
        {
            try
            {
                DateTime date = DateTime.Now;
                int year = date.Year;
                int month = date.Month == 1 ? 12 : (date.Month - 1);
                int day = date.Day == 1 ? DateTime.DaysInMonth(year, month) : (date.Day - 1);
                DateTime previousDate = new DateTime(year, month, day, date.Hour, date.Minute, date.Second);
                return await _DBContext.Set<PartyRequest>().Where(e => e.Status == type).Where(e => e.CreatedDate.CompareTo(previousDate) >= 0).ToListAsync();
            }
            catch (Exception e)
            {
                throw new Exception(e.Message);
            }
        }

        public async Task<IEnumerable<PartyRequest>> GetEntriesByRuleAndMemberId(PartyRequestMember dto)
        {
            try
            {
                DateTime date = DateTime.Now;
                int year = date.Year;
                int month = date.Month == 1 ? 12 : (date.Month - 1);
                int day = date.Day == 1 ? DateTime.DaysInMonth(year, month) : (date.Day - 1);
                DateTime previousDate = new DateTime(year, month, day, date.Hour, date.Minute, date.Second);
                return await _DBContext.Set<PartyRequest>().
                    Where(e => e.MemberId == dto.MemberId).
                    Where(e => e.Status == dto.Status).Where(e => e.CreatedDate.CompareTo(previousDate) >= 0).ToListAsync();
            }
            catch (Exception e)
            {
                throw new Exception(e.Message);
            }
        }

        public async Task<List<PartyRequest>> GetEntriesByRuleAndPartyId(PartyRequestParty dto)
        {
            try
            {
                DateTime date = DateTime.Now;
                int year = date.Year;
                int month = date.Month == 1 ? 12 : (date.Month - 1);
                int day = date.Day == 1 ? DateTime.DaysInMonth(year, month) : (date.Day - 1);
                DateTime previousDate = new DateTime(year, month, day, date.Hour, date.Minute, date.Second);
                return await _DBContext.Set<PartyRequest>().
                    Where(e => e.PartyId == dto.PartyId).
                    Where(e => e.Status == dto.Status).Where(e => e.CreatedDate.CompareTo(previousDate) >= 0).ToListAsync();
            }
            catch (Exception e)
            {
                throw new Exception(e.Message);
            }
        }

        public async Task<PartyRequest> GetEntryByRule(PartyRequestDTO dto)
        {
            try
            {
                DateTime date = DateTime.Now;
                int year = date.Year;
                int month = date.Month == 1 ? 12 : (date.Month - 1);
                int day = date.Day == 1 ? DateTime.DaysInMonth(year, month) : (date.Day - 1);
                DateTime previousDate = new DateTime(year, month, day, date.Hour, date.Minute, date.Second);
                List<PartyRequest> list = await _DBContext.Set<PartyRequest>()
                    .Where(e => e.PartyId == dto.PartyId)
                    .Where(e => e.MemberId == dto.MemberId)
                    .Where(e => e.Status == dto.Status)
                    .Where(e => e.CreatedDate.CompareTo(previousDate) >= 0).ToListAsync();
                list?.OrderByDescending(x => x.CreatedDate);
                return list?.FirstOrDefault();
            }
            catch (Exception e)
            {
                throw new Exception(e.Message);
            }
        }

        public async Task UpdateBlock(PartyRequest dto)
        {
            try
            {
                base.GetEntity().Update(dto);
            }
            catch (Exception e)
            {
                if (_DBContext != null)
                {
                    await _DBContext.DisposeAsync();
                }
                throw new Exception(e.Message);
            }
        }
    }
}
