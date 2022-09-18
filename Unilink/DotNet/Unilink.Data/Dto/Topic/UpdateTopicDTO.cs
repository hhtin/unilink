using System;
using System.Collections.Generic;
using System.ComponentModel.DataAnnotations;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace Unilink.Data.Dto.Topic
{
    public class UpdateTopicDTO
    {
        [Required]
        public Guid Id
        {
            get; set;
        }

        [Required]
        public string Title
        {
            get; set;
        }

        public string Description
        {
            get; set;
        }
    }
}
