import 'dart:convert';
import 'dart:io';

import 'package:image_picker/image_picker.dart';
import 'package:unilink_flutter_app/apis/common.dart';
import 'package:unilink_flutter_app/models/party_create_model.dart';
import 'package:unilink_flutter_app/models/party_model.dart';
import 'package:unilink_flutter_app/models/party_request_model.dart';
import 'package:unilink_flutter_app/repositories/IPartyRepository.dart';
import 'package:http/http.dart' as http;
import 'package:unilink_flutter_app/service/common_service.dart';
import 'package:unilink_flutter_app/service/party_service.dart';

class PartyRepository implements IPartyRepository {
  final PartyService service = PartyService();
  @override
  Future<List<Party>> getParties(int pageSize, int curPage) async {
    try {
      return await service.getParties(pageSize, curPage);
    } catch (e) {
      throw Exception(e.toString());
    }
  }

  @override
  Future<List<Party>> getByMemberId(String memberId) async {
    try {
      return await service.getByMemberId(memberId);
    } catch (e) {
      throw Exception(e.toString());
    }
  }

  @override
  Future<List<PartyReq>> getListRequestByPartyId(
      String partyId, String type) async {
    try {
      return await service.getListRequestByPartyId(partyId, type);
    } catch (e) {
      throw Exception(e.toString());
    }
  }

  @override
  Future acceptReq(String partyId, String memberId) async {
    try {
      return await service.acceptReq(partyId, memberId);
    } catch (e) {
      throw Exception(e.toString());
    }
  }

  @override
  Future rejectReq(String partyId, String memberId) async {
    try {
      return await service.rejectReq(partyId, memberId);
    } catch (e) {
      throw Exception(e.toString());
    }
  }

  @override
  Future<List<Party>> getAll() async {
    try {
      return await service.getParties(100, 1);
    } catch (e) {
      throw Exception(e.toString());
    }
  }

  @override
  Future<Party> getPartyById(String partyId) async {
    try {
      return await service.getPartyById(partyId);
    } catch (e) {
      throw Exception(e.toString());
    }
  }

  @override
  Future<String> createParty(PartyCreate partyCreate, XFile avatarParty) async {
    try {
      return await service.createParty(partyCreate, avatarParty);
    } catch (e) {
      throw Exception(e.toString());
    }
  }

  Future<List<Party>> getListReq(String memberId) async {
    try {
      return await service.getListReq(memberId);
    } catch (e) {
      throw Exception(e.toString());
    }
  }

  @override
  Future<Party> createPartyForMessage(
      PartyCreate partyCreate, String partyId) async {
    try {
      return await service.createPartyForMessage(partyCreate, partyId);
    } catch (e) {
      throw Exception(e.toString());
    }
  }

  @override
  Future<String> getPartyForMessage(String partyId) async {
    try {
      return await service.getPartyForMessage(partyId);
    } on Exception catch (e) {
      throw Exception(e.toString());
    }
  }

  @override
  Future<dynamic> findParties(String majorId, List<String> listSkill,
      int maximum, String address, bool isNear) async {
    try {
      return await service.findParties(
          majorId, listSkill, maximum, address, isNear);
    } catch (e) {
      throw Exception(e.toString());
    }
  }

  @override
  Future<Party> updateParty(PartyCreate partyCreate, XFile avatarParty) async {
    try {
      return await service.updateParty(partyCreate, avatarParty);
    } catch (e) {
      throw Exception(e.toString());
    }
  }

  Future<dynamic> quitParty(String partyId, String memberId) async {
    try {
      return await service.quitParty(partyId, memberId);
    } catch (e) {
      throw Exception(e.toString());
    }
  }

  Future<dynamic> invitationMember(String partyId, String memberId) async {
    try {
      await service.invitationMember(partyId, memberId);
      return true;
    } catch (e) {
      if (e.toString() == "Exception: Exception: Unable to perform request") {
        return false;
      } else {
        throw Exception(e.toString());
      }
    }
  }

  Future<dynamic> partyRejectInvitation(String partyId, String memberId) async {
    try {
      await service.partyRejectInvitation(partyId, memberId);
      return true;
    } catch (e) {
      if (e.toString() == "Exception: Exception: Unable to perform request") {
        return false;
      } else {
        throw Exception(e.toString());
      }
    }
  }

  Future<List<PartyReq>> partyGetListInvitation(
      String partyId, String type) async {
    try {
      return await service.partyGetListInvitation(partyId, type);
    } catch (e) {
      throw Exception(e.toString());
    }
  }
}
