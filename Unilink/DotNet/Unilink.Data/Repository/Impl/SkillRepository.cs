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
    public class SkillRepository : GenericRepository<Skill>, ISkillRepository
    {
        public SkillRepository(ApplicationDbContext context) : base(context)
        {
        }

        public async Task<IEnumerable<Skill>> GetListAsyncByStatus(bool isActive)
        {
            try
            {
                return await base.GetEntity().Include(s=>s.Majors).Where(x => x.Status == isActive).ToListAsync();
            }
            catch (Exception e)
            {
                throw new Exception(e.Message);
            }
        }

        public async Task<IEnumerable<Skill>> GetAllCustomAsync()
        {
            try
            {
                return await base.GetEntity().Include(s => s.Majors).ToListAsync();
            }
            catch (Exception e)
            {
                throw new Exception(e.Message);
            }
        }

        public async Task<Page<Skill>> searchPagination(PaginationRequestDTO paginationRequestDTO)
        {
            try
            {
                var filters = new Filters<Skill>();

                //Filter
                filters.Add(!string.IsNullOrEmpty(paginationRequestDTO.searchText), x => x.Name.Contains(paginationRequestDTO.searchText));
                //Sort
                var sorts = new Sorts<Skill>();
                if (paginationRequestDTO.sortType.Equals("dsc"))
                {
                    sorts.Add(paginationRequestDTO.sortBy.Equals("Name"), x => x.Name, true);
                    sorts.Add(paginationRequestDTO.sortBy.Equals("Id"), x => x.Id, true);
                }
                else
                {
                    sorts.Add(paginationRequestDTO.sortBy.Equals("Name"), x => x.Name, false);
                    sorts.Add(paginationRequestDTO.sortBy.Equals("Id"), x => x.Id, false);
                }

                return await base.GetDBContext().Skills.Select(e => e).PaginateAsync(paginationRequestDTO.curPage, paginationRequestDTO.pageSize, sorts, filters);
            }
            catch (Exception e)
            {
                throw new Exception(e.Message);
            }
        }
    }
}
