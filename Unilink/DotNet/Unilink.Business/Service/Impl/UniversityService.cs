using EntityFrameworkPaginateCore;
using Microsoft.Data.SqlClient;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using Unilink.Business.Utils;
using Unilink.Data.Dto.Pagination;
using Unilink.Data.Dto.University;
using Unilink.Data.Entity;
using Unilink.Data.Repository;

namespace Unilink.Business.Service.Impl
{
    public class UniversityService : IUniversityService
    {
        private IUniversityRepository _universityRepository;
        public UniversityService(IUniversityRepository universityRepository)
        {
            this._universityRepository = universityRepository;
        }

        public async Task<int> Delete(Guid id)
        {
            try
            {
                University uni = await _universityRepository.GetAsync(id);
                if (uni == null) throw new Exception("Not found University with following Id !");
                uni.Status = false;
                return await  _universityRepository.Update(uni);
            } catch (Exception e)
            {
                throw new Exception(e.Message);
            }
        }

        public async Task<IEnumerable<University>> getAllAsync()
        {
            try
            {
                return await _universityRepository.GetAllAsync();
            }
            catch (Exception e)
            {
                throw new Exception(e.Message);
            }
        }

        public async Task<IEnumerable<University>> getAllAsyncByStatus(bool isActive)
        {
            try
            {
                return await _universityRepository.GetListAsyncByStatus(isActive);
            }
            catch (Exception e)
            {
                throw new Exception(e.Message);
            }
        }

        public async Task<University> GetAsync(Guid id)
        {
            try
            {
                return await _universityRepository.GetAsync(id);
            }
            catch (Exception e)
            {
                throw new Exception(e.Message);
            }
        }

        public async Task<int> HardDelete(Guid id)
        {
            try
            {
                University uni = await _universityRepository.GetAsync(id);
                if (uni == null) throw new Exception("Not found University with following Id !");
                return await _universityRepository.Delete(id);
            }
            catch(Exception e)
            {
                throw new Exception(e.Message);
            }
        }

        public async Task<int> InsertAsync(InsertUniversityDTO insertUniversityDTO)
        {
            try
            {
                University university = MapperConfig.GetMapper().Map<University>(insertUniversityDTO);
                university.Id = Guid.NewGuid();
                university.Status = true;
                return await  _universityRepository.InsertAsync(university);
            }
            catch (Exception e)
            {
                throw new Exception(e.Message);
            }
        }

        public async Task<PaginationResponseDTO<UniversityDTO>> Search(PaginationRequestDTO searchDTO)
        {
            PaginationRequestDTO validatedPagination = new PaginationUtils().validatePaginationParam(searchDTO, "University");
            Page<University> partyPage = await _universityRepository.searchPagination(validatedPagination);
            PaginationResponseDTO<UniversityDTO> pagination = new PaginationResponseDTO<UniversityDTO>();
            if (partyPage != null)
            {
                List<UniversityDTO> dataList = new List<UniversityDTO>();
                partyPage.Results.ToList().ForEach(e => dataList.Add(MapperConfig.GetMapper().Map<UniversityDTO>(e)));
                pagination.Data = dataList;
                pagination.PageIndex = validatedPagination.curPage;
                pagination.Limit = partyPage.PageSize;
                pagination.totalPage = partyPage.PageCount;
                pagination.sortBy = validatedPagination.sortBy;
                pagination.sortType = validatedPagination.sortType;
                pagination.searchText = searchDTO.searchText;
                return pagination;
            }
            return null;
        }

        public async Task<int> Update(UniversityDTO universityDTO)
        {
            try
            {
                University uni = await _universityRepository.GetAsync(universityDTO.Id);
                if (uni == null) throw new Exception("Not found University with following Id !");
                University university = MapperConfig.GetMapper().Map<University>(universityDTO);
                return await  _universityRepository.Update(university);
            }
            catch (Exception e)
            {
                throw new Exception(e.Message);
            }
        }
    }
}
