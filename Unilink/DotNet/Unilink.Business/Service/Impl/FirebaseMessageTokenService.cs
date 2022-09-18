using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using Unilink.Business.Utils;
using Unilink.Data.Dto.FirebaseMessageToken;
using Unilink.Data.Entity;
using Unilink.Data.Repository;

namespace Unilink.Business.Service.Impl
{

    public class FirebaseMessageTokenService : IFirebaseMessageTokenService
    {
        private IFirebaseMessageTokenRepository _firebaseMessageTokenRepository;
        private IMemberRepository _memberRepository;
        public FirebaseMessageTokenService(IFirebaseMessageTokenRepository firebaseMessageTokenRepository, IMemberRepository memberRepository)
        {
            this._firebaseMessageTokenRepository = firebaseMessageTokenRepository;
            this._memberRepository = memberRepository;
        }

        public async Task<int> CreateToken(InsertMessageToken insertDTO)
        {
            try
            {
                Member member = await _memberRepository.GetAsync(insertDTO.memberId);
                if (member == null) throw new Exception("Not found member with following id !");
                FirebaseMessageToken FCMToken = MapperConfig.GetMapper().Map<FirebaseMessageToken>(insertDTO);
                FCMToken.status = true;
                Guid id = new Guid();
                FCMToken.tokenId = id;
                return await _firebaseMessageTokenRepository.InsertAsync(FCMToken);
            } catch (Exception e)
            {
                throw new Exception(e.Message);
            }
        }

        public async Task<FirebaseMessageTokenDTO> GetByMemberId(Guid memberId)
        {
            try
            {
                Member member = await _memberRepository.GetAsync(memberId);
                if (member == null) throw new Exception("Not found member with following id !");
                FirebaseMessageToken token = await _firebaseMessageTokenRepository.GetByMemberId(memberId);
                return MapperConfig.GetMapper().Map<FirebaseMessageTokenDTO>(token);
            } catch (Exception e)
            {
                throw new Exception(e.Message);
            }
        }

        public async Task<int> UpdateToken(FirebaseMessageTokenDTO dto)
        {
            try
            {
                Member member = await _memberRepository.GetAsync(dto.memberId);
                if (member == null) throw new Exception("Not found member with following id !");
                FirebaseMessageToken token = await _firebaseMessageTokenRepository.GetAsync(dto.tokenId);
                if (token == null) throw new Exception("Not found message token with following id !");
                FirebaseMessageToken FCMToken = MapperConfig.GetMapper().Map<FirebaseMessageToken>(dto);
                return await _firebaseMessageTokenRepository.Update(FCMToken);
            }
            catch (Exception e)
            {
                throw new Exception(e.Message);
            }
        }
    }
}
