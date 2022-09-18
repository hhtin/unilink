using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using System.ComponentModel.DataAnnotations;
using System.ComponentModel.DataAnnotations.Schema;

namespace Unilink.Data.Entity
{
    [Table("Post")]
    public class Post
    {
        [Key]
        public Guid Id
        {
            get; set;
        }
        [Required]
        public string Title
        {
            get; set;
        }
        [Required]
        public string Content
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
        [Required]
        public Guid TopicId
        {
            get; set;
        }
        [Required]
        public Guid CreateBy
        {
            get; set;
        }
        [Required]
        public int Status
        {
            get; set;
        }
    }
}
