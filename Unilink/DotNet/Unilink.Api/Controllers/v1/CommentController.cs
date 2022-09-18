using Microsoft.AspNetCore.Mvc;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Threading.Tasks;
using Unilink.Business.Service;
using Unilink.Data.Dto;
using Unilink.Data.Dto.Comment;
using static Unilink.Api.Config.ResponseFormat;

namespace Unilink.Api.Controllers.v1
{
    [Route("api/v{version:apiVersion}/comments")]
    [ApiController]
    [ApiVersion("1.0")]
    public class CommentController
    {
        private readonly ICommentService _commentService;
        public CommentController(ICommentService commentService)
        {
            this._commentService = commentService;
        }

        [HttpGet("{id}")]
        public async Task<IActionResult> GetById(Guid id)
        {
            try
            {
                CommentDTO comment = await _commentService.GetAsync(id);
                if (comment == null)
                    return JsonResponse("Search fail, try again !", 400, null);
                return JsonResponse("Search success !", 200, comment);

            }
            catch (Exception e)
            {
                return ErrorResponse(e.Message);
            }

        }

        [HttpPost]
        public async Task<IActionResult> Create(InsertCommentDTO dto)
        {
            try
            {
                CommentDTO insertedComment = await _commentService.InsertAsync(dto);
                if (insertedComment == null)
                    return JsonResponse("Insert failed, try again !", 400, null);
                return JsonResponse("Insert successfully !", 201, insertedComment);

            }
            catch (Exception e)
            {
                return ErrorResponse(e.Message);
            }
            
        }

        [HttpPut]
        public async Task<IActionResult> Update(UpdateCommentDTO dto)
        {
            try
            {
                CommentDTO updatedComment = await _commentService.UpdateAsync(dto);
                if (updatedComment == null)
                    return JsonResponse("Update failed, try again !", 400, null);
                return JsonResponse("Update successfully !", 200, updatedComment);

            }
            catch (Exception e)
            {
                return ErrorResponse(e.Message);
            }

        }

        [HttpDelete("{id}")]
        public async Task<IActionResult> DeleteById(Guid id)
        {
            try
            {
                bool checkDelete = await _commentService.DeleteAsync(id);
                if (checkDelete == false)
                    return JsonResponse("Delete fail, try again !", 400, null);
                return JsonResponse("Delete success !", 200, null);

            }
            catch (Exception e)
            {
                return ErrorResponse(e.Message);
            }

        }
    }
}
