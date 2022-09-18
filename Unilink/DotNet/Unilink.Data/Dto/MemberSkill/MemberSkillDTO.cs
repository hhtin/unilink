using System;
using System.Collections.Generic;
using System.ComponentModel.DataAnnotations;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace Unilink.Data.Dto.MemberSkill
{
    public class MemberSkillDTO
    {
        [Required]
        public Guid MemberId { get; set; }
        [Required]
        public Guid SkillId { get; set; }
    }
}
