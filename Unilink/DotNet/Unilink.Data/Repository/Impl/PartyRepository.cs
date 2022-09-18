using EntityFrameworkPaginateCore;
using Microsoft.EntityFrameworkCore;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using Unilink.Data.Config;
using Unilink.Data.Dto.Pagination;
using Unilink.Data.Entity;

namespace Unilink.Data.Repository.Impl
{
    public class PartyRepository : GenericRepository<Party>, IPartyRepository
    {
        private readonly ApplicationDbContext _DBContext;
        public PartyRepository(ApplicationDbContext context) : base(context)
        {
            this._DBContext = context;
        }

        public async Task<Page<Party>> searchPagination(PaginationRequestDTO searchDTO)
        {
            try
            {
                var filters = new Filters<Party>();

                //Filter
                filters.Add(!string.IsNullOrEmpty(searchDTO.searchText), x => x.Name.Contains(searchDTO.searchText));
                filters.Add(true, x => x.Status == true);

                //Sort
                var sorts = new Sorts<Party>();
                if (searchDTO.sortType.Equals("dsc"))
                {
                    sorts.Add(searchDTO.sortBy.Equals("Name"), x => x.Name, true);
                    sorts.Add(searchDTO.sortBy.Equals("Id"), x => x.Id, true);
                    sorts.Add(searchDTO.sortBy.Equals("Maximum"), x => x.Maximum, true);
                    sorts.Add(searchDTO.sortBy.Equals("CreateDate"), x => x.CreateDate, true);
                    sorts.Add(searchDTO.sortBy.Equals("MajorId"), x => x.MajorId, true);
                }
                else
                {
                    sorts.Add(searchDTO.sortBy.Equals("Name"), x => x.Name, false);
                    sorts.Add(searchDTO.sortBy.Equals("Id"), x => x.Id, false);
                    sorts.Add(searchDTO.sortBy.Equals("Maximum"), x => x.Maximum, false);
                    sorts.Add(searchDTO.sortBy.Equals("CreateDate"), x => x.CreateDate, false);
                    sorts.Add(searchDTO.sortBy.Equals("MajorId"), x => x.MajorId, false);
                }

                return await _DBContext.Parties.Include(s => s.Skills).Select(e => e).PaginateAsync(searchDTO.curPage, searchDTO.pageSize, sorts, filters);
            }
            catch (Exception ex)
            {
                return null;
            }
        }
    }
}

