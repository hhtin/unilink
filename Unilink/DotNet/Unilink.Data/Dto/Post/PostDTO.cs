using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace Unilink.Data.Dto.Post
{
    public class PostDTO
    {
        public Guid Id
        {
            get; set;
        }
        public string Title
        {
            get; set;
        }
        public string Content
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
        public Guid TopicId
        {
            get; set;
        }
        public Guid CreateBy
        {
            get; set;
        }
        public int Status
        {
            get; set;
        }
    }
}
