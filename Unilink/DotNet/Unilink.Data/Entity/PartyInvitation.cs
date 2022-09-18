using System;
using System.Collections.Generic;
using System.ComponentModel.DataAnnotations;
using System.ComponentModel.DataAnnotations.Schema;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace Unilink.Data.Entity
{   
    [Table("PartyInvitation")]
    public class PartyInvitation
    {
        [Required]
        public Guid PartyId { get; set; }
        [Required]
        public Guid MemberId { get; set; }
        [Required]
        [DataType(DataType.DateTime)]
        public DateTime CreatedDate { get; set; }
        [Required]
        [Range(0,2)]
        public int Status { get; set; }
    }
}
