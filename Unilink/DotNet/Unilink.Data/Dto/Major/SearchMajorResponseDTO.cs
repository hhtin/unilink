using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
namespace Unilink.Data.Dto.Major
{
    public class SearchMajorResponseDTO
    {
        public List<MajorDTO> Majors { get; set; }
        public double TotalPage { get; set; }
    }
}
