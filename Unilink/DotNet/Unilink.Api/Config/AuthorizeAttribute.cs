using Microsoft.AspNetCore.Authorization;
using Microsoft.AspNetCore.Http;
using Microsoft.AspNetCore.Mvc;
using Microsoft.AspNetCore.Mvc.Filters;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Reflection;
using System.Threading.Tasks;
using static Unilink.Api.Config.ResponseFormat;

namespace Unilink.Api.Config
{
    [AttributeUsage(AttributeTargets.Class | AttributeTargets.Method)]
    public class CustomAuthorization : Attribute, IAuthorizationFilter
    {
        public string Roles;
        public void OnAuthorization(AuthorizationFilterContext context)
        {
            var account = context.HttpContext.Items["User"];
            if (account != null)
            {
                string role = account?.GetType().GetProperty("role")?.GetValue(account, null).ToString();
                string[] split = Roles.Split(",");
                bool isValid = false;
                foreach(string tmp in split) {
                    if (tmp.Trim().ToLower().Equals(role.ToLower()))
                    {
                        isValid = true;
                        break;
                    }
                }
                if (!isValid)
                {
                    context.Result = JsonResponse("You don't have permission to access", 401, null);
                }
            }
            
        }
    }
}
