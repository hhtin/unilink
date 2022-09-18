using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using Unilink.Data.Dto.Major;
using Unilink.Data.Dto.Member;
using Unilink.Data.Dto.Skill;

namespace Unilink.Data.Dto.MemberDetails
{
    public class MemberDetailsDTO
    {
        public Guid Id { get; set; }
        public string Phone { get; set; }
        public string Email { get; set; }
        public string FirstName { get; set; }
        public string LastName { get; set; }
        public DateTime DOB { get; set; }
        public int Gender { get; set; }
        public string Address { get; set; }
        public string Description { get; set; }
        public string Avatar { get; set; }
        public bool IsOnline { get; set; }
        public Guid RoleId { get; set; }
        public bool Status { get; set; }
        public Guid UniversityId { get; set; }

        public List<MajorDTO> majors
        {
            get; set;
        }

        public List<SkillDTO> skills
        {
            get; set;
        }

    }
}
