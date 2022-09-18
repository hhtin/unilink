using System;
using System.Collections.Generic;
using System.ComponentModel.DataAnnotations;
using System.ComponentModel.DataAnnotations.Schema;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace Unilink.Data.Entity
{
    [Table("Member")]
    public class Member
    {
        [Key]
        public Guid Id { get; set; }
        public string Phone { get; set; }
        public string Email { get; set; }
        public string FirstName { get; set; }
        public string LastName { get; set; }
        public DateTime DOB { get; set; }
        public int Gender { get; set; }
        public string Address { get; set; }
        public string Description { get; set; }
        public string Avatar { get; set; }
        public bool IsOnline { get; set; }
        public Guid RoleId { get; set; }
        [ForeignKey("RoleId")]
        public Role Role { get; set; }
        public bool Status { get; set; }
        public Guid UniversityId { get; set; }
        [ForeignKey("UniversityId")]
        public University University { get; set; }
    }
}
