using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace Unilink.Data.Dto.Member
{
    public class SearchMemberRequestDTO
    {
        public int Page { get; set; }
        public int Limit { get; set; }
        public string Email { get; set; }
        public string FirstName { get; set; }
        public string LastName { get; set; }
        public bool IsAcending { get; set; }
    }
}
