import 'dart:collection';

import 'package:dio/dio.dart';
import 'package:image_picker/image_picker.dart';
import 'package:localstorage/localstorage.dart';
import 'package:provider/provider.dart';
import 'dart:convert';
import 'dart:convert';
import 'dart:io';

import 'package:unilink_flutter_app/apis/common.dart';
import 'package:unilink_flutter_app/models/member_model.dart';
import 'package:unilink_flutter_app/models/party_request_model.dart';
import 'package:unilink_flutter_app/service/common_service.dart';
import 'package:http/http.dart' as http;
import 'package:unilink_flutter_app/view_model/firebase_init.dart';
import 'package:unilink_flutter_app/view_model/member_view_model.dart';

class MemberService {
  Future<List<Member>> getAll() async {
    try {
      Uri url = Uri.https(SERVER, GET_ALL_MEMBER);
      final data = await CommonService.get(url);
      List<Member> list = [];
      if (data != null) {
        (data["data"] as List)
            .forEach((element) => list.add(Member.jsonFrom(element)));
      }
      return list;
    } catch (e) {
      throw Exception(e.toString());
    }
  }

  Future<dynamic> getInfoMember(String id) async {
    try {
      String memberURI = "/api/v1/members";
      var url = Uri.https(SERVER, memberURI + "/$id" + GET_INFO_MEMBER);
      final data = await CommonService.get(url);
      return data;
    } catch (e) {
      throw Exception(e.toString());
    }
  }

  Future<String> getIdentifier() async {
    try {
      var url = Uri.https(SERVER, GET_MEMBER_IDENTIFIER);
      final data = await CommonService.get(url);
      return data.toString();
    } catch (e) {
      throw Exception(e.toString());
    }
  }

  Future<dynamic> updateMember(Member member, List<String> majorIds,
      List<String> skillIds, XFile avatar) async {
    try {
      Map<String, dynamic> map = Member().toUpdateMap(member);
      MemberViewModel memberViewModel = MemberViewModel(member);
      map["majorList"] = majorIds;
      map["skillList"] = skillIds;
      if (avatar != null) {
        map["image"] =
            await MultipartFile.fromFile(avatar.path, filename: member.avatar);
      }
      final data = await CommonService.putFormData(
          map, "https://unilink.tk:10040/api/v1/members");
      return data;
    } catch (e) {
      throw Exception(e.toString());
    }
  }

  Future<bool> insertMember(MemberViewModel member, String deviceToken) async {
    try {
      Map<String, dynamic> map = Member().toInsertMap(member.member);
      map["majorList"] = member.majors.map((e) => e.id).toList();
      map["skillList"] = member.skills.map((e) => e.id).toList();
      map["image"] = await MultipartFile.fromFile(member.image.path,
          filename: member.image.name);
      final response = await CommonService.postFormData(
          map, "https://unilink.tk:10040/api/v1/members",
          queryParams: {"deviceToken": deviceToken});
      final data = response.data["data"];
      if (data != null) {
        http.get(Uri.parse(
            (response as Response<dynamic>).headers["location"][0].toString()));
        return true;
      }
      return false;
    } catch (e) {
      throw Exception(e.toString());
    }
  }

  Future<dynamic> requestForParty(String memberId, String partyId) async {
    try {
      String memberURI = "/api/v1/members/";
      var url = Uri.https(
          SERVER, "${memberURI}${memberId}/parties/${partyId}/request");
      var insertObj = jsonEncode({
        "id": memberId,
        "partyId": partyId,
      });
      final data = await CommonService.post(url, insertObj);
      return data;
    } catch (e) {
      throw Exception(e.toString());
    }
  }

  Future<List<Member>> getMemberInParty(String partyId) async {
    try {
      String memberURI = "/api/v1/members";
      var url = Uri.https(SERVER, "${memberURI}/parties/${partyId}");
      final data = await CommonService.get(url);
      List<Member> list = [];
      if (data != null) {
        (data as List).forEach((element) => list.add(Member.jsonFrom(element)));
      }
      return list;
    } catch (e) {
      throw new Exception(e.toString());
    }
  }

  Future<bool> checkIsExistedEmail(String email) async {
    try {
      HttpClient client = new HttpClient();
      client.badCertificateCallback =
          ((X509Certificate cert, String host, int port) => true);
      Map<String, String> queryParams = {"email": '$email'};
      var url = Uri.https(SERVER, GET_MEMBER_BY_EMAIL, queryParams);
      var response = await http.get(url);
      if (response.statusCode == 200) {
        return true;
      }
      return false;
    } catch (e) {
      throw Exception(e.toString());
    }
  }

  Future<List<PartyReq>> getListRequestByMemberId(
      String memberId, String type) async {
    try {
      Map<String, dynamic> queryString = {
        "id": memberId,
        "type": type,
      };
      var url = Uri.https(
          SERVER, "/api/v1/members/${memberId}/parties/request", queryString);
      final data = await CommonService.get(url);
      List<PartyReq> listPartyReq = <PartyReq>[];
      if (data != null) {
        (data as List)
            .forEach((element) => listPartyReq.add(PartyReq.jsonFrom(element)));
      }
      return listPartyReq;
    } on Exception catch (e) {
      throw Exception(e.toString());
    }
  }

  Future<dynamic> rejectReqByMember(String memberId, String partyId) async {
    try {
      var url = Uri.https(
          SERVER, "/api/v1/members/${memberId}/parties/${partyId}/reject");
      var rejectObj = jsonEncode({
        "id": memberId,
        "partyId": partyId,
      });
      final data = await CommonService.put(url, rejectObj);
      return data;
    } on Exception catch (e) {
      throw Exception(e.toString());
    }
  }

  Future<List<dynamic>> filterMember(
      String majorId,
      String gender,
      String startAge,
      String endAge,
      List<String> skillList,
      String address) async {
    try {
      String memberURI = "/api/v1/members/filter";
      var url = Uri.https(SERVER, memberURI);
      var insertObj = jsonEncode({
        "majorId": majorId,
        "gender": gender,
        "startAge": startAge,
        "endAge": endAge,
        "skillList": skillList,
        "address": address,
      });
      final data = await CommonService.post(url, insertObj);
      List<Member> listMember = <Member>[];
      if (data != null) {
        (data as List)
            .forEach((element) => listMember.add(Member.jsonFrom(element)));
      }
      return listMember;
    } catch (e) {
      throw Exception(e.toString());
    }
  }

  Future<dynamic> memberRejectInvitation(
      String memberId, String partyId) async {
    try {
      var url = Uri.https(SERVER,
          "/api/v1/members/${memberId}/parties/${partyId}/invitation/reject");
      var rejectObj = jsonEncode({
        "id": memberId,
        "partiesId": partyId,
      });
      final data = await CommonService.put(url, rejectObj);
      return data;
    } on Exception catch (e) {
      throw Exception(e.toString());
    }
  }

  Future<dynamic> memberAcceptInvitation(
      String memberId, String partyId) async {
    try {
      var url = Uri.https(SERVER,
          "/api/v1/members/${memberId}/parties/${partyId}/invitation/accept");
      var acceptObj = jsonEncode({
        "id": memberId,
        "partiesId": partyId,
      });
      final data = await CommonService.post(url, acceptObj);
      return data;
    } on Exception catch (e) {
      throw Exception(e.toString());
    }
  }

  Future<List<PartyReq>> memberGetListInvitation(
      String memberId, String type) async {
    try {
      Map<String, dynamic> queryString = {
        "id": memberId,
        "type": type,
      };
      Uri url = Uri.https(SERVER,
          "/api/v1/members/${memberId}/parties/invitation", queryString);
      final data = await CommonService.get(url);
      List<PartyReq> listPartyReq = <PartyReq>[];
      if (data != null) {
        (data as List)
            .forEach((element) => listPartyReq.add(PartyReq.jsonFrom(element)));
      }
      return listPartyReq;
    } catch (e) {
      throw Exception(e.toString());
    }
  }
}
