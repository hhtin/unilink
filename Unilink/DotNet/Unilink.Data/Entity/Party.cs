using System;
using System.Collections.Generic;
using System.ComponentModel.DataAnnotations;
using System.ComponentModel.DataAnnotations.Schema;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace Unilink.Data.Entity
{
    [Table("Party")]
    public class Party
    {

        [Key]
        public Guid Id
        {
            get; set;
        }
        [Required]
        public string Name
        {
            get; set;
        }
        [Required]
        public string Description
        {
            get; set;
        }
        [Required]
        public string Image
        {
            get; set;
        }
        [Required]
        public int Maximum
        {
            get; set;
        }
        [Required]
        public DateTime CreateDate
        {
            get; set;
        }
        [Required]
        public Guid MajorId
        {
            get; set;
        }
        [Required]
        public bool IsApprovedPost
        {
            get; set;
        }
        [Required]
        public bool Status
        {
            get; set;
        }
        [Required]
        public string Address
        {
            get; set;
        }
        public virtual ICollection<Skill> Skills { get; set; }
        public virtual List<PartySkill> PartySkills { get; set; }

    }

}
