using EntityFrameworkPaginateCore;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using Unilink.Business.Utils;
using Unilink.Data.Config;
using Unilink.Data.Dto.Pagination;
using Unilink.Data.Dto.Skill;
using Unilink.Data.Entity;
using Unilink.Data.Repository;

namespace Unilink.Business.Service.Impl
{
    public class SkillService : ISkillService
    {
        private ISkillRepository _skillRepository;
        private IMajorSkillRepository _majorSkillRepository;
        private readonly ApplicationDbContext _applicationDbContext;
        public SkillService(ISkillRepository skillRepository,IMajorSkillRepository majorSkillRepository, ApplicationDbContext applicationDbContext)
        {
            this._skillRepository = skillRepository;
            this._applicationDbContext = applicationDbContext;
            this._majorSkillRepository = majorSkillRepository;
        }

        public async Task<int> Delete(Guid id)
        {
            try
            {
                Skill skill = await _skillRepository.GetAsync(id);
                if (skill == null) throw new Exception("Not found skill with following Id !");
                skill.Status = false;
                return await _skillRepository.Update(skill);
            } catch (Exception e)
            {
                throw new Exception(e.Message);
            }
        }

        public async Task<IEnumerable<Skill>> getAllAsync()
        {
            try
            {
                return await _skillRepository.GetAllCustomAsync();
            }
            catch (Exception e)
            {
                throw new Exception(e.Message);
            }
        }

        public async Task<IEnumerable<Skill>> getAllAsyncByStatus(bool isActive)
        {
            try
            {
                return await _skillRepository.GetListAsyncByStatus(isActive);
            }
            catch (Exception e)
            {
                throw new Exception(e.Message);
            }
        }

        public async Task<Skill> GetAsync(Guid id)
        {
            try
            {
                return await _skillRepository.GetAsync(id);
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
                Skill skill = await _skillRepository.GetAsync(id);
                if (skill == null) throw new Exception("Not found skill with following Id !");
                return await _skillRepository.Delete(id);
            }
            catch (Exception e)
            {
                throw new Exception(e.Message);
            }
        }

        public async Task<int> InsertAsync(InsertSkillDTO insertSkillDTO)
        {
            try
            {
                var transaction = _applicationDbContext.Database.BeginTransaction();
                Skill skill = MapperConfig.GetMapper().Map<Skill>(insertSkillDTO);
                skill.Id = Guid.NewGuid();
                skill.Status = true;
                var result= await  _skillRepository.InsertAsync(skill);
                MajorSkill majorSkill = new MajorSkill() {
                    MajorId = insertSkillDTO.MajorId,
                    SkillId = skill.Id
                };
                await _majorSkillRepository.InsertAsync(majorSkill);
                await _applicationDbContext.SaveChangesAsync();
                await transaction.CommitAsync();
                return result;
            }
            catch (Exception e)
            {
                throw new Exception(e.Message);
            }
        }

        public async Task<PaginationResponseDTO<SkillDTO>> Search(PaginationRequestDTO searchDTO)
        {
            PaginationRequestDTO validatedPagination = new PaginationUtils().validatePaginationParam(searchDTO, "Skill");
            Page<Skill> partyPage = await _skillRepository.searchPagination(validatedPagination);
            PaginationResponseDTO<SkillDTO> pagination = new PaginationResponseDTO<SkillDTO>();
            if (partyPage != null)
            {
                List<SkillDTO> dataList = new List<SkillDTO>();
                partyPage.Results.ToList().ForEach(e => dataList.Add(MapperConfig.GetMapper().Map<SkillDTO>(e)));
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

        public async Task<int> Update(SkillDTO skillDTO)
        {
            try
            {
                Skill skill = await _skillRepository.GetAsync(skillDTO.Id);
                if (skill == null) throw new Exception("Not found skill with following id !");
                skill = MapperConfig.GetMapper().Map<Skill>(skillDTO);
                return await _skillRepository.Update(skill);
            }
            catch (Exception e)
            {
                throw new Exception(e.Message);
            }
        }
    }
}
