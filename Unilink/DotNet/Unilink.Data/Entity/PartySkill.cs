using System;
using System.Collections.Generic;
using System.ComponentModel.DataAnnotations;
using System.ComponentModel.DataAnnotations.Schema;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace Unilink.Data.Entity
{
    [Table("PartySkill")]
    public class PartySkill
    {
        [Required]
        public Guid PartyId { get; set; }
        [Required]
        public Guid SkillId { get; set; }


        [ForeignKey("PartyId")]
        public Party Party { get; set; }

        [ForeignKey("SkillId")]
        public Skill Skill { get; set; }
    }
}
