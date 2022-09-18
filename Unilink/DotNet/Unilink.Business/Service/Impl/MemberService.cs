using EntityFrameworkPaginateCore;
using Microsoft.AspNetCore.Mvc;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using Unilink.Business.Utils;
using Unilink.Data.Config;
using Unilink.Data.Dto;
using Unilink.Data.Dto.Major;
using Unilink.Data.Dto.Member;
using Unilink.Data.Dto.MemberSkill;
using Unilink.Data.Dto.Pagination;
using Unilink.Data.Dto.PartyRequest;
using Unilink.Data.Dto.Skill;
using Unilink.Data.Entity;
using Unilink.Data.Repository;
namespace Unilink.Business.Service.Impl
{
    public class MemberService : IMemberService
    {
        private IMemberRepository _memberRepository;
        private readonly ApplicationDbContext _applicationDbContext;
        private IRoleRepository _roleRepository;
        private IUniversityRepository _universityRepository;
        private IPartyRepository _partyRepository;
        private IPartyRequestRepository _partyRequestRepository;
        private IPartyMemberRepository _partyMemberRepository;
        private IUserResolverService _userResolverService;
        private IMemberMajorRepository _memberMajorRepository;
        private IMemberSkillRepository _memberSkillRepository;

        public MemberService(IMemberRepository memberRepository, ApplicationDbContext applicationDbContext,
            IUniversityRepository universityRepository, IRoleRepository roleRepository, IPartyRepository partyRepository,
            IPartyRequestRepository partyRequestRepository,
            IPartyMemberRepository partyMemberRepository, 
            IUserResolverService userResolverService,
            IMemberMajorRepository memberMajorRepository,
            IMemberSkillRepository memberSkillRepository)
        {
            this._memberRepository = memberRepository;
            this._applicationDbContext = applicationDbContext;
            this._universityRepository = universityRepository;
            this._roleRepository = roleRepository;
            this._partyRepository = partyRepository;
            this._partyRequestRepository = partyRequestRepository;
            this._partyMemberRepository = partyMemberRepository;
            this._userResolverService = userResolverService;
            this._memberMajorRepository = memberMajorRepository;
            this._memberSkillRepository = memberSkillRepository;
        }
        public async Task<Member> InsertAsync(InsertMemberDTO  insertMemberDTO, string host)
        {
            Role role = await _roleRepository.GetAsync(insertMemberDTO.RoleId);
            if (role == null)
            {
                return null;
            }

            University university = await _universityRepository.GetAsync(insertMemberDTO.UniversityId);
            if(university == null)
            {
                return null;
            }

            // Getting Image
            var image = insertMemberDTO.Image;

            // Saving Image on Server
            FileReturnDTO fileReturn = new FileReturnDTO();
            string path = "";
            Guid id = Guid.NewGuid();
            if (image != null && image.Length > 0)
            {
                string childPath = $"\\member\\{id.ToString()}\\" + "image" + "";
                fileReturn = FileUtil.GetStreamToSaveFile(childPath, image.FileName.ToString());
                await image.CopyToAsync(fileReturn.stream);
                fileReturn.stream.Close();
                path = FileUtil.SetPathForFile(host,"v1", "member", id.ToString(), "image", image.FileName.ToString());
            }

            Member member = MapperConfig.GetMapper().Map<Member>(insertMemberDTO);
            member.Id = id;
            member.Avatar = path;
            member.Status = true;
            member.IsOnline = true;
            try
            {
                int count = await _memberRepository.InsertAsync(member);
                if (count == 0)
                {
                    return null;
                }
                else
                {
                    List<Guid> majorList = insertMemberDTO.majorList;
                    List<Guid> skillList = insertMemberDTO.skillList;
                    if(majorList != null && majorList.Count > 0)
                    {
                        for(int i = 0; i < majorList.Count; i++)
                        {
                            MemberMajorDTO memberMajorDTO = new MemberMajorDTO();
                            memberMajorDTO.MemberId = id;
                            memberMajorDTO.MajorId = majorList[i];
                            await _memberMajorRepository
                                .InsertAsync(MapperConfig.GetMapper()
                                .Map<MemberMajor>(memberMajorDTO));
                        }    
                    }
                    if (skillList != null && skillList.Count > 0)
                    {
                        for (int i = 0; i < skillList.Count; i++)
                        {
                            MemberSkillDTO memberSkillDTO = new MemberSkillDTO();
                            memberSkillDTO.MemberId = id;
                            memberSkillDTO.SkillId = skillList[i];
                            await _memberSkillRepository
                                .InsertAsync(MapperConfig.GetMapper()
                                .Map<MemberSkill>(memberSkillDTO));
                        }
                    }
                } 
                    
                return member;
            } catch (Exception e)
            {
                throw new Exception(e.Message);
            }
        }


        public async Task<Member> LoginByEmail(string email)
        {
            return await this._memberRepository.FindMemberByEmail(email);
        }

        public async Task<SearchMemberResponseDTO> Search(SearchMemberRequestDTO searchDTO)
        {
            IEnumerable<Member> members = await _memberRepository.SearchAsync(searchDTO);
            double count = await _memberRepository.CountSearchAsync(searchDTO);

            SearchMemberResponseDTO searchMemberResponseDTO = new SearchMemberResponseDTO();
            searchMemberResponseDTO.TotalPage = count;

            List<MemberDTO> memberDTOs = new List<MemberDTO>();
            foreach (Member member in members)
            {
                MemberDTO majorDTO = MapperConfig.GetMapper().Map<MemberDTO>(member);
                memberDTOs.Add(majorDTO);
            }
            searchMemberResponseDTO.Members = memberDTOs;
            return searchMemberResponseDTO;
        }

        public async Task<Member> GetAsync(Guid id)
        {
            Member existedMember = await _memberRepository.GetAsync(id);
            if (existedMember != null && existedMember.Status != false)
            {
                return existedMember;
            }
            return null;
        }

        public async Task<bool> Delete(Guid id)
        {
            Member existMember = await _memberRepository.GetAsync(id);
            if (existMember == null)
            {
                return false;
            }
            existMember.Status = false;
            int count = await _memberRepository.Update(existMember);
            if (count <= 0) return false;
            return true;
        }

        public async Task<MemberDTO> Update(UpdateMemberDTO memberDTO, string host)
        {

            Member existMember = await _memberRepository.GetAsync(memberDTO.Id);
            if (existMember == null)
            {
                return null;
            }

            // Getting Image
            var image = memberDTO.Image;

            // Saving Image on Server
            FileReturnDTO fileReturn = new FileReturnDTO();
            string path = "";
            Guid id = Guid.NewGuid();
            if (image != null && image.Length > 0)
            {
                string childPath = $"\\member\\{id.ToString()}\\" + "image" + "";
                fileReturn = FileUtil.GetStreamToSaveFile(childPath, image.FileName.ToString());
                image.CopyTo(fileReturn.stream);
                path = FileUtil.SetPathForFile(host, "v1", "member", id.ToString(), "image", image.FileName.ToString());
            }

            existMember.Phone = memberDTO.Phone;
            existMember.Email = memberDTO.Email;
            existMember.FirstName = memberDTO.FirstName;
            existMember.LastName = memberDTO.LastName;
            existMember.DOB = memberDTO.DOB;
            existMember.Gender = memberDTO.Gender;
            existMember.Address = memberDTO.Address;
            existMember.Description = memberDTO.Description;
            existMember.Avatar = path;

            try
            {
                int count = await _memberRepository.Update(existMember);
                if (count == 0)
                {
                    return null;
                }
                else
                {
                    List<MemberSkill> oldSkillList = (List<MemberSkill>)await _memberSkillRepository
                        .getSkillsByMemberId(memberDTO.Id);
                    List<MemberMajor> oldMajorList = (List<MemberMajor>)await _memberMajorRepository
                        .getMajorByMemberId(memberDTO.Id);
                    bool checkDeleteSkill = _memberSkillRepository.deleteMemberSkills(oldSkillList);
                    bool checkDeleteMajor = _memberMajorRepository.deleteMemberMajors(oldMajorList);
                    if (checkDeleteSkill && checkDeleteMajor)
                    {
                        List<Guid> newMajorList = memberDTO.majorList;
                        List<Guid> newSkillList = memberDTO.skillList;
                        if (newMajorList != null && newMajorList.Count > 0)
                        {
                            for (int i = 0; i < newMajorList.Count; i++)
                            {
                                MemberMajorDTO memberMajorDTO = new MemberMajorDTO();
                                memberMajorDTO.MemberId = memberDTO.Id;
                                memberMajorDTO.MajorId = newMajorList[i];
                                await _memberMajorRepository
                                    .InsertAsync(MapperConfig.GetMapper()
                                    .Map<MemberMajor>(memberMajorDTO));
                            }
                        }
                        if (newSkillList != null && newSkillList.Count > 0)
                        {
                            for (int i = 0; i < newSkillList.Count; i++)
                            {
                                MemberSkillDTO memberSkillDTO = new MemberSkillDTO();
                                memberSkillDTO.MemberId = memberDTO.Id;
                                memberSkillDTO.SkillId = newSkillList[i];
                                await _memberSkillRepository
                                    .InsertAsync(MapperConfig.GetMapper()
                                    .Map<MemberSkill>(memberSkillDTO));
                            }
                        }
                    }

                    return MapperConfig.GetMapper().Map<MemberDTO>(existMember);
                }
            }
            catch (Exception e)
            {
                throw new Exception(e.Message);
            }
        }

        public async Task<PaginationResponseDTO<MemberDTO>> Search(PaginationRequestDTO searchDTO)
        {
            PaginationRequestDTO validatedPagination = new PaginationUtils().validatePaginationParam(searchDTO, "Member");
            Page<Member> partyPage = await _memberRepository.searchPagination(validatedPagination);
            PaginationResponseDTO<MemberDTO> pagination = new PaginationResponseDTO<MemberDTO>();
            if (partyPage != null)
            {
                List<MemberDTO> dataList = new List<MemberDTO>();
                partyPage.Results.ToList().ForEach(e => dataList.Add(MapperConfig.GetMapper().Map<MemberDTO>(e)));
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

        public async Task requestParty(PartyRequestInsertDTO requestDTO)
        {
            try
            {
                String valid = "";
                Party party = await _partyRepository.GetAsync(requestDTO.PartyId);
                if (party == null) valid += "Not found party with following id !\n";
                Member member = await _memberRepository.GetAsync(requestDTO.MemberId);
                if (member == null) valid += "Not found member with following id !";
                if (!valid.Equals("")) throw new Exception(valid);
                PartyRequest partyRequest = MapperConfig.GetMapper().Map<PartyRequest>(requestDTO);
                DateTime now = DateTime.Now;
                DateTime time = new DateTime(now.Year, now.Month, now.Day, now.Hour, now.Minute, now.Second);
                partyRequest.CreatedDate = time;
                partyRequest.Status = 0;
                await _partyRequestRepository.InsertAsync(partyRequest);
            } catch (Exception e)
            {
                throw new Exception(e.Message);
            }
        }

        public async Task rejectParty(PartyRequestDTO requestDTO)
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

        public async Task<IEnumerable<PartyRequestDTO>> getAllRequestByRule(int type)
        {
            try
            {
                List<PartyRequest> list = (List<PartyRequest>) await _partyRequestRepository.GetAllByRule(type);
                List<PartyRequestDTO> returnList = new List<PartyRequestDTO>();
                list.ForEach(e => returnList.Add(MapperConfig.GetMapper().Map<PartyRequestDTO>(e)));
                return returnList;
            } catch (Exception e)
            {
                throw new Exception(e.Message);
            }
        }

        public async Task<IEnumerable<PartyRequestDTO>> getAllRequestByRuleAndMemberId(PartyRequestMember dto)
        {
            try
            {
                Member member = await _memberRepository.GetAsync(dto.MemberId);
                if (member == null) throw new Exception("Not found member with following id !");
                List<PartyRequest> list = (List<PartyRequest>) await _partyRequestRepository.GetEntriesByRuleAndMemberId(dto);
                List<PartyRequestDTO> returnList = new List<PartyRequestDTO>();
                list.ForEach(e => returnList.Add(MapperConfig.GetMapper().Map<PartyRequestDTO>(e)));
                return returnList;
            }
            catch (Exception e)
            {
                throw new Exception(e.Message);
            }
        }

        public async Task<List<MemberDTO>> getMemberByPartyId(Guid partyId)
        {
            try
            {
                Party party = await _partyRepository.GetAsync(partyId);
                if (party == null) throw new Exception("Not found party with following id !");
                List<PartyMember> list = (List<PartyMember>) await _partyMemberRepository.getMemberByPartyId(partyId);
                List<MemberDTO> returnList = new List<MemberDTO>();
                if (list != null)
                {
                    list.ForEach(p => returnList.Add(MapperConfig.GetMapper().Map<MemberDTO>(p.Member)));
                }
                return returnList;
            }
            catch (Exception e)
            {
                throw new Exception(e.Message);
            }
        }

        public async Task<MemberDTO> getCurrentMember()
        {
            
            Member existedMember = await _memberRepository.GetAsync(_userResolverService.GetMemberId());
            if (existedMember != null && existedMember.Status != false)
            {
                Console.WriteLine(existedMember);
                return MapperConfig.GetMapper().Map<MemberDTO>(existedMember);
            }
            return null;
        }

        public async Task<List<MajorDTO>> getAllMajorByMemberId(Guid memberId)
        {
            try
            {
                Member member = await _memberRepository.GetAsync(memberId);
                if (member == null)
                    throw new Exception("Not found member with following id !");
                List<MemberMajor> list = (List<MemberMajor>)await _memberMajorRepository.getMajorByMemberId(memberId);
                List<MajorDTO> returnList = new List<MajorDTO>();
                if (list != null)
                {
                    list.ForEach(p => returnList.Add(MapperConfig.GetMapper().Map<MajorDTO>(p.Major)));
                }
                return returnList;
            }
            catch (Exception e)
            {
                throw new Exception(e.Message);
            }
        }

        public async Task<List<SkillDTO>> getAllSkillsByMemberId(Guid memberId)
        {
            try
            {
                Member member = await _memberRepository.GetAsync(memberId);
                if (member == null)
                    throw new Exception("Not found member with following id !");
                List<MemberSkill> list = (List<MemberSkill>)await _memberSkillRepository.getSkillsByMemberId(memberId);
                List<SkillDTO> returnList = new List<SkillDTO>();
                if (list != null)
                {
                    list.ForEach(p => returnList.Add(MapperConfig.GetMapper().Map<SkillDTO>(p.Skill)));
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
