using System;
using System.Collections.Generic;
using System.ComponentModel.DataAnnotations;
using System.ComponentModel.DataAnnotations.Schema;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace Unilink.Data.Entity
{
    [Table("Topic")]
    public class Topic
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
        [Required]
        public DateTime CreateDate
        {
            get; set;
        }

        public DateTime UpdateDate
        {
            get; set;
        }

        [Required]
        public Guid PartyId
        {
            get; set;
        }

        public Guid AttachedPost
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
