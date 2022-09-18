using System;
using System.Collections.Generic;
using System.ComponentModel.DataAnnotations;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace Unilink.Data.Dto.PartyRequest
{
    public class PartyRequestParty
    {
        [Required]
        public Guid PartyId { get; set; }
        [Required]
        [Range(0, 2)]
        public int Status { get; set; }
    }
}
