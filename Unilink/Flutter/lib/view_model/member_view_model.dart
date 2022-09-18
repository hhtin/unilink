import 'dart:typed_data';

import 'package:flutter/foundation.dart';
import 'package:image_picker/image_picker.dart';
import 'package:unilink_flutter_app/models/major.dart';
import 'package:unilink_flutter_app/models/member_model.dart';
import 'package:unilink_flutter_app/models/party_model.dart';
import 'package:unilink_flutter_app/models/party_request_model.dart';
import 'package:unilink_flutter_app/models/skill.dart';
import 'package:unilink_flutter_app/repositories/IPartyRepository.dart';
import 'package:unilink_flutter_app/repositories/Impl/MemberRepository.dart';
import 'package:unilink_flutter_app/service/member_service.dart';
import 'package:unilink_flutter_app/repositories/Impl/PartyRepository.dart';

class MemberListViewModel extends ChangeNotifier {
  final IPartyRepository _partyRepository = new PartyRepository();
  final MemberRepository _memberRepository = MemberRepository();
  String identifier;
  String partyId;
  String memberId;
  MemberViewModel member;
  MemberViewModel insertMember;
  List<MemberViewModel> memberList = [];
  List<MemberViewModel> listMemberReq = [];
  FilerMemberViewModel filterMemberVM;
  XFile avatarUpdate;

  Future<dynamic> setPartyId(String partyId) {
    this.partyId = partyId;
  }

  Future<dynamic> setMemberId(String memberId) {
    this.memberId = memberId;
  }

  Future<dynamic> setFilterMember(String majorId, String gender,
      String startAge, String endAge, List<String> skillList, String address) {
    this.filterMemberVM = new FilerMemberViewModel(
        majorId, gender, startAge, endAge, skillList, address);
  }

  Future<void> getMembers() async {
    try {
      List<Member> members = await _memberRepository.getAll();
      members.forEach((element) => memberList.add(MemberViewModel(element)));
      notifyListeners();
    } catch (e) {
      debugPrint(e.toString());
    }
  }

  Future<MemberViewModel> getInforCurrentMember() async {
    try {
      var data = await _memberRepository.getInfoMember(identifier);
      Member mem = Member.jsonFrom(data);
      member = new MemberViewModel(mem);
      member.majors.clear();
      (data["majors"] as List)
          .forEach((element) => member.majors.add(Major.jsonFrom(element)));
      //print("Major: ${member.majors}");
      member.skills.clear();
      (data["skills"] as List)
          .forEach((element) => member.skills.add(Skill.jsonFrom(element)));
      //print("Skill: ${member.skills}");
      notifyListeners();
      return member;
    } on Exception catch (e) {
      debugPrint(e.toString());
    }
  }

  Future<MemberViewModel> getInforMember(String id) async {
    try {
      var data = await _memberRepository.getInfoMember(id);
      Member mem = Member.jsonFrom(data);
      member = new MemberViewModel(mem);
      if (member.member.avatar == null) {
        member.member.avatar = "assets/icons/avatar-vinh.jpg";
      }

      member.majors.clear();
      (data["majors"] as List)
          .forEach((element) => member.majors.add(Major.jsonFrom(element)));
      //print("Major: ${member.majors}");
      member.skills.clear();
      (data["skills"] as List)
          .forEach((element) => member.skills.add(Skill.jsonFrom(element)));
      //print("Skill: ${member.skills}");
      notifyListeners();
      return member;
    } on Exception catch (e) {
      debugPrint(e.toString());
    }
  }

  Future<String> getIdentifier() async {
    try {
      identifier = await _memberRepository.getIdentifier();
      return identifier;
    } on Exception catch (e) {
      debugPrint(e.toString());
    }
  }

  Future<bool> registerAccount(String deviceToken) async {
    try {
      return await _memberRepository.insertMember(insertMember, deviceToken);
    } on Exception catch (e) {
      debugPrint(e.toString());
      return false;
    }
  }

  Future<void> updateMember(Member member, List<String> majorIds,
      List<String> skillIds, XFile avatar) async {
    try {
      await _memberRepository.updateMember(member, majorIds, skillIds, avatar);
    } on Exception catch (e) {
      debugPrint(e.toString());
    }
  }

  Future<bool> requestForParty(String partyId) async {
    try {
      if (await _memberRepository.requestForParty(identifier, partyId)) {
        return true;
      } else {
        return false;
      }
    } catch (e) {
      throw new Exception(e.toString());
    }
  }

  Future<bool> checkIsExistedEmail(String email) async {
    try {
      return await _memberRepository.checkIsExistedEmail(email);
    } on Exception catch (e) {
      debugPrint(e.toString());
    }
  }

  Future<List<MemberViewModel>> getListRequestById(
      String partyId, String type) async {
    try {
      List<PartyReq> partyReq =
          await _partyRepository.getListRequestByPartyId(partyId, type);
      listMemberReq.clear();
      for (int i = 0; i < partyReq.length; i++) {
        var data = await _memberRepository.getInfoMember(partyReq[i].memberId);
        Member mem = Member.jsonFrom(data);
        MemberViewModel member = MemberViewModel(mem);
        listMemberReq.add(member);
      }

      notifyListeners();
      return listMemberReq;
    } on Exception catch (e) {
      debugPrint(e.toString());
    }
  }

  Future<dynamic> rejectReqByMember(String memberId, String partyId) async {
    try {
      return await _memberRepository.rejectReqByMember(memberId, partyId);
    } on Exception catch (e) {
      debugPrint(e.toString());
    }
  }

  Future<List<MemberViewModel>> filterMember(
      String majorId,
      String gender,
      String startAge,
      String endAge,
      List<String> skillList,
      String address) async {
    try {
      if (gender == "Nam") {
        gender = "1";
      } else {
        gender = "0";
      }
      if (startAge == null || startAge.isEmpty) {
        startAge = "0";
      }
      if (endAge == null || endAge.isEmpty) {
        endAge = "100";
      }
      if (address == null || address.isEmpty) {
        address = "-";
      }
      List<Member> data = await _memberRepository.filterMember(
          majorId, gender, startAge, endAge, skillList, address);
      memberList.clear();
      for (int i = 0; i < data.length; i++) {
        MemberViewModel member = MemberViewModel(data[i]);
        memberList.add(member);
      }
      notifyListeners();
      return memberList;
    } on Exception catch (e) {
      debugPrint(e.toString());
    }
  }

  Future<dynamic> memberRejectInvitation(
      String memberId, String partyId) async {
    try {
      return await _memberRepository.memberRejectInvitation(memberId, partyId);
    } on Exception catch (e) {
      debugPrint(e.toString());
    }
  }

  Future<List<MemberViewModel>> partyGetListInvitation(
      String partyId, String type) async {
    try {
      List<PartyReq> memberReq =
          await _partyRepository.partyGetListInvitation(partyId, type);
      memberList.clear();
      print(memberReq.length);
      for (int i = 0; i < memberReq.length; i++) {
        var mem = await _memberRepository.getInfoMember(memberReq[i].memberId);
        MemberViewModel party = MemberViewModel(Member.jsonFrom(mem));
        memberList.add(party);
      }
      print("memberList : ${memberList.length}");
      notifyListeners();
      return memberList;
    } on Exception catch (e) {
      debugPrint(e.toString());
    }
  }

  Future<dynamic> memberAcceptInvitation(
      String memberId, String partyId) async {
    try {
      if (await _memberRepository.memberAcceptInvitation(memberId, partyId)) {
        return true;
      } else {
        return false;
      }
    } catch (e) {
      throw new Exception(e.toString());
    }
  }
}

class MemberViewModel {
  final Member member;
  List<Skill> skills = [];
  List<Major> majors = [];
  XFile image;
  bool isSwipedOff = false;
  bool isLiked = false;
  MemberViewModel(this.member);
  String get fullName => member.firstName + " " + member.lastName;
}

class FilerMemberViewModel {
  String majorId;
  String gender;
  String startAge;
  String endAge;
  List<String> skillList;
  String address;
  FilerMemberViewModel(this.majorId, this.gender, this.startAge, this.endAge,
      this.skillList, this.address);
}
