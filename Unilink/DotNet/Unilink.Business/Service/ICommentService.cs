using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using Unilink.Data.Dto;
using Unilink.Data.Dto.Comment;

namespace Unilink.Business.Service
{
    public interface ICommentService
    {
        public Task<CommentDTO> InsertAsync(InsertCommentDTO dto);

        public Task<CommentDTO> UpdateAsync(UpdateCommentDTO dto);

        public Task<CommentDTO> GetAsync(Guid Id);

        public Task<bool> DeleteAsync(Guid Id);
    }
}
