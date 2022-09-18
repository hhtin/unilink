import 'package:image_picker/image_picker.dart';
import 'package:unilink_flutter_app/models/party_create_model.dart';
import 'package:unilink_flutter_app/models/party_model.dart';
import 'package:unilink_flutter_app/models/party_request_model.dart';
import 'package:unilink_flutter_app/repositories/GenericRepository.dart';

abstract class IPartyRepository extends GenericRepository<Party> {
  Future<List<Party>> getByMemberId(String memberId);

  Future<List<PartyReq>> getListRequestByPartyId(String id, String type);

  Future<dynamic> acceptReq(String partyId, String memberId);

  Future<dynamic> rejectReq(String partyId, String memberId);
  Future<List<Party>> getParties(int pageSize, int curPage);

  Future<Party> getPartyById(String partyId);

  Future<String> createParty(PartyCreate partyCreate, XFile avatarParty);
  Future<Party> updateParty(PartyCreate partyCreate, XFile avatarParty);

  Future<List<Party>> getListReq(String memberId);

  Future<Party> createPartyForMessage(PartyCreate partyCreate, String partyId);
  Future<String> getPartyForMessage(String partyId);

  Future<dynamic> findParties(String majorId, List<String> listSkill,
      int maximum, String address, bool isNear);
  Future<dynamic> quitParty(String partyId, String memberId);

  Future<dynamic> invitationMember(String partyId, String memberId);
  Future<dynamic> partyRejectInvitation(String partyId, String memberId);
  Future<List<PartyReq>> partyGetListInvitation(String partyId, String type);
}
