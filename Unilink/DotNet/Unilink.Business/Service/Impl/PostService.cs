using EntityFrameworkPaginateCore;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using Unilink.Business.Utils;
using Unilink.Data.Dto.Pagination;
using Unilink.Data.Dto.Post;
using Unilink.Data.Entity;
using Unilink.Data.Repository;
using Unilink.Data.Repository.Impl;

namespace Unilink.Business.Service.Impl
{
    public class PostService : IPostService
    {
        private IPostRepository _postRepository;
        private IMemberRepository _memberRepository;

        public PostService(IPostRepository postRepository, IMemberRepository memberRepository)
        {
            this._postRepository = postRepository;
            this._memberRepository = memberRepository;
        }

        public async Task<bool> DeleteAsync(Guid id)
        {
            try
            {
                Post existedPost = await _postRepository.GetAsync(id);
                if (existedPost != null && existedPost.Status != 0)
                {
                    existedPost.Status = 0;
                    int count = await _postRepository.Update(existedPost);
                    return true;
                }
                return false;
            }
            catch (Exception e)
            {
                throw new Exception(e.Message);
            }
        }

        public async Task<PostDTO> GetAsync(Guid id)
        {
            try
            {
                Post existedPost = await _postRepository.GetAsync(id);
                if (existedPost != null && existedPost.Status != 0)
                {
                    return MapperConfig.GetMapper().Map<PostDTO>(existedPost);
                }
                return null;
            }
            catch (Exception e)
            {
                throw new Exception(e.Message);
            }
        }

        public async Task<PostDTO> InsertAsync(InsertPostDTO insertPostDTO)
        {
            try
            {
                Member member = await _memberRepository.GetAsync(insertPostDTO.CreateBy);
                if (member == null)
                {
                
                    return null;
                }
            
                Post post = MapperConfig.GetMapper().Map<Post>(insertPostDTO);
                post.Id = Guid.NewGuid();
                post.Status = 1;
                post.CreateDate = DateTime.Now;
                post.UpdateDate = DateTime.Now;
            
                int count = await _postRepository.InsertAsync(post);
                if (count == 0) return null;
                return MapperConfig.GetMapper().Map<PostDTO>(post);
            }
            catch (Exception e)
            {
                throw new Exception(e.Message);
            }
        }

        public async Task<PaginationResponseDTO<PostDTO>> Search(String topic, PaginationRequestDTO searchDTO)
        {
            try
            {
                PaginationRequestDTO validatedPagination = new PaginationUtils().validatePaginationParam(searchDTO, "Post");
                Page<Post> postPage = await _postRepository.searchPagination(topic,validatedPagination);
                PaginationResponseDTO<PostDTO> pagination = new PaginationResponseDTO<PostDTO>();
                if (postPage != null)
                {
                    List<PostDTO> dataList = new List<PostDTO>();
                    postPage.Results.ToList().ForEach(e => dataList.Add(MapperConfig.GetMapper().Map<PostDTO>(e)));
                    pagination.Data = dataList;
                    pagination.PageIndex = validatedPagination.curPage;
                    pagination.Limit = postPage.PageSize;
                    pagination.totalPage = postPage.PageCount;
                    pagination.sortBy = validatedPagination.sortBy;
                    pagination.sortType = validatedPagination.sortType;
                    pagination.searchText = searchDTO.searchText;
                    return pagination;
                }
                return null;
            }
            catch (Exception e)
            {
                throw new Exception(e.Message);
            }
        }

        public async Task<PostDTO> UpdateAsync(UpdatePostDTO dto)
        {
            try
            {
                Post existedPost = await _postRepository.GetAsync(dto.Id);
                if (existedPost == null || existedPost.Status != 1) 
                {
                    return null;
                }

                existedPost.UpdateDate = DateTime.Now;
                existedPost.Title = dto.Title;
                existedPost.Content = dto.Content;

                int count = await _postRepository.Update(existedPost);

                if (count == 0)
                {
                    return null;
                }
                return MapperConfig.GetMapper().Map<PostDTO>(existedPost);
            }
            catch (Exception e)
            {
                throw new Exception(e.Message);
            }
        }
        
    }
}
