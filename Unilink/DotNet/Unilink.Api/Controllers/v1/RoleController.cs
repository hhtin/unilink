using Microsoft.AspNetCore.Mvc;
using System;
using System.Threading.Tasks;
using Unilink.Business.Service;
using Unilink.Business.Utils;
using Unilink.Data.Dto.Role;
using Unilink.Data.Entity;
using static Unilink.Api.Config.ResponseFormat;
namespace Unilink.Api.Controllers
{
    [Route("api/v{version:apiVersion}/roles")]
    [ApiController]
    [ApiVersion("1.0")]
    public class RoleController:ControllerBase
    {
        private readonly IRoleService _roleService;
        public RoleController(IRoleService _roleService)
        {
            this._roleService = _roleService;
        }

        [HttpGet]
        public async Task<IActionResult> GetRoles(bool isActive, bool isGetAll = true)
        {
            try
            {
                object roleList;
                if (!isGetAll)
                {
                    roleList = await _roleService.getAllAsyncByStatus(isActive);
                }
                else
                {
                    roleList = await _roleService.getAllAsync();
                }
                return JsonResponse("Get successfully !", 200, roleList);
            } catch(Exception e)
            {
                return ErrorResponse(e.Message);
            }
        }
        [HttpGet("{id}")]
        public async Task<IActionResult> GetRole(Guid id)
        {
            try
            {
                var role = await _roleService.GetAsync(id);
                return JsonResponse("Get successfully", 200, role);
            }
            catch (Exception e)
            {
                return ErrorResponse(e.Message);
            }
        }

        [HttpDelete("{id}")]
        public async Task<IActionResult> DeleteRole(Guid id)
        {
            try
            {
                await _roleService.Delete(id); 
                return JsonResponse("Delete successfully", 200, null);
            }
            catch (Exception e)
            {
                if (e.Message.Contains("not found")) return JsonResponse(e.Message, 400, null);
                return ErrorResponse(e.Message);
            }
        }
        [HttpPut]
        public async Task<IActionResult> Update(RoleDTO dto)
        {
            try
            {
                await _roleService.Update(dto);
                return JsonResponse("Update successfully", 200, null);
            }
            catch (Exception e)
            {
                if (e.Message.Contains("not found")) return JsonResponse(e.Message, 400, null);
                return ErrorResponse(e.Message);
            }
        }
        [HttpPost]
        public async Task<IActionResult> Create(InsertRoleDTO dto)
        {
            try
            {
                await _roleService.InsertAsync(dto);
                return JsonResponse("Create successfully", 200, null);
            }
            catch (Exception e)
            {
                return ErrorResponse(e.Message);
            }
        }
    }
}
