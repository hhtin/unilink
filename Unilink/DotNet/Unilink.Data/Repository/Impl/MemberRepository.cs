using EntityFrameworkPaginateCore;
using Microsoft.EntityFrameworkCore;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using Unilink.Data.Config;
using Unilink.Data.Dto;
using Unilink.Data.Dto.Member;
using Unilink.Data.Dto.Pagination;
using Unilink.Data.Entity;

namespace Unilink.Data.Repository.Impl
{
    public class MemberRepository : GenericRepository<Member>,IMemberRepository
    {
        private readonly ApplicationDbContext _DBContext;
        public MemberRepository(ApplicationDbContext context) : base(context)
        {
            this._DBContext = context;
        }

        public async Task<IEnumerable<Member>> SearchAsync(SearchMemberRequestDTO searchDTO)
        {
            var result= from Member in _DBContext.Members
                        select Member;
           
            if (!String.IsNullOrEmpty(searchDTO.Email))
            {
                result = (IOrderedQueryable<Member>)result.Where(s => s.Email.Contains(searchDTO.Email));
            }
            if (!String.IsNullOrEmpty(searchDTO.FirstName))
            {
                result = (IOrderedQueryable<Member>)result.Where(s => s.FirstName.Contains(searchDTO.FirstName));
                
            }
            if (!String.IsNullOrEmpty(searchDTO.LastName))
            {
                result = (IOrderedQueryable<Member>)result.Where(s => s.LastName.Contains(searchDTO.LastName));
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
        public async Task<double> CountSearchAsync(SearchMemberRequestDTO searchDTO)
        {
            var result = from Member in _DBContext.Members
                         select Member;
          
            if (!String.IsNullOrEmpty(searchDTO.Email))
            {
                result = (IOrderedQueryable<Member>)result.Where(s => s.Email.Contains(searchDTO.Email));
            }
            if (!String.IsNullOrEmpty(searchDTO.FirstName))
            {
                result = (IOrderedQueryable<Member>)result.Where(s => s.FirstName.Contains(searchDTO.FirstName));

            }
            if (!String.IsNullOrEmpty(searchDTO.LastName))
            {
                result = (IOrderedQueryable<Member>)result.Where(s => s.LastName.Contains(searchDTO.LastName));
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

        public async Task<Member> FindMemberByEmail(string email) {
            try
            {
                var members = await _DBContext.Members.Include(m => m.Role).Where(m => m.Email.ToLower().Equals(email.ToLower())).ToListAsync();
                return members.FirstOrDefault();
            } catch (Exception e)
            {
                throw new Exception(e.Message);
            }
        }

        public async Task<Page<Member>> searchPagination(PaginationRequestDTO searchDTO)
        {
            try
            {
                var filters = new Filters<Member>();

                //Filter
                filters.Add(!string.IsNullOrEmpty(searchDTO.searchText),
                    x => x.FirstName.Contains(searchDTO.searchText) 
                    || x.LastName.Contains(searchDTO.searchText)
                    || x.Email.Contains(searchDTO.searchText)
                    || x.Phone.Contains(searchDTO.searchText));
                filters.Add(true, x => x.Status == true);

                //Sort
                var sorts = new Sorts<Member>();
                if (searchDTO.sortType.Equals("dsc"))
                {
                    sorts.Add(searchDTO.sortBy.Equals("Id"), x => x.Id, true);
                    sorts.Add(searchDTO.sortBy.Equals("FirstName"), x => x.FirstName, true);
                    sorts.Add(searchDTO.sortBy.Equals("LastName"), x => x.LastName, true);
                    sorts.Add(searchDTO.sortBy.Equals("Email"), x => x.Email, true);
                    sorts.Add(searchDTO.sortBy.Equals("Phone"), x => x.Phone, true);
                    sorts.Add(searchDTO.sortBy.Equals("Address"), x => x.Address, true);
                    sorts.Add(searchDTO.sortBy.Equals("RoleId"), x => x.RoleId, true);
                    sorts.Add(searchDTO.sortBy.Equals("UniversityId"), x => x.UniversityId, true);
                }
                else
                {
                    sorts.Add(searchDTO.sortBy.Equals("Id"), x => x.Id, false);
                    sorts.Add(searchDTO.sortBy.Equals("FirstName"), x => x.FirstName, false);
                    sorts.Add(searchDTO.sortBy.Equals("LastName"), x => x.LastName, false);
                    sorts.Add(searchDTO.sortBy.Equals("Email"), x => x.Email, false);
                    sorts.Add(searchDTO.sortBy.Equals("Phone"), x => x.Phone, false);
                    sorts.Add(searchDTO.sortBy.Equals("Address"), x => x.Address, false);
                    sorts.Add(searchDTO.sortBy.Equals("RoleId"), x => x.RoleId, false);
                    sorts.Add(searchDTO.sortBy.Equals("UniversityId"), x => x.UniversityId, false);
                }

                return await _DBContext.Members.Select(e => e).PaginateAsync(searchDTO.curPage, searchDTO.pageSize, sorts, filters);
            }
            catch (Exception ex)
            {
                return null;
            }
        }

    }
}
