using System;
using System.Collections.Generic;
using System.ComponentModel.DataAnnotations;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace Unilink.Data.Dto.Comment
{
    public class InsertCommentDTO
    {
        [Required]
        public string Content
        {
            get; set;
        }
        public Guid? ParentId
        {
            get; set;
        }
        [Required]
        public Guid PostId
        {
            get; set;
        }
        [Required]
        public Guid CreateBy
        {
            get; set;
        }

    }
}
