using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using Unilink.Business.Utils;
using Unilink.Data.Dto;
using Unilink.Data.Dto.Comment;
using Unilink.Data.Entity;
using Unilink.Data.Repository;
using Unilink.Data.Repository.Impl;

namespace Unilink.Business.Service.Impl
{
    public class CommentService : ICommentService
    {
        private ICommentRepository _commentRepository;
        private IMemberRepository _memberRepository;
        private IPostRepository _postRepository;

        public CommentService(ICommentRepository commentRepository, IMemberRepository memberRepository, IPostRepository postRepository)
        {
            this._commentRepository = commentRepository;
            this._memberRepository = memberRepository;
            this._postRepository = postRepository;
        }

        

        public async Task<CommentDTO> GetAsync(Guid Id)
        {
            try
            { 
                Comment comment = await _commentRepository.GetAsync(Id);
                if (comment == null)
                {
                    return null;
                }
                return MapperConfig.GetMapper().Map<CommentDTO>(comment);
            }
            catch (Exception e)
            {
                throw new Exception(e.Message);
            }
        }

        public async Task<CommentDTO> InsertAsync(InsertCommentDTO dto)
        {
            try
            {

                Member member = await _memberRepository.GetAsync(dto.CreateBy);
                if (member == null)
                {
                    return null;
                }
                Post post = await _postRepository.GetAsync(dto.PostId);
                if (post == null || post.Status == 0)
                {
                    return null;
                }
                if (dto.ParentId != null)
                {
                    Guid existedParentId = (Guid)dto.ParentId;
                    Comment commentParent = await _commentRepository.GetAsync(existedParentId);
                    if (commentParent == null)
                    {
                        return null;
                    }
                }


                Comment insertedComment = MapperConfig.GetMapper().Map<Comment>(dto);
                insertedComment.Id = Guid.NewGuid();
                insertedComment.CreateDate = DateTime.Now;
                insertedComment.UpdateDate = DateTime.Now;
                insertedComment.Status = true;
                if (dto.ParentId == null)
                {
                    insertedComment.ParentId = (Guid?)null;
                }

                int count = await _commentRepository.InsertAsync(insertedComment);

                if (count == 0)
                {
                    return null;
                }

                return MapperConfig.GetMapper().Map<CommentDTO>(insertedComment);
            }
            catch (Exception e)
            {
                throw new Exception(e.Message);
            }
        }

        public async Task<CommentDTO> UpdateAsync(UpdateCommentDTO dto)
        {
            try
            {
                Comment existedComment = await _commentRepository.GetAsync(dto.Id);
                if (existedComment == null || existedComment.Status == false)
                {
                    return null;
                }
                existedComment.Content = dto.Content;
                existedComment.UpdateDate = DateTime.Now;

                int count = await _commentRepository.Update(existedComment);

                if (count == 0)
                {
                    return null;
                }

                return MapperConfig.GetMapper().Map<CommentDTO>(existedComment);
            }
            catch (Exception e)
            {
                throw new Exception(e.Message);

            }
        }

        public async Task<bool> DeleteAsync(Guid Id)
        {
            try
            {
                Comment comment = await _commentRepository.GetAsync(Id);
                if (comment == null)
                {
                    return false;
                }
                comment.Status = false;
                int count = await _commentRepository.Update(comment);
                if(count <= 0)
                {
                    return false;
                }
                return true;
            }
            catch (Exception e)
            {
                throw new Exception(e.Message);
            }
        }
    }
}
  