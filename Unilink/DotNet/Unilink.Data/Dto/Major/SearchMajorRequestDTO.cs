using System;
using System.Collections.Generic;
using System.ComponentModel.DataAnnotations;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace Unilink.Data.Dto.Major
{
    public class SearchMajorRequestDTO
    {
        public int Page { get; set; }
        public int Limit { get; set; }
        public string Name { get; set; }
        public bool IsAcending { get; set; }
    }
}
