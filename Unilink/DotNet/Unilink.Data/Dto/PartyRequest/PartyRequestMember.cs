using System;
using System.Collections.Generic;
using System.ComponentModel.DataAnnotations;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace Unilink.Data.Dto.PartyRequest
{
    public class PartyRequestMember
    {
        [Required]
        public Guid MemberId { get; set; }
        [Required]
        [Range(0,2)]
        public int Status { get; set; }
    }
}
