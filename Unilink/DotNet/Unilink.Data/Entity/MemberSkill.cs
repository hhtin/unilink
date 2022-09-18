using System;
using System.Collections.Generic;
using System.ComponentModel.DataAnnotations;
using System.ComponentModel.DataAnnotations.Schema;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace Unilink.Data.Entity
{
    [Table("MemberSkill")]
    public class MemberSkill
    {
        [Required]
        public Guid MemberId { get; set; }

        [ForeignKey("MemberId")]
        public Member Member { get; set; }

        [Required]
        public Guid SkillId { get; set; }

        [ForeignKey("SkillId")]
        public Skill Skill { get; set; }
    }
}
