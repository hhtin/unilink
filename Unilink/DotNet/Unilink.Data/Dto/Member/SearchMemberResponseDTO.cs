using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace Unilink.Data.Dto.Member
{
    public class SearchMemberResponseDTO
    {
        public List<MemberDTO> Members { get; set; }
        public double TotalPage { get; set; }
    }
}
