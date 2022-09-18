using System;
using System.Collections.Generic;
using System.ComponentModel.DataAnnotations;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace Unilink.Data.Dto.Post
{
    public class InsertPostDTO
    {
        [Required(ErrorMessage = "Tittle must not be null")]
        public string Title
        {
            get; set;
        }
        [Required(ErrorMessage = "Content must not be null")]
        public string Content
        {
            get; set;
        }
        [Required(ErrorMessage = "Topic id must not be null")]
        public Guid TopicId
        {
            get; set;
        }
        [Required(ErrorMessage = "CreateBy must not be null")]
        public Guid CreateBy
        {
            get; set;
        }
    }
}
