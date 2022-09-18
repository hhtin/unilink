using Microsoft.AspNetCore.Mvc;
using Microsoft.Extensions.Configuration;
using System;
using System.ComponentModel.DataAnnotations;
using System.Threading.Tasks;
using Unilink.Business.utils;
using Unilink.Business.Utils;
using Unilink.Data.Dto.Mail;
using static Unilink.Api.Config.ResponseFormat;

namespace Unilink.Api.Controllers
{
    [Route("api/v{version:apiVersion}/mails")]
    [ApiController]
    [ApiVersion("1.0")]
    public class MailController : ControllerBase
    {
        private IConfiguration _config;
        public MailController(IConfiguration config)
        {
            _config = config;
        }
        [HttpGet("{email}")]
        public IActionResult SendMailSignIn([EmailAddress] string email, [Required] string name)
        {

            MailDTO mailModel = new MailDTO()
            {
                Email = email,
                Name = name,
                FromEmailUser = _config["Email-User"],
                FromEmailPassword =_config["Email-Password"]
            };
            try
            {
                MailUtil.SendMail("SIGN_UP", mailModel);
            }
            catch (Exception e)
            {
                return ErrorResponse(e.Message);
            }
            return JsonResponse("Send signin mail successfully !", 200, null);
        }
        [HttpGet] 
        public async Task<IActionResult> test(String token)
        {
            try
            {
                string result = await FirebaseMessageUtil.sendMessageToOne(token, "Unilink", "Vinh test");
                return JsonResponse("Send signin mail successfully !", 200, result);
            } catch (Exception e)
            {
                return ErrorResponse(e.Message);
            }
        }
    }
}
