using System;
using System.Collections.Generic;
using System.ComponentModel.DataAnnotations;
using System.ComponentModel.DataAnnotations.Schema;
using System.Linq;
using System.Text;
using System.Threading.Tasks;


namespace Unilink.Data.Entity
{
    [Table("Major")]
    public class Major
    {
        [Key]
        public Guid Id { get; set; }
        [Required]
        public string Name { get; set; }
        [Required]
        public string Description { get; set; }
        [Required]
        public bool Status { get; set; }

        public virtual ICollection<Skill> Skills { get; set; }
        public virtual List<MajorSkill> MajorSkills { get; set; }
    }
}
