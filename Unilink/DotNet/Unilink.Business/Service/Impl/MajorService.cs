using EntityFrameworkPaginateCore;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using Unilink.Business.Utils;
using Unilink.Data.Dto;
using Unilink.Data.Dto.Major;
using Unilink.Data.Dto.Pagination;
using Unilink.Data.Entity;
using Unilink.Data.Repository;

namespace Unilink.Business.Service.Impl
{
    public class MajorService : IMajorService
    {
        private IMajorRepository _majorRepository;

        public MajorService(IMajorRepository _majorRepository)
        {
            this._majorRepository = _majorRepository;
        }

        public async Task<int> Delete(Guid id)
        {
            try
            {
                Major major = await _majorRepository.GetAsync(id);
                if (major == null) throw new Exception("Not found major with following id !");
                major.Status = false;
                return await _majorRepository.Update(major);
            } catch (Exception e)
            {
                throw new Exception(e.Message);
            }
        }

        public async Task<SearchMajorResponseDTO> Search(SearchMajorRequestDTO searchDTO)
        {
            try
            {
                IEnumerable<Major> majors = await _majorRepository.SearchAsync(searchDTO);
                double count = await _majorRepository.CountSearchAsync(searchDTO);

                SearchMajorResponseDTO searchMajorResponseDTO = new SearchMajorResponseDTO();
                searchMajorResponseDTO.TotalPage = count;

                List<MajorDTO> majorDTOs = new List<MajorDTO>();
                foreach (Major major in majors)
                {
                    MajorDTO majorDTO = MapperConfig.GetMapper().Map<MajorDTO>(major);
                    majorDTOs.Add(majorDTO);
                }
                searchMajorResponseDTO.Majors = majorDTOs;
                return searchMajorResponseDTO;
            }
            catch (Exception e)
            {
                throw new Exception(e.Message);
            }
        }

        public async Task<IEnumerable<Major>> getAllAsync()
        {
            try
            {
                return await _majorRepository.GetAllCustomAsync();
            }
            catch (Exception e)
            {
                throw new Exception(e.Message);
            }
        }

        public async Task<Major> GetAsync(Guid id)
        {
            try
            {
                return await _majorRepository.GetCustomAsync(id);
            }
            catch (Exception e)
            {
                throw new Exception(e.Message);
            }
        }

        public async Task<int> InsertAsync(InsertMajorDTO insertMajorDTO)
        {
            try
            {
                Major major = MapperConfig.GetMapper().Map<Major>(insertMajorDTO);
                major.Id = Guid.NewGuid();
                major.Status = true;
                return await _majorRepository.InsertAsync(major);
            }
            catch (Exception e)
            {
                throw new Exception(e.Message);
            }
        }

        public async Task<int> Update(MajorDTO majorDTO)
        {
            try
            {
                Major major = await _majorRepository.GetAsync(majorDTO.Id);
                if (major == null) throw new Exception("Not found major with following id !");
                major = MapperConfig.GetMapper().Map<Major>(majorDTO);
                return await _majorRepository.Update(major);
            }
            catch (Exception e)
            {
                throw new Exception(e.Message);
            }
        }
        public async Task<PaginationResponseDTO<MajorDTO>> Search(PaginationRequestDTO searchDTO)
        {
            PaginationRequestDTO validatedPagination = new PaginationUtils().validatePaginationParam(searchDTO, "Major");
            Page<Major> partyPage = await _majorRepository.searchPagination(validatedPagination);
            PaginationResponseDTO<MajorDTO> pagination = new PaginationResponseDTO<MajorDTO>();
            if (partyPage != null)
            {
                List<MajorDTO> dataList = new List<MajorDTO>();
                partyPage.Results.ToList().ForEach(e => dataList.Add(MapperConfig.GetMapper().Map<MajorDTO>(e)));
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

        public async Task<IEnumerable<Major>> getAllAsyncByStatus(bool isActive)
        {
            try
            {
                return await _majorRepository.GetListAsyncByStatus(isActive);
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
                Major major = await _majorRepository.GetAsync(id);
                if (major == null) throw new Exception("Not found major with following id !");
                return await _majorRepository.Delete(id);
            }
            catch (Exception e)
            {
                throw new Exception(e.Message);
            }
        }
    }
}
