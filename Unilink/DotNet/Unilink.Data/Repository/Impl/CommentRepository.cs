using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using Unilink.Data.Config;
using Unilink.Data.Entity;

namespace Unilink.Data.Repository.Impl
{
    public class CommentRepository: GenericRepository<Comment>, ICommentRepository
    {
        private readonly ApplicationDbContext _DBContext;
        public CommentRepository(ApplicationDbContext context) : base(context)
        {
            this._DBContext = context;
        }
    }
}
