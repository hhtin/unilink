using Microsoft.AspNetCore.Http;
using Microsoft.Extensions.Configuration;
using Microsoft.IdentityModel.Tokens;
using System;
using System.Collections.Generic;
using System.IdentityModel.Tokens.Jwt;
using System.Linq;
using System.Text;
using System.Text.RegularExpressions;
using System.Threading.Tasks;
using Unilink.Business.Service;
using Unilink.Data.Entity;

namespace Unilink.Api.Config
{
    public class JWTMiddlewareConfig
    {
        private readonly RequestDelegate _next;
        private readonly IConfiguration _configuration;
        public JWTMiddlewareConfig(RequestDelegate next, IConfiguration configuration)
        {
            _next = next;
            _configuration = configuration;
        }
        public async Task Invoke(HttpContext context)
        {
            var token = context.Request.Headers["X-Unilink-Token"].FirstOrDefault()?.Split(" ").Last();
            if (token != null)
            {
                try
                {
                    AttachAccountToContext(context, token);
                    await _next(context);
                    return;
                }
                catch (Exception e)
                {
                    context.Response.StatusCode = StatusCodes.Status400BadRequest;
                    await context.Response.WriteAsJsonAsync(new { Message = e.Message, StatusCode = StatusCodes.Status400BadRequest });
                    return;
                }
                
            }
            string[] noTokenSpecificPath = { "auth", "members", "mails", "files","universities", "majors", "skills" };
            string[] regexSpecification = { "", "(email)?$", "", "", "", "","" };
            int index = 0;
            string api = context.Request.Path.ToString();
            Regex rgx;
            string path = noTokenSpecificPath.FirstOrDefault<string>((value) => {
                rgx = new Regex($"^/api/.*/{value}/?{regexSpecification[index]}");
                bool isMatch = rgx.IsMatch(api);
                index++;
                if (isMatch) {
                    if (value.Equals("members"))
                    {
                        if (api.EndsWith("email")) return true;
                        if (!context.Request.Method.ToLower().Equals("post")) return false;
                    }
                    if (value.Equals("universities") || value.Equals("majors") || value.Equals("skills"))
                    {
                        if (!context.Request.Method.ToLower().Equals("get")) return false;
                    }
                    return true;
                };
                return false;
            });
            if (path != null && !path.Equals(""))
            {
                await _next(context);
                return;
            }
            context.Response.StatusCode = StatusCodes.Status401Unauthorized;
            await context.Response.WriteAsJsonAsync(new { Message = "Unauthorized", StatusCode = StatusCodes.Status401Unauthorized });

        }
        private void AttachAccountToContext(HttpContext context, string token)
        {
            try
            {
                SecurityToken validatedToken = JwtConfig.ValidateJSONWebToken(token, _configuration);
                var jwtToken = (JwtSecurityToken)validatedToken;
                var accountId = jwtToken.Claims.First(x => x.Type == "id").Value;
                var role = jwtToken.Claims.First(x => x.Type == "role").Value;
                context.Items["User"] = new { id = accountId, role = role };
            } catch (Exception e)
            {
                throw new Exception(e.Message);
            }
           
        }
    }
}
