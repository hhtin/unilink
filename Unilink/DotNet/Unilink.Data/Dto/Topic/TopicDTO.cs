using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace Unilink.Data.Dto.Topic
{
    public class TopicDTO
    {
        public Guid Id
        {
            get; set;
        }

        public string Title
        {
            get; set;
        }

        public string Description
        {
            get; set;
        }

        public DateTime CreateDate
        {
            get; set;
        }

        public DateTime UpdateDate
        {
            get; set;
        }


        public Guid PartyId
        {
            get; set;
        }

        public Guid AttachedPost
        {
            get; set;
        }


        public bool Status
        {
            get; set;
        }
    }
}
