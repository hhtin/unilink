import 'package:flutter/foundation.dart';
import 'package:geocoder/geocoder.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';
import 'package:unilink_flutter_app/models/member_model.dart';
import 'package:unilink_flutter_app/models/party_create_model.dart';
import 'package:unilink_flutter_app/models/party_model.dart';
import 'package:unilink_flutter_app/models/party_request_model.dart';
import 'package:unilink_flutter_app/repositories/IMemberRepository.dart';
import 'package:unilink_flutter_app/repositories/IPartyRepository.dart';
import 'package:unilink_flutter_app/repositories/Impl/MemberRepository.dart';
import 'package:unilink_flutter_app/repositories/Impl/PartyRepository.dart';
import 'package:unilink_flutter_app/service/party_service.dart';
import 'package:unilink_flutter_app/view_model/member_view_model.dart';

class PartyListViewModel extends ChangeNotifier {
  IPartyRepository _partyRepository = new PartyRepository();
  IMemberRepository _memberRepository = new MemberRepository();
  List<PartyViewModel> partyList = [];
  List<PartyViewModel> myParty = [];
  List<PartyViewModel> listRequest = [];
  List<MemberViewModel> membersInGroup = [];
  List<Party> filterGroup = [];
  PartyViewModel currentParty;
  String currentPartyMessageId = null;
  String typeOfList = null;
  Map<String, double> mapDistance = Map();

  Future<List<PartyViewModel>> getParties(int curPage, bool isReload) async {
    try {
      var results = await _partyRepository.getParties(5, curPage);
      List<PartyViewModel> partyTemp = [];
      partyTemp = results.map((item) => PartyViewModel(item)).toList();
      if (isReload) {
        this.partyList = [];
      }
      String curMemId = await MemberRepository().getIdentifier();
      dynamic jsonMem = await MemberRepository().getInfoMember(curMemId);
      Member currentMember = Member.jsonFrom(jsonMem);
      LatLng originLatLng =
          await convertAddressPartyToLatLng(currentMember.address);
      if (originLatLng != null) {
        for (int count = 0; count < partyTemp.length; count++) {
          LatLng latLngDes =
              await convertAddressPartyToLatLng(partyTemp[count].party.address);
          double distance = 0.0;
          if (latLngDes != null) {
            distance =
                await caculateDistanceForAllParty(originLatLng, latLngDes);
            if (distance < 50) {
              mapDistance
                  .addEntries([MapEntry(partyTemp[count].party.id, distance)]);
              partyList.add(partyTemp[count]);
            }
          }
        }
      }
      notifyListeners();
      return partyList;
    } on Exception catch (e) {
      debugPrint(e.toString());
    }
  }

  Future<List<PartyViewModel>> getPartyByMemberId(String memberId) async {
    try {
      var results = await _partyRepository.getByMemberId(memberId);
      this.myParty = results.map((item) => PartyViewModel(item)).toList();
      notifyListeners();
      return myParty;
    } on Exception catch (e) {
      debugPrint(e.toString());
    }
  }

  Future<List<MemberViewModel>> getMemberInParty(String memberId) async {
    try {
      membersInGroup = [];
      var results =
          await _memberRepository.getMemberInParty(currentParty.party.id);
      results.forEach((item) => {
            if (item.id != memberId) {membersInGroup.add(MemberViewModel(item))}
          });

      return membersInGroup;
    } on Exception catch (e) {
      debugPrint(e.toString());
    }
  }

  Future<dynamic> acceptReq(String partyId, String memberId) async {
    try {
      return await _partyRepository.acceptReq(partyId, memberId);
    } on Exception catch (e) {
      debugPrint(e.toString());
    }
  }

  Future<dynamic> rejectReq(String partyId, String memberId) async {
    try {
      return await _partyRepository.rejectReq(partyId, memberId);
    } on Exception catch (e) {
      debugPrint(e.toString());
    }
  }

  Future<PartyViewModel> getPartyById(String partyId) async {
    try {
      Party party = await _partyRepository.getPartyById(partyId);
      currentParty = PartyViewModel(party);
      return currentParty;
    } on Exception catch (e) {
      debugPrint(e.toString());
    }
  }

  Future<String> createParty(PartyCreate partyCreate, XFile avatarParty) async {
    try {
      return await _partyRepository.createParty(partyCreate, avatarParty);
    } on Exception catch (e) {
      debugPrint(e.toString());
    }
  }

  Future<Party> updateParty(PartyCreate partyCreate, XFile avatarParty) async {
    try {
      return await _partyRepository.updateParty(partyCreate, avatarParty);
    } on Exception catch (e) {
      debugPrint(e.toString());
    }
  }

  Future<List<PartyViewModel>> getListReq(String memberId) async {
    try {
      var results = await _partyRepository.getListReq(memberId);
      List<PartyViewModel> listReq =
          results.map((item) => PartyViewModel(item)).toList();
      notifyListeners();
      return listReq;
    } on Exception catch (e) {
      debugPrint(e.toString());
    }
  }

  Future<Party> createPartyForMessage(
      PartyCreate partyCreate, String partyId) async {
    try {
      return await _partyRepository.createPartyForMessage(partyCreate, partyId);
    } on Exception catch (e) {
      debugPrint(e.toString());
    }
  }

  Future<String> getPartyForMessage(String partyId) async {
    try {
      currentPartyMessageId =
          await _partyRepository.getPartyForMessage(partyId);
      return currentPartyMessageId;
    } on Exception catch (e) {
      debugPrint(e.toString());
    }
  }

  Future<List<Party>> findParties(String majorId, List<String> listSkill,
      int maximum, String address, bool isNear) async {
    try {
      var data = await _partyRepository.findParties(
          majorId, listSkill, maximum, address, isNear);
      filterGroup.clear();
      if (data != null) {
        (data as List)
            .forEach((element) => filterGroup.add(Party.jsonFrom(element)));
      }

      return filterGroup;
    } catch (e) {
      debugPrint(e.toString());
    }
  }

  Future<List<PartyViewModel>> getListRequestByMemberId(
      String memberId, String type) async {
    try {
      List<PartyReq> partyReq =
          await _memberRepository.getListRequestByMemberId(memberId, type);
      listRequest.clear();
      for (int i = 0; i < partyReq.length; i++) {
        Party par = await _partyRepository.getPartyById(partyReq[i].partyId);
        PartyViewModel party = PartyViewModel(par);
        listRequest.add(party);
      }

      notifyListeners();
      return listRequest;
    } on Exception catch (e) {
      debugPrint(e.toString());
    }
  }

  //Convert from Address to LatLng
  Future<LatLng> convertAddressPartyToLatLng(String address) async {
    try {
      var addresses = await Geocoder.local.findAddressesFromQuery(address);
      if (addresses != null && address.isNotEmpty) {
        var first = addresses.first;
        return LatLng(first.coordinates.latitude, first.coordinates.longitude);
      }
    } catch (e) {
      print(e);
    }
  }

  //Caculate distance for each pair
  Future<double> caculateDistanceForAllParty(
      LatLng origin, LatLng destination) async {
    try {
      double distance = await Geolocator().distanceBetween(
        origin.latitude,
        origin.longitude,
        destination.latitude,
        destination.longitude,
      );
      return distance / 1000;
    } catch (e) {
      print(e);
    }
  }

  Future<dynamic> quitParty(String partyId, String memberId) async {
    try {
      return await _partyRepository.quitParty(partyId, memberId);
    } on Exception catch (e) {
      debugPrint(e.toString());
    }
  }

  Future<bool> invitationMember(String partyId, String memberId) async {
    try {
      if (await _partyRepository.invitationMember(partyId, memberId)) {
        return true;
      } else {
        return false;
      }
    } catch (e) {
      throw new Exception(e.toString());
    }
  }

  Future<dynamic> partyRejectInvitation(String partyId, String memberId) async {
    try {
      return await _partyRepository.partyRejectInvitation(partyId, memberId);
    } on Exception catch (e) {
      debugPrint(e.toString());
    }
  }

  Future<List<PartyViewModel>> memberGetListInvitation(
      String memberId, String type) async {
    try {
      List<PartyReq> partyReq =
          await _memberRepository.memberGetListInvitation(memberId, type);
      partyList.clear();
      for (int i = 0; i < partyReq.length; i++) {
        Party par = await _partyRepository.getPartyById(partyReq[i].partyId);
        PartyViewModel party = PartyViewModel(par);
        partyList.add(party);
      }
      notifyListeners();
      return partyList;
    } on Exception catch (e) {
      debugPrint(e.toString());
    }
  }

  void setCurrenParty(PartyViewModel partyViewModel) {
    currentParty = partyViewModel;
    notifyListeners();
  }
}

class PartyViewModel {
  Party party;
  PartyViewModel(this.party);
}
