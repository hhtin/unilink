using Microsoft.Data.SqlClient;
using Microsoft.EntityFrameworkCore;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using Unilink.Data.Config;

namespace Unilink.Data.Repository.Impl
{
    public class GenericRepository<T> : IGenericRepository<T> where T : class
    {
        private readonly DbSet<T> entities;
        private readonly ApplicationDbContext _DBContext;
        public GenericRepository(ApplicationDbContext DBContext)
        {
            this._DBContext = DBContext;
            entities = _DBContext.Set<T>();
        }
        public ApplicationDbContext GetDBContext() => _DBContext;
        public DbSet<T> GetEntity() => entities;
        public async Task<IEnumerable<T>> GetAllAsync()
        {
            try
            {
                return await entities.ToListAsync();
            } catch (Exception e)
            {
                if (_DBContext != null)
                {
                    await _DBContext.DisposeAsync();
                }
                throw new Exception(e.Message);
            }
        }

        public async Task<T> GetAsync(Guid id)
        {
            try
            {
                return await entities.FindAsync(id);
            } catch (Exception e)
            {
                if (_DBContext != null)
                {
                    await _DBContext.DisposeAsync();
                }
                throw new Exception(e.Message);
            }
        }

        public async Task<int> InsertAsync(T entity)
        {
            try
            {
                int count = 0;
                await  entities.AddAsync(entity);
                count =  await _DBContext.SaveChangesAsync();
                return count;
            }
            catch (Exception e)
            {
                if (_DBContext != null)
                {
                    await _DBContext.DisposeAsync();
                }
                throw new Exception(e.Message);
            }
        }

        public async Task<int> Update(T entity)
        {
            try
            {
                int count = 0;
                entities.Update(entity);
                count = await _DBContext.SaveChangesAsync();
                return count;
            }
            catch (Exception e)
            {
                if (_DBContext != null)
                {
                    await _DBContext.DisposeAsync();
                }
                throw new Exception(e.Message);
            }
        }

        public async Task<int> Delete(Guid id)
        {
            try
            {
                int count = 0;
                entities.Remove(entities.Find(id));
                count = await _DBContext.SaveChangesAsync();
                return count;
            }
             catch (Exception e)
            {
                if (_DBContext != null)
                {
                    await _DBContext.DisposeAsync();
                }
                throw new Exception(e.Message);
            }
        }
    }
}