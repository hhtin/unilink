using System;
using System.Collections.Generic;
using System.ComponentModel.DataAnnotations;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace Unilink.Data.Dto.PartyMember
{
    public class PartyMemberDTO
    {
        [Required]
        public Guid PartyId { get; set; }
        [Required]
        public Guid MemberId { get; set; }
        public bool IsAdmin { get; set; }
        public bool IsBlock { get; set; }
        [Required]
        public DateTime JoinDate { get; set; }
        public DateTime OutDate { get; set; }
    }
}
