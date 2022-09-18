using EntityFrameworkPaginateCore;
using Microsoft.EntityFrameworkCore;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Threading.Tasks;
using Unilink.Data.Config;
using Unilink.Data.Dto.Major;
using Unilink.Data.Dto.Pagination;
using Unilink.Data.Entity;

namespace Unilink.Data.Repository.Impl
{
    public class MajorRepository:GenericRepository<Major>,IMajorRepository
    {
        private readonly ApplicationDbContext _DBContext;
        public MajorRepository(ApplicationDbContext context) : base(context)
        {
            this._DBContext = context;
        }

        public async Task<IEnumerable<Major>> SearchAsync(SearchMajorRequestDTO searchDTO)
        {
            var result = from Major in _DBContext.Majors
                         select Major;
           
            if (!String.IsNullOrEmpty(searchDTO.Name))
            {
                result = (IOrderedQueryable<Major>)result.Where(s => s.Name.Contains(searchDTO.Name));
            }
            var skip = (searchDTO.Page - 1) * searchDTO.Limit;
            try
            {
                return await result.Skip(skip).Take(searchDTO.Limit).ToListAsync();
            } catch (Exception e)
            {
                throw new Exception(e.Message);
            }
        }
        public async Task<double> CountSearchAsync(SearchMajorRequestDTO searchDTO)
        {
            var result = from Major in _DBContext.Majors
                         select Major;
           
            if (!String.IsNullOrEmpty(searchDTO.Name))
            {
                result = (IOrderedQueryable<Major>)result.Where(s => s.Name.Contains(searchDTO.Name));
            }
            try
            {
                int count = await result.CountAsync();
                double page = (double)count / searchDTO.Limit;
                return Math.Ceiling(page);
            }
            catch (Exception e)
            {
                throw new Exception(e.Message);
            }
            
        }
        public async Task<Page<Major>> searchPagination(PaginationRequestDTO searchDTO)
        {
            try
            {
                var filters = new Filters<Major>();

                //Filter
                filters.Add(!string.IsNullOrEmpty(searchDTO.searchText), x => x.Name.Contains(searchDTO.searchText));
                //Sort
                var sorts = new Sorts<Major>();
                if (searchDTO.sortType.Equals("dsc"))
                {
                    sorts.Add(searchDTO.sortBy.Equals("Name"), x => x.Name, true);
                    sorts.Add(searchDTO.sortBy.Equals("Id"), x => x.Id, true);
                }
                else
                {
                    sorts.Add(searchDTO.sortBy.Equals("Name"), x => x.Name, false);
                    sorts.Add(searchDTO.sortBy.Equals("Id"), x => x.Id, false);
                }

                return await _DBContext.Majors.Select(e => e).PaginateAsync(searchDTO.curPage, searchDTO.pageSize, sorts, filters);
            }
            catch (Exception e)
            {
                throw new Exception(e.Message);
            }
        }

        public async Task<IEnumerable<Major>> GetListAsyncByStatus(bool isActive)
        {
            try
            {
                return await base.GetEntity().Where(x => x.Status == isActive).ToListAsync();
            }
            catch (Exception e)
            {
                throw new Exception(e.Message);
            }
        }
        public async Task<IEnumerable<Major>> GetAllCustomAsync()
        {
            try
            {
                return await base.GetEntity().Include(s => s.Skills).ToListAsync();
            }
            catch (Exception e)
            {
                throw new Exception(e.Message);
            }
        }
        public async Task<Major> GetCustomAsync(Guid id)
        {
            try
            {
                return await base.GetEntity().Include(s => s.Skills).Where(m=>m.Id.Equals(id)).FirstAsync();
            }
            catch (Exception e)
            {
                throw new Exception(e.Message);
            }
        }
    }
}
