using System;
using System.Collections.Generic;
using System.ComponentModel.DataAnnotations;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace Unilink.Data.Dto.PartyInvitation
{
   public class PartyInvitationInsertDTO
    {
        [Required]
        public Guid PartyId { get; set; }
        [Required]
        public Guid MemberId { get; set; }
    }
}
