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
    public class UniversityRepository : GenericRepository<University>,IUniversityRepository
    {
        public UniversityRepository(ApplicationDbContext context): base(context)
        {

        }

        public async Task<int> disabledEntry(Guid Id)
        {
            try
            {
                University uni = new University() { Id = Id, Status = false };
                base.GetEntity().Attach(uni);
                base.GetDBContext().Entry(uni).Property(x => x.Status).IsModified = true;
                return await base.GetDBContext().SaveChangesAsync();
            } catch (Exception e)
            {
                throw new Exception(e.Message);
            }
        }

        public async Task<IEnumerable<University>> GetListAsyncByStatus(bool isActive)
        {
            try
            {
                return await base.GetEntity().Where(x => x.Status == isActive).ToListAsync();
            } catch (Exception e)
            {
                throw new Exception(e.Message);
            }
        }

        public async Task<Page<University>> searchPagination(PaginationRequestDTO paginationRequestDTO)
        {
            try
            {
                var filters = new Filters<University>();

                //Filter
                filters.Add(!string.IsNullOrEmpty(paginationRequestDTO.searchText), x => x.Name.Contains(paginationRequestDTO.searchText));
                //Sort
                var sorts = new Sorts<University>();
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

                return await base.GetDBContext().Universities.Select(e => e).PaginateAsync(paginationRequestDTO.curPage, paginationRequestDTO.pageSize, sorts, filters);
            }
            catch (Exception e)
            {
                throw new Exception(e.Message);
            }
        }
    }
}
