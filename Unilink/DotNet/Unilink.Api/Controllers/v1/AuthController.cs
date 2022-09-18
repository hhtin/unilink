using Microsoft.AspNetCore.Mvc;
using Microsoft.Extensions.Caching.Distributed;
using Microsoft.Extensions.Configuration;
using Newtonsoft.Json;
using System;
using System.ComponentModel.DataAnnotations;
using System.Text;
using System.Threading.Tasks;
using Unilink.Api.Config;
using Unilink.Business.Service;
using Unilink.Data.Dto.FirebaseMessageToken;
using Unilink.Data.Dto.Member;
using Unilink.Data.Entity;
using static Unilink.Api.Config.ResponseFormat;

namespace Unilink.Api.Controllers
{
    [Route("api/v{version:apiVersion}/auth")]
    [ApiController]
    [ApiVersion("1.0")]
    public class AuthController : ControllerBase
    {
        private IConfiguration _config;
        private IMemberService _memberService;
        private IFirebaseMessageTokenService _firebaseMessageTokenService;
        private readonly IDistributedCache _cache;
        public AuthController(IConfiguration config,IMemberService memberService, IDistributedCache cache,
            IFirebaseMessageTokenService firebaseMessageTokenService)
        {
            _config = config;
            _memberService = memberService;
            _cache = cache;
            _firebaseMessageTokenService = firebaseMessageTokenService;
        }
        [HttpGet("{email}")]
        public async Task<IActionResult> LoginByEmail([EmailAddress] string email, string deviceToken = "")
        {
            Member member;
            try
            {
                var cacheKey = $"auth/{email}/member";
                string serializedMember;
                var redisMember = await _cache.GetAsync(cacheKey);
                if (redisMember != null)
                {
                    serializedMember = Encoding.UTF8.GetString(redisMember);
                    member = JsonConvert.DeserializeObject<Member>(serializedMember);
                } else
                {
                    member = await _memberService.LoginByEmail(email);
                    if (member != null && member.Status)
                    {
                        serializedMember = JsonConvert.SerializeObject(member);
                        redisMember = Encoding.UTF8.GetBytes(serializedMember);
                        var options = new DistributedCacheEntryOptions()
                            .SetAbsoluteExpiration(DateTime.Now.AddMinutes(10))
                            .SetSlidingExpiration(TimeSpan.FromMinutes(5));
                        await _cache.SetAsync(cacheKey, redisMember, options);
                    }
                }
            } catch (Exception e)
            {
                return ErrorResponse(e.Message);
            }
            if (member != null && member.Status)
            {
                if (member.Status)
                {
                    FirebaseMessageTokenDTO messageToken = await _firebaseMessageTokenService.GetByMemberId(member.Id);
                    if (messageToken == null)
                    {
                        if (!deviceToken.Equals("")) {
                            InsertMessageToken insertToken = new InsertMessageToken()
                            {
                                token = deviceToken,
                                memberId = member.Id
                            };
                            await _firebaseMessageTokenService.CreateToken(insertToken);
                        }
                    } else
                    {
                        if (!deviceToken.Equals(""))
                        {
                            messageToken.token = deviceToken;
                            await _firebaseMessageTokenService.UpdateToken(messageToken);
                        }
                    }
                    string token = JwtConfig.GenerateJSONWebToken(member, _config);
                    return JsonResponse("Authenticated successfully", 200, new { token = token, role = member.Role.Name });
                }
                return JsonResponse("Authenticated faild", 200, new { details = "Your account can be disabled !"});
            }
            else
            {
                return JsonResponse("Not found user with following email ", 400 , null);
            }
        }
        [HttpPost]
        public async Task<IActionResult> Create([FromForm] InsertMemberDTO insertMemberDTO)
        {
            string host = _config["Host"];
            Console.WriteLine(insertMemberDTO.Image);
            Member member;
            try
            {
                member = await _memberService.InsertAsync(insertMemberDTO, host);
            }
            catch (Exception e)
            {
                return ErrorResponse(e.Message);
            }
            string token = JwtConfig.GenerateJSONWebToken(member, _config);
            return JsonResponse("Created successfully", 201, new { token = token });
        }
    }
}
