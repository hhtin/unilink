using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace Unilink.Data.Dto.Mail
{
    public class MailDTO
    {
        public string Name { get; set; }
        public string Content { get; set; }
        public string Email { get; set; }
        public string FromEmailUser { get; set; }
        public string FromEmailPassword { get; set; }
    }
}
