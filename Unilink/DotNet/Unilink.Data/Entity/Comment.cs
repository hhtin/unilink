using System;
using System.Collections.Generic;
using System.ComponentModel.DataAnnotations;
using System.ComponentModel.DataAnnotations.Schema;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace Unilink.Data.Entity
{
    [Table("Comment")]
    public class Comment
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
        public DateTime CreateDate
        {
            get; set;
        }

        [Required]
        public DateTime UpdateDate
        {
            get; set;
        }

        public Guid CreateBy
        {
            get; set;
        }

        [Required]
        public bool Status
        {
            get; set;
        }
    }
}
