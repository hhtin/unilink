using System;
using System.Collections.Generic;
using System.ComponentModel.DataAnnotations;
using System.ComponentModel.DataAnnotations.Schema;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace Unilink.Data.Entity
{
    [Table("MajorSkill")]
    public class MajorSkill
    {
        [Required]
        [Key, Column(Order = 1)]
        public Guid MajorId { get; set; }

        [Required]
        [Key, Column(Order = 2)]
        public Guid SkillId { get; set; }

        [ForeignKey("MajorId")]
        public Major Major { get; set; }

        [ForeignKey("SkillId")]
        public Skill Skill { get; set; }
    }
}
