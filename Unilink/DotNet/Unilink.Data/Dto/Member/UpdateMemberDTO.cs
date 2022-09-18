using System;
using System.Collections.Generic;
using System.ComponentModel.DataAnnotations;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using Microsoft.AspNetCore.Http;

namespace Unilink.Data.Dto.Member
{
    public class UpdateMemberDTO
    {
        [Required(ErrorMessage = "Id can not be empty")]
        public Guid Id { get; set; }

        [StringLength(15)]
        [Required(ErrorMessage = "Phone can not be empty")]
        public string Phone { get; set; }

        [Required(ErrorMessage = "Email can not be empty")]
        public string Email { get; set; }

        [Required(ErrorMessage = "First name can not be empty")]
        public string FirstName { get; set; }

        [Required(ErrorMessage = "Last name can not be empty")]
        public string LastName { get; set; }

        [Required(ErrorMessage = "DOB can not be empty")]
        public DateTime DOB { get; set; }

        [Required(ErrorMessage = "Gender can not be empty")]
        public int Gender { get; set; }

        [Required(ErrorMessage = "Address id can not be empty")]
        public string Address { get; set; }
        [Required(ErrorMessage = "Description can not be empty")]
        public string Description { get; set; }
        public IFormFile Image { get; set; }
        [Required]
        public List<Guid> majorList { get; set; }
        [Required]
        public List<Guid> skillList { get; set; }

    }
}
