using System;
using System.Collections.Generic;
using System.ComponentModel.DataAnnotations;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace Unilink.Data.Dto.FirebaseMessageToken
{
    public class FirebaseMessageTokenDTO
    {
        [Required]
        public Guid tokenId { get; set; }
        [Required]
        public Guid memberId { get; set; }
        [Required]
        public string token { get; set; }
        public bool status { get; set; }
    }
}
