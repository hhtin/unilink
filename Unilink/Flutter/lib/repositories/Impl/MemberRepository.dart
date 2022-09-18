import 'package:image_picker/image_picker.dart';
import 'package:unilink_flutter_app/models/member_model.dart';
import 'package:unilink_flutter_app/models/party_request_model.dart';
import 'package:unilink_flutter_app/repositories/IMemberRepository.dart';
import 'package:unilink_flutter_app/service/member_service.dart';
import 'package:unilink_flutter_app/view_model/member_view_model.dart';

class MemberRepository implements IMemberRepository {
  MemberService service = MemberService();
  @override
  Future<List<Member>> getAll() async {
    return await service.getAll();
  }

  @override
  Future<dynamic> getInfoMember(String id) async {
    try {
      return await service.getInfoMember(id);
    } catch (e) {
      throw Exception(e.toString());
    }
  }

  @override
  Future<String> getIdentifier() async {
    try {
      return await service.getIdentifier();
    } catch (e) {
      throw Exception(e.toString());
    }
  }

  @override
  Future<bool> insertMember(MemberViewModel member, String deviceToken) async {
    try {
      return await service.insertMember(member, deviceToken);
    } catch (e) {
      throw Exception(e.toString());
    }
  }

  @override
  Future<dynamic> updateMember(Member member, List<String> majorIds,
      List<String> skillIds, XFile avatar) async {
    try {
      return await service.updateMember(member, majorIds, skillIds, avatar);
    } catch (e) {
      throw Exception(e.toString());
    }
  }

  Future requestForParty(String memberId, String partyId) async {
    try {
      await service.requestForParty(memberId, partyId);
      return true;
    } catch (e) {
      if (e.toString() == "Exception: Exception: Unable to perform request") {
        return false;
      } else {
        throw Exception(e.toString());
      }
    }
  }

  @override
  Future<List<Member>> getMemberInParty(String partyId) async {
    try {
      print(partyId);
      return await service.getMemberInParty(partyId);
    } catch (e) {
      throw Exception(e.toString());
    }
  }

  Future<bool> checkIsExistedEmail(String email) async {
    try {
      return await service.checkIsExistedEmail(email);
    } catch (e) {
      throw Exception(e.toString());
    }
  }

  Future<List<PartyReq>> getListRequestByMemberId(
      String memberId, String type) async {
    try {
      return await service.getListRequestByMemberId(memberId, type);
    } catch (e) {
      throw Exception(e.toString());
    }
  }

  Future<dynamic> rejectReqByMember(String memberId, String partyId) async {
    try {
      return await service.rejectReqByMember(memberId, partyId);
    } catch (e) {
      throw Exception(e.toString());
    }
  }

  Future<List<Member>> filterMember(
      String majorId,
      String gender,
      String startAge,
      String endAge,
      List<String> skillList,
      String address) async {
    try {
      return await service.filterMember(
          majorId, gender, startAge, endAge, skillList, address);
    } catch (e) {
      throw Exception(e.toString());
    }
  }

  Future<dynamic> memberRejectInvitation(
      String memberId, String partyId) async {
    try {
      await service.memberRejectInvitation(memberId, partyId);
      return true;
    } catch (e) {
      if (e.toString() == "Exception: Exception: Unable to perform request") {
        return false;
      } else {
        throw Exception(e.toString());
      }
    }
  }

  Future<List<PartyReq>> memberGetListInvitation(
      String memberId, String type) async {
    try {
      return await service.memberGetListInvitation(memberId, type);
    } catch (e) {
      throw Exception(e.toString());
    }
  }

  Future<dynamic> memberAcceptInvitation(
      String memberId, String partyId) async {
    try {
      await service.memberAcceptInvitation(memberId, partyId);
      return true;
    } catch (e) {
      if (e.toString() == "Exception: Exception: Unable to perform request") {
        return false;
      } else {
        throw Exception(e.toString());
      }
    }
  }
}
