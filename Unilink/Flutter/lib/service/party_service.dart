import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:image_picker/image_picker.dart';
import 'package:unilink_flutter_app/apis/common.dart';
import 'package:unilink_flutter_app/models/member_model.dart';
import 'package:unilink_flutter_app/models/party_create_model.dart';
import 'package:unilink_flutter_app/models/party_model.dart';
import 'package:unilink_flutter_app/models/party_request_model.dart';
import 'package:unilink_flutter_app/repositories/Impl/PartyRepository.dart';
import 'package:unilink_flutter_app/service/common_service.dart';

class PartyService {
  Future<List<Party>> getParties(int pageSize, int curPage) async {
    Map<String, String> qParams = {
      'pageSize': pageSize.toString(),
      'curPage': curPage.toString(),
      'isKeepBelongToParty': "false"
    };
    try {
      var uri = Uri.https(SERVER, GET_PARTIES, qParams);
      var data = await CommonService.get(uri);
      List<Party> list = [];
      (data["data"] as List)
          .forEach((element) => list.add(Party.jsonFrom(element)));
      return list;
    } on Exception catch (e) {
      throw Exception(e.toString());
    }
  }

  Future<List<Party>> getByMemberId(String memberId) async {
    try {
      var uri = Uri.https(SERVER, GET_BY_MEMBER_ID + "/" + memberId);
      var data = await CommonService.get(uri);
      List<Party> list = [];
      (data as List).forEach((element) => list.add(Party.jsonFrom(element)));
      return list;
    } on Exception catch (e) {
      throw Exception(e.toString());
    }
  }

  Future<List<PartyReq>> getListRequestByPartyId(String id, String type) async {
    try {
      Map<String, dynamic> queryString = {
        "id": id,
        "type": type,
      };
      var url =
          Uri.https(SERVER, "${PARTY}/${id}/members/request", queryString);
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

  Future<dynamic> acceptReq(String partyId, String memberId) async {
    try {
      var url = Uri.https(
          SERVER, "/api/v1/parties/${partyId}/members/${memberId}/accept");
      var acceptObj = jsonEncode({
        "id": partyId,
        "memberId": memberId,
      });
      final data = await CommonService.post(url, acceptObj);
      return data;
    } on Exception catch (e) {
      throw Exception(e.toString());
    }
  }

  Future<dynamic> rejectReq(String partyId, String memberId) async {
    try {
      var url = Uri.https(
          SERVER, "/api/v1/parties/${partyId}/members/${memberId}/reject");
      var rejectObj = jsonEncode({
        "id": partyId,
        "memberId": memberId,
      });
      final data = await CommonService.put(url, rejectObj);
      return data;
    } on Exception catch (e) {
      throw Exception(e.toString());
    }
  }

  Future<Party> getPartyById(String partyId) async {
    try {
      var url = Uri.https(SERVER, "${PARTY}/${partyId}");
      final data = await CommonService.get(url);
      return Party.jsonFrom(data);
    } on Exception catch (e) {
      throw Exception(e.toString());
    }
  }

  Future<String> createParty(PartyCreate partyCreate, XFile avatarParty) async {
    try {
      Map<String, dynamic> query = new Map();
      Map<String, dynamic> map = PartyCreate().toInsertMap(partyCreate);
      map["IsApprovedPost"] = false;
      if (avatarParty != null) {
        map["image"] = await MultipartFile.fromFile(avatarParty.path,
            filename: avatarParty.name);
      }
      final response = await CommonService.postFormDataToken(
          map, "https://unilink.tk:10040/api/v1/parties",
          queryParams: query);
      final data = response.data["data"];
      if (data != null) {
        print(data);
        return data["id"];
      }
      return null;
    } on Exception catch (e) {
      throw Exception(e.toString());
    }
  }

  Future<Party> updateParty(PartyCreate partyCreate, XFile avatarParty) async {
    try {
      Map<String, dynamic> query = new Map();
      Map<String, dynamic> map = PartyCreate().toInsertMap(partyCreate);
      map["IsApprovedPost"] = false;
      if (avatarParty != null) {
        map["image"] = await MultipartFile.fromFile(avatarParty.path,
            filename: avatarParty.name);
      }
      final response = await CommonService.putFormDataToken(
          map, "https://unilink.tk:10040/api/v1/parties",
          queryParams: query);
      final data = response.data["data"];
      if (data != null) {
        print(data);
        return new Party();
      }
      return null;
    } on Exception catch (e) {
      throw Exception(e.toString());
    }
  }

  Future<List<Party>> getListReq(String memberId) async {
    try {
      var url = Uri.https(SERVER, "${PARTY}/members/${memberId}");
      final data = await CommonService.get(url);
      List<Party> list = [];
      (data as List).forEach((element) => list.add(Party.jsonFrom(element)));
      return list;
    } on Exception catch (e) {
      throw Exception(e.toString());
    }
  }

  Future<Party> createPartyForMessage(
      PartyCreate partyCreate, String partyId) async {
    try {
      var createObj = jsonEncode(
          {"name": partyCreate.name, "ref_id": partyId, "member": []});
      var url = Uri.https("server-chat-demo.herokuapp.com", "/group");
      final response = await CommonService.postToServerNode(url, createObj);
      final data = response;
      if (data != null) {
        Party party = new Party(id: data["_id"], name: data["Name"]);
        return party;
      }
      return null;
    } on Exception catch (e) {
      throw Exception(e.toString());
    }
  }

  Future<String> getPartyForMessage(String partyId) async {
    try {
      Map<String, String> param = {
        'ref_id': partyId,
      };

      var url =
          Uri.https("server-chat-demo.herokuapp.com", "/group/by_ref", param);
      final response = await CommonService.getToServerNode(url);
      final data = response;
      if (data != null) {
        return data[0]["_id"];
      }
      return null;
    } on Exception catch (e) {
      throw Exception(e.toString());
    }
  }

  Future<dynamic> findParties(String majorId, List<String> listSkill,
      int maximum, String address, bool isNear) async {
    try {
      var url = Uri.https(SERVER, FIND_PARTIES);
      var insertObj = jsonEncode({
        "majorId": majorId,
        "skillList": listSkill,
        "maximum": maximum,
        "address": address,
        "isNear": isNear
      });

      final data = await CommonService.post(url, insertObj);
      // List<Party> list = [];
      // if (data != null) {
      //   (data as List).forEach((element) => list.add(Party.jsonFrom(element)));
      // }
      // for (var item in list) {
      //   print(item.name);
      // }
      return data;
    } catch (e) {
      throw Exception(e.toString());
    }
  }

  Future<dynamic> quitParty(String partyId, String memberId) async {
    try {
      var url = Uri.https(
          SERVER, "/api/v1/parties/${partyId}/members/${memberId}/quit");
      var rejectObj = jsonEncode({
        "id": partyId,
        "memberId": memberId,
      });
      final data = await CommonService.put(url, rejectObj);
      return data;
    } on Exception catch (e) {
      throw Exception(e.toString());
    }
  }

  Future<dynamic> invitationMember(String partyId, String memberId) async {
    try {
      var url = Uri.https(
          SERVER, "/api/v1/parties/${partyId}/members/${memberId}/invitation");
      var acceptObj = jsonEncode({
        "id": partyId,
        "memberId": memberId,
      });
      final data = await CommonService.post(url, acceptObj);
      return data;
    } on Exception catch (e) {
      throw Exception(e.toString());
    }
  }

  Future<dynamic> partyRejectInvitation(String partyId, String memberId) async {
    try {
      var url = Uri.https(SERVER,
          "/api/v1/parties/${partyId}/members/${memberId}/invitation/reject");
      var rejectObj = jsonEncode({
        "id": partyId,
        "memberId": memberId,
      });
      final data = await CommonService.put(url, rejectObj);
      return data;
    } on Exception catch (e) {
      throw Exception(e.toString());
    }
  }

  Future<List<PartyReq>> partyGetListInvitation(
      String partyId, String type) async {
    try {
      Map<String, dynamic> queryString = {
        "id": partyId,
        "type": type,
      };
      Uri url = Uri.https(
          SERVER, "/api/v1/parties/${partyId}/members/invitation", queryString);
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

  static Future<void> notifyCall(String partyId, String memberId) async {
    Uri url =
        Uri.https(SERVER, "/api/v1/parties/notify/call/${memberId}/${partyId}");
    await CommonService.getNotData(url);
  }
}
