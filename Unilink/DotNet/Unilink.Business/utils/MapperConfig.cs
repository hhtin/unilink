using AutoMapper;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Reflection;
using System.Text;
using System.Threading.Tasks;
using Unilink.Data.Dto;
using Unilink.Data.Dto.Comment;
using Unilink.Data.Dto.FirebaseMessageToken;
using Unilink.Data.Dto.Major;
using Unilink.Data.Dto.Member;
using Unilink.Data.Dto.MemberDetails;
using Unilink.Data.Dto.MemberSkill;
using Unilink.Data.Dto.Party;
using Unilink.Data.Dto.PartyInvitation;
using Unilink.Data.Dto.PartyMember;
using Unilink.Data.Dto.PartyRequest;
using Unilink.Data.Dto.Post;
using Unilink.Data.Dto.Role;
using Unilink.Data.Dto.Skill;
using Unilink.Data.Dto.Topic;
using Unilink.Data.Dto.University;
using Unilink.Data.Entity;

namespace Unilink.Business.Utils
{
    public class MapperConfig
    {
       public static IMapper GetMapper()
       {
            var configuration = new MapperConfiguration(cfg =>
            {
                cfg.CreateMap<InsertRoleDTO, Role>();
                cfg.CreateMap<RoleDTO, Role>();
                cfg.CreateMap<Role, RoleDTO>();

                cfg.CreateMap<InsertUniversityDTO, University>();
                cfg.CreateMap<UniversityDTO, University>();
                cfg.CreateMap<University, UniversityDTO>();

                cfg.CreateMap<InsertSkillDTO, Skill>();
                cfg.CreateMap<SkillDTO, Skill>();
                 cfg.CreateMap<Skill, SkillDTO>();

                cfg.CreateMap<InsertMajorDTO, Major>();
                cfg.CreateMap<MajorDTO, Major>();
                cfg.CreateMap<Major, MajorDTO>();

                cfg.CreateMap<InsertMemberDTO, Member>();
                cfg.CreateMap<MemberDTO, Member>();
                cfg.CreateMap<Member, MemberDTO>();

                cfg.CreateMap<InsertPartyDTO, Party>().ForMember(x => x.Skills, opt => opt.Ignore()); ;
                cfg.CreateMap<Party, PartyDTO>();
                cfg.CreateMap<PartyDTO, Party>();
                cfg.CreateMap<UpdatePartyDTO, Party>();

                cfg.CreateMap<InsertPostDTO, Post>();
                cfg.CreateMap<Post, PostDTO>();
                cfg.CreateMap<PostDTO, Post>();

                cfg.CreateMap<InsertTopicDTO, Topic>();
                cfg.CreateMap<Topic, TopicDTO>();
                cfg.CreateMap<TopicDTO, Topic>();
                cfg.CreateMap<UpdateTopicDTO, Topic>();

                cfg.CreateMap<PartyInvitationInsertDTO, PartyInvitation>();
                cfg.CreateMap<PartyInvitationDTO, PartyInvitation>();

                cfg.CreateMap<PartyRequestInsertDTO, PartyRequest>();
                cfg.CreateMap<PartyRequestDTO, PartyRequest>();
                cfg.CreateMap<PartyRequest, PartyRequestDTO>();

                cfg.CreateMap<InsertCommentDTO, Comment>();
                cfg.CreateMap<Comment, CommentDTO>();
                cfg.CreateMap<CommentDTO, Comment>();

                cfg.CreateMap<PartyMember, PartyMemberDTO>();
                cfg.CreateMap<PartyMemberDTO, PartyMember>();

                cfg.CreateMap<MemberMajor, MemberMajorDTO>();
                cfg.CreateMap<MemberMajorDTO, MemberMajor>();
                cfg.CreateMap<Member, MemberDetailsDTO>();
                cfg.CreateMap<MemberDetailsDTO, Member>();

                cfg.CreateMap<MemberSkillDTO, MemberSkill>();
                cfg.CreateMap<MemberSkill, MemberSkillDTO>();

                cfg.CreateMap<InsertMessageToken, FirebaseMessageToken>();
                cfg.CreateMap<FirebaseMessageTokenDTO, FirebaseMessageToken>();
                cfg.CreateMap<FirebaseMessageToken, FirebaseMessageTokenDTO>();
            });
            return configuration.CreateMapper() ;
        }
    }
}
