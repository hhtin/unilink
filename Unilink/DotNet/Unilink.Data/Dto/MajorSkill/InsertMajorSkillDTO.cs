using System;
using System.Collections.Generic;
using System.ComponentModel.DataAnnotations;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace Unilink.Data.Dto.MajorSkill
{
    public class InsertMajorSkillDTO
    {
        [Required]
        public string MajorId { get; set; }
        [Required]
        public string SkillId { get; set; }
    }
}
