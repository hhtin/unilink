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
    public class PostRepository : GenericRepository<Post>, IPostRepository
    {
        private readonly ApplicationDbContext _DBContext;
        public PostRepository(ApplicationDbContext context) : base(context)
        {
            this._DBContext = context;
        }

        public async Task<Page<Post>> searchPagination(String topic, PaginationRequestDTO searchDTO)
        {
            try
            {
                var filters = new Filters<Post>();

                //Filter
                filters.Add(!string.IsNullOrEmpty(searchDTO.searchText),
                    x => x.Title.Contains(searchDTO.searchText)
                    || x.Content.Contains(searchDTO.searchText));
                filters.Add(true, x => x.Status == 1);
                if (!string.IsNullOrEmpty(topic))
                {
                    filters.Add(true, x => x.TopicId.ToString().Equals(topic));
                }
                //Sort
                var sorts = new Sorts<Post>();
                if (searchDTO.sortType.Equals("dsc"))
                {
                    sorts.Add(searchDTO.sortBy.Equals("Title"), x => x.Title, true);
                    sorts.Add(searchDTO.sortBy.Equals("Id"), x => x.Id, true);
                    sorts.Add(searchDTO.sortBy.Equals("CreateDate"), x => x.CreateDate, true);
                    sorts.Add(searchDTO.sortBy.Equals("TopicId"), x => x.TopicId, true);
                    sorts.Add(searchDTO.sortBy.Equals("CreateBy"), x => x.CreateBy, true);
                }
                else
                {
                    sorts.Add(searchDTO.sortBy.Equals("Title"), x => x.Title, false);
                    sorts.Add(searchDTO.sortBy.Equals("Id"), x => x.Id, false);
                    sorts.Add(searchDTO.sortBy.Equals("CreateDate"), x => x.CreateDate, false);
                    sorts.Add(searchDTO.sortBy.Equals("TopicId"), x => x.TopicId, false);
                    sorts.Add(searchDTO.sortBy.Equals("CreateBy"), x => x.CreateBy, false);
                }

                return await _DBContext.Posts.Select(e => e).PaginateAsync(searchDTO.curPage, searchDTO.pageSize, sorts, filters);
            }
            catch (Exception ex)
            {
                return null;
            }
        }
    }
}
