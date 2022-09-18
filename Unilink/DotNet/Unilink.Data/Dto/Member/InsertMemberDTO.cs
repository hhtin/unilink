using Microsoft.AspNetCore.Http;
using System;
using System.Collections.Generic;
using System.ComponentModel.DataAnnotations;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace Unilink.Data.Dto.Member
{
    public class InsertMemberDTO
    {
        public string Phone { get; set; }
        [EmailAddress]
        public string Email { get; set; }
        [Required]
        public string FirstName { get; set; }
        [Required]
        public string LastName { get; set; }
        [Required]
        [DataType(DataType.Date)]
        public DateTime DOB { get; set; }
        [Required]
        [Range(0,2)]
        public int Gender { get; set; }
        [Required]
        public string Address { get; set; }
        [Required]
        public string Description { get; set; }
        public IFormFile Image { get; set; }
        [Required]
        public Guid RoleId { get; set; }
        [Required]
        public Guid UniversityId { get; set; }
        [Required]
        public List<Guid> majorList { get; set; }
        [Required]
        public List<Guid> skillList { get; set; }
    }
}
