using EntityFrameworkPaginateCore;
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
    public class TopicRepository : GenericRepository<Topic>, ITopicRepository
    {
        private readonly ApplicationDbContext _DBContext;
        public TopicRepository(ApplicationDbContext context) : base(context)
        {
            this._DBContext = context;
        }

        public async Task<Page<Topic>> searchPagination(PaginationRequestDTO searchDTO)
        {
            try
            {
                var filters = new Filters<Topic>();
                if (!string.IsNullOrEmpty(searchDTO.searchText))
                {
                    Guid guidOutput;
                    bool isValid = Guid.TryParse(searchDTO.searchText, out guidOutput);
                    filters.Add(isValid, x => x.PartyId.ToString().Equals(searchDTO.searchText));
                }
                //Filter
                
                filters.Add(true, x => x.Status == true);

                //Sort
                var sorts = new Sorts<Topic>();
                if (searchDTO.sortType.Equals("dsc"))
                {
                    sorts.Add(searchDTO.sortBy.Equals("Title"), x => x.Title, true);
                    sorts.Add(searchDTO.sortBy.Equals("Id"), x => x.Id, true);
                    sorts.Add(searchDTO.sortBy.Equals("CreateDate"), x => x.CreateDate, true);
                    sorts.Add(searchDTO.sortBy.Equals("PartyId"), x => x.PartyId, true);
                }
                else
                {
                    sorts.Add(searchDTO.sortBy.Equals("Title"), x => x.Title, false);
                    sorts.Add(searchDTO.sortBy.Equals("Id"), x => x.Id, false);
                    sorts.Add(searchDTO.sortBy.Equals("CreateDate"), x => x.CreateDate, false);
                    sorts.Add(searchDTO.sortBy.Equals("PartyId"), x => x.PartyId, false);
                }

                return await _DBContext.Topics.Select(e => e).PaginateAsync(searchDTO.curPage, searchDTO.pageSize, sorts, filters);
            }
            catch (Exception ex)
            {
                return null;
            }
        }
    }
}
