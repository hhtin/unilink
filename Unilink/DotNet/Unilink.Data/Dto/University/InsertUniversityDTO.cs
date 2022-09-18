using System;
using System.Collections.Generic;
using System.ComponentModel.DataAnnotations;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace Unilink.Data.Dto.University
{
    public class InsertUniversityDTO
    {
        [Required]
        public string Name { get; set; }
        [Required]
        public string SortName { get; set; }
    }
}
