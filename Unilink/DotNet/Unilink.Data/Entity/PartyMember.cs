using System;
using System.Collections.Generic;
using System.ComponentModel.DataAnnotations;
using System.ComponentModel.DataAnnotations.Schema;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace Unilink.Data.Entity
{
    [Table("PartyMember")]
    public class PartyMember
    {
        [Required]
        public Guid PartyId { get; set; }
        [ForeignKey("PartyId")]
        public Party Party { get; set; }
        [Required]
        public Guid MemberId { get; set; }
        [ForeignKey("MemberId")]
        public Member Member { get; set; }
        public bool IsAdmin { get; set; }
        public bool IsBlock { get; set; }
        [Required]
        public DateTime JoinDate { get; set; }
        public DateTime OutDate { get; set; }
    }
}
