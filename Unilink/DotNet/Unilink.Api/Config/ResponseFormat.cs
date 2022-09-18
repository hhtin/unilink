using Microsoft.AspNetCore.Http;
using Microsoft.AspNetCore.Mvc;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Threading.Tasks;

namespace Unilink.Api.Config
{
    public static class ResponseFormat
    {
        public static JsonResult JsonResponse(string message, int statusCodes, Object data)
        {
            Object obj;
            if (data != null)
            {
                obj = new { Message = message, StatusCode = statusCodes, data = data };
            } else
            {
                obj = new { Message = message, StatusCode = statusCodes };
            }
            return new JsonResult(obj) { StatusCode = statusCodes };
        }
        public static JsonResult ErrorResponse(string detail)
        {
            return JsonResponse("Some errors occured !", 500, (detail != null && !detail.Equals("")) ? new { detail = detail } : null);
        }
    }
}
