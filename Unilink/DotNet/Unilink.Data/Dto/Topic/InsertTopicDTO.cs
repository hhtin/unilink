using System;
using System.Collections.Generic;
using System.ComponentModel.DataAnnotations;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace Unilink.Data.Dto.Topic
{
    public class InsertTopicDTO
    {

        [Required]
        public string Title
        {
            get; set;
        }

        public string Description
        {
            get; set;
        }

        [Required]
        public Guid PartyId
        {
            get; set;
        }

    }
}
