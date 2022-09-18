using System;
using System.Collections.Generic;
using System.ComponentModel.DataAnnotations;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace Unilink.Data.Dto.Post
{
    public class UpdatePostDTO
    {
        [Required(ErrorMessage = "Id must not be null")]
        public Guid Id
        {
            get; set;
        }
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
    }
}
