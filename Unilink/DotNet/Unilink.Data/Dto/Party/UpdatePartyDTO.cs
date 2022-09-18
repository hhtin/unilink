using System;
using System.Collections.Generic;
using System.ComponentModel.DataAnnotations;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using Microsoft.AspNetCore.Http;

namespace Unilink.Data.Dto.Party
{
    public class UpdatePartyDTO
    {
        [Required(ErrorMessage = "Id can not be empty")]
        public Guid Id
        {
            get; set;
        }
        [Required(ErrorMessage = "Name can not be empty")]
        [StringLength(20)]
        public string Name
        {
            get; set;
        }
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
        public bool IsApprovedPost
        {
            get; set;
        }
    }
}
