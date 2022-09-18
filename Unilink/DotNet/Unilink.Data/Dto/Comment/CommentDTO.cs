using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace Unilink.Data.Dto
{
    public class CommentDTO
    {
        public Guid Id
        {
            get; set;
        }

        public string Content
        {
            get; set;
        }

        public Guid? ParentId
        {
            get; set;
        }
        public Guid PostId
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

        public Guid CreateBy
        {
            get; set;
        }

        public bool Status
        {
            get; set;
        }
    }
}
