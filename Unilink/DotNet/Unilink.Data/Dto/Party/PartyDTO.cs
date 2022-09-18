using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
namespace Unilink.Data.Dto.Party
{
    public class PartyDTO
    {
        public Guid Id
        {
            get; set;
        }
        public string Name
        {
            get; set;
        }
        public string Description
        {
            get; set;
        }
        public string Image
        {
            get; set;
        }
        public int Maximum
        {
            get; set;
        }
        public DateTime CreateDate
        {
            get; set;
        }
        public Guid MajorId
        {
            get; set;
        }
        public bool IsApprovedPost
        {
            get; set;
        }
        public bool Status
        {
            get; set;
        }
    }
}
