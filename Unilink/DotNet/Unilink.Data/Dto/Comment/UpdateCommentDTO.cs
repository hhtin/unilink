using System;
using System.Collections.Generic;
using System.ComponentModel.DataAnnotations;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace Unilink.Data.Dto.Comment
{
    public class UpdateCommentDTO
    {
        [Required]
        public Guid Id
        {
            get; set;
        }
        [Required]
        public string Content
        {
            get; set;
        }
    }
}
