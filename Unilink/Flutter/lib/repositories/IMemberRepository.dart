import 'package:image_picker/image_picker.dart';
import 'package:unilink_flutter_app/models/member_model.dart';
import 'package:unilink_flutter_app/models/party_request_model.dart';
import 'package:unilink_flutter_app/repositories/GenericRepository.dart';
import 'package:unilink_flutter_app/view_model/member_view_model.dart';

abstract class IMemberRepository extends GenericRepository<Member> {
  Future<dynamic> getInfoMember(String id);
  Future<String> getIdentifier();
  Future<dynamic> updateMember(Member member, List<String> majorIds,
      List<String> skillIds, XFile avatar);
  Future<bool> insertMember(MemberViewModel member, String devicetoken);
  Future<dynamic> requestForParty(String memberId, String partyId);
  Future<List<Member>> getMemberInParty(String partyId);
  Future<bool> checkIsExistedEmail(String email);

  Future<List<PartyReq>> getListRequestByMemberId(String memberId, String type);

  Future<dynamic> rejectReqByMember(String memberId, String partyId);

  Future<List<Member>> filterMember(String majorId, String gender,
      String startAge, String endAge, List<String> skillList, String address);

  Future<dynamic> memberRejectInvitation(String memberId, String partyId);
  Future<List<PartyReq>> memberGetListInvitation(String memberId, String type);

  Future<dynamic> memberAcceptInvitation(String memberId, String partyId);
}
