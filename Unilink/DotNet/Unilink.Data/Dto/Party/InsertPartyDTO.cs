using Microsoft.AspNetCore.Http;
using System;
using System.Collections.Generic;
using System.ComponentModel.DataAnnotations;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace Unilink.Data.Dto.Party
{
    public class InsertPartyDTO
    {

        [StringLength(20)]
        [Required(ErrorMessage ="Name can not be empty")]
        public string Name
        {
            get; set;
        }
        [Required(ErrorMessage = "Name can not be empty")]
        public string Description
        {
            get; set;
        }
        public IFormFile Image
        {
            get; set;
        }
        [Required(ErrorMessage = "Maximum can not be empty")]
        [Range(2, 10, ErrorMessage = "Range of member from 2 to 10")]
        public int Maximum
        {
            get; set;
        }
        [Required(ErrorMessage = "Major id can not be empty")]
        public Guid MajorId
        {
            get; set;
        }
        public bool IsApprovedPost
        {
            get; set;
        }
        [Required(ErrorMessage = "Skills can not be empty")]
        public List<string> Skills { get; set; }

        [Required(ErrorMessage = "Address can not be empty")]
        public string Address { get; set; }
    }
}
