using EntityFrameworkPaginateCore;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using Unilink.Business.Utils;
using Unilink.Data.Config;
using Unilink.Data.Dto;
using Unilink.Data.Dto.Pagination;
using Unilink.Data.Dto.Party;
using Unilink.Data.Dto.PartyMember;
using Unilink.Data.Dto.PartyRequest;
using Unilink.Data.Entity;
using Unilink.Data.Repository;

namespace Unilink.Business.Service.Impl
{
    public class PartyService : IPartyService
    {

        private IPartyRepository _partyRepository;
        private readonly ApplicationDbContext _applicationDbContext;
        private IMajorRepository _majorRepository;
        private IPartyRequestRepository _partyRequestRepository;
        private IMemberRepository _memberRepository;
        private IPartyMemberRepository _partyMemberRepository;
        private IUserResolverService _userResolverService;
        public PartyService(IPartyRepository partyRepository, ApplicationDbContext applicationDbContext,
            IMajorRepository majorRepository, IPartyRequestRepository partyRequestRepository,
            IMemberRepository memberRepository, IPartyMemberRepository partyMemberRepository,
            IUserResolverService userResolverService
            )
        {
            this._partyRepository = partyRepository;
            this._applicationDbContext = applicationDbContext;
            this._majorRepository = majorRepository;
            this._partyRequestRepository = partyRequestRepository;
            this._memberRepository = memberRepository;
            this._partyMemberRepository = partyMemberRepository;
            this._userResolverService = userResolverService;
        }

        public async Task<PartyDTO> InsertAsync(InsertPartyDTO dto, string host)
        {
            Major major = await _majorRepository.GetAsync(dto.MajorId);
            if(major == null)
            {
                return null;
            }

            // Getting Image
            var image = dto.Image;

            // Saving Image on Server
            FileReturnDTO fileReturn = new FileReturnDTO();
            string path = "";
            Guid id = Guid.NewGuid();
            if (image != null && image.Length > 0)
            {
                string childPath = "\\group\\image\\" + id.ToString() + "";
                fileReturn = FileUtil.GetStreamToSaveFile(childPath, image.FileName.ToString());
                image.CopyTo(fileReturn.stream);
                path = FileUtil.SetPathForFile(host, "v1", "group", id.ToString(), "image", image.FileName.ToString());
            }

            Party party = MapperConfig.GetMapper().Map<Party>(dto);
            party.Id = id;
            party.Image = path;
            party.Status = true;
            party.CreateDate = DateTime.Now;
            try
            {

                var transaction = _applicationDbContext.Database.BeginTransaction();
                // insert group
                _applicationDbContext.Parties.Add(party);
                await _applicationDbContext.SaveChangesAsync();

                // add member is admin to PartyMember
                DateTime now = DateTime.Now;
                DateTime time = new DateTime(now.Year, now.Month, now.Day, now.Hour, now.Minute, now.Second);
                PartyMemberDTO partyMemberDTO = new PartyMemberDTO()
                {
                    MemberId = _userResolverService.GetMemberId(),
                    PartyId = id,
                    IsAdmin = true,
                    IsBlock = false,
                    JoinDate = time,
                    OutDate = time,
                };
                await _applicationDbContext.PartyMembers.AddAsync(MapperConfig.GetMapper().Map<PartyMember>(partyMemberDTO));
                
                dto.Skills.ForEach(skill =>
                {
                    PartySkill partySkill = new PartySkill
                    {
                        PartyId = id,
                        SkillId = Guid.Parse(skill)
                    };
                    _applicationDbContext.PartySkills.Add(partySkill);
                });
                await _applicationDbContext.SaveChangesAsync();
                await transaction.CommitAsync();
                return MapperConfig.GetMapper().Map<PartyDTO>(party);
            } catch (Exception e)
            {
                throw new Exception(e.Message);
            }
        }

        public async Task<bool> DeleteAsync(Guid id)
        {
            Party existParty = await _partyRepository.GetAsync(id);
            if (existParty == null)
            {
                return false;
            }
            existParty.Status = false;
            int count = await _partyRepository.Update(existParty);
            if (count <= 0) return false;
            return true;
        }

        public async Task<PartyDTO> GetAsync(Guid id)
        {
            Party existedParty = await _partyRepository.GetAsync(id);
            if(existedParty != null && existedParty.Status != false )
            {
                return MapperConfig.GetMapper().Map<PartyDTO>(existedParty);
            }
            return null;
        }

        public async Task<PartyDTO> UpdateAsync(UpdatePartyDTO dto, string host)
        {

            Party existParty = await _partyRepository.GetAsync(dto.Id);
            if(existParty == null)
            {
                return null;
            }

            // Getting Image
            var image = dto.Image;

            // Saving Image on Server
            FileReturnDTO fileReturn = new FileReturnDTO();
            string path = "";
            Guid id = existParty.Id;
            if (image != null && image.Length > 0)
            {
                string childPath = $"\\group\\{id.ToString()}\\" + "image" + "";
                fileReturn = FileUtil.GetStreamToSaveFile(childPath, image.FileName.ToString());
                await image.CopyToAsync(fileReturn.stream);
                fileReturn.stream.Close();
                path = FileUtil.SetPathForFile(host, "v1", "group", id.ToString(), "image", image.FileName.ToString());
                //path = FileUtil.SetPathForImage(host, "member", id.ToString(), image.FileName.ToString());
            }

            existParty.Name = dto.Name;
            existParty.Description = dto.Description;
            existParty.Image = path;
            existParty.Maximum = dto.Maximum;
            existParty.IsApprovedPost = dto.IsApprovedPost;
            int count = await _partyRepository.Update(existParty);
            if (count == 0)
            {
                return null;
            }
            return MapperConfig.GetMapper().Map<PartyDTO>(existParty);

        }

        public async Task<PaginationResponseDTO<PartyDTO>> Search(PaginationRequestDTO searchDTO)
        {
            PaginationRequestDTO validatedPagination = new PaginationUtils().validatePaginationParam(searchDTO, "Party");
            Page<Party> partyPage = await _partyRepository.searchPagination(validatedPagination);
            PaginationResponseDTO<PartyDTO> pagination = new PaginationResponseDTO<PartyDTO>();
            if(partyPage != null)
            {
                List<PartyDTO> dataList = new List<PartyDTO>();
                partyPage.Results.ToList().ForEach(e => dataList.Add(MapperConfig.GetMapper().Map<PartyDTO>(e)));
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

        public async Task<List<PartyRequestDTO>> getAllRequestByRuleAndPartyId(PartyRequestParty dto)
        {
            try
            {
                Party party = await _partyRepository.GetAsync(dto.PartyId);
                if (party == null) throw new Exception("Not found party with following id !");
                List<PartyRequest> list = (List<PartyRequest>)await _partyRequestRepository.GetEntriesByRuleAndPartyId(dto);
                List<PartyRequestDTO> returnList = new List<PartyRequestDTO>();
                list.ForEach(e => returnList.Add(MapperConfig.GetMapper().Map<PartyRequestDTO>(e)));
                return returnList;
            }
            catch (Exception e)
            {
                throw new Exception(e.Message);
            }
        }

        public async Task rejectMember(PartyRequestDTO requestDTO)
        {
            try
            {
                String valid = "";
                Party party = await _partyRepository.GetAsync(requestDTO.PartyId);
                if (party == null) valid += "Not found party with following id !\n";
                Member member = await _memberRepository.GetAsync(requestDTO.MemberId);
                if (member == null) valid += "Not found member with following id !";
                if (!valid.Equals("")) throw new Exception(valid);
                requestDTO.Status = 0;
                PartyRequest partyRequest = await _partyRequestRepository.GetEntryByRule(requestDTO);
                if (partyRequest == null) throw new Exception("Not found entry !");
                partyRequest.Status = 2;
                await _partyRequestRepository.Update(partyRequest);

            }
            catch (Exception e)
            {
                throw new Exception(e.Message);
            }
        }

        public async Task acceptMember(PartyRequestDTO requestDTO)
        {
            try
            {
                String valid = "";
                Party party = await _partyRepository.GetAsync(requestDTO.PartyId);
                if (party == null) valid += "Not found party with following id !\n";
                Member member = await _memberRepository.GetAsync(requestDTO.MemberId);
                if (member == null) valid += "Not found member with following id !";
                if (!valid.Equals("")) throw new Exception(valid);
                requestDTO.Status = 0;
                PartyRequest partyRequest = await _partyRequestRepository.GetEntryByRule(requestDTO);
                if (partyRequest == null) throw new Exception("Not found entry !");
                partyRequest.Status = 1;
                var transaction = _applicationDbContext.Database.BeginTransaction();
                _applicationDbContext.PartyRequests.Update(partyRequest);
                await _applicationDbContext.SaveChangesAsync();
                DateTime now = DateTime.Now;
                DateTime time = new DateTime(now.Year, now.Month, now.Day, now.Hour, now.Minute, now.Second);
                PartyMemberDTO partyMemDTO = new PartyMemberDTO()
                {
                    PartyId = requestDTO.PartyId,
                    MemberId = requestDTO.MemberId,
                    JoinDate = time,
                    OutDate = time
                };
                _applicationDbContext.PartyMembers.Add(MapperConfig.GetMapper().Map<PartyMember>(partyMemDTO));
                await _applicationDbContext.SaveChangesAsync();
                await transaction.CommitAsync();
            }
            catch (Exception e)
            {
                throw new Exception(e.Message);
            }
        }

        public async Task<List<PartyDTO>> getPartyByMemberId(Guid memberId)
        {
            try
            {
                Member member = await _memberRepository.GetAsync(memberId);
                if (member == null) throw new Exception("Not found member with following id !");
                List<PartyMember> list = (List<PartyMember>)await _partyMemberRepository.getPartyByMemberId(memberId);
                List<PartyDTO> returnList = new List<PartyDTO>();
                if (list != null)
                {
                    list.ForEach(p => returnList.Add(MapperConfig.GetMapper().Map<PartyDTO>(p.Party)));
                }
                return returnList;
            }
            catch (Exception e)
            {
                throw new Exception(e.Message);
            }
        }
    }
}
