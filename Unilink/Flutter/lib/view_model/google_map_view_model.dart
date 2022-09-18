import 'package:flutter/foundation.dart';
import 'package:geocoder/geocoder.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:unilink_flutter_app/models/directions_model.dart';
import 'package:unilink_flutter_app/models/group.dart';
import 'package:unilink_flutter_app/models/group_map_model.dart';
import 'package:unilink_flutter_app/models/party_model.dart';
import 'package:unilink_flutter_app/repositories/Impl/DirectionsRepository.dart';
import 'package:unilink_flutter_app/repositories/Impl/PartyRepository.dart';

class GoogleMapViewModel extends ChangeNotifier {
  Marker origin;
  List<Marker> groupMarker = [];
  List<LatLng> groupLatLng = [
    // new LatLng(10.3652, 106.5194),
    // new LatLng(11.8314, 108.3651),
    // new LatLng(11.0130, 106.7391)
  ];
  List<GroupMap> groupInforList = [
    // new Group('Unilink', 'Spring C++ C# Java', '2/5', 'Quân 9', true),
    // new Group('Long Van', 'Flutter', '2/5', 'Quậnn 9', true),
    // new Group('Phong Vu', 'C# Dotnet', '2/5', 'Quân 9', true),
  ];
  Directions info;
  GroupMap groupInfor;
  int curIndexOfMarker;
  bool showGroupList = false;
  List<double> distance = [];
  LatLng latLngOrigin;

  //Caculate distance for each pair
  Future<void> caculateDistanceForAllGroup() async {
    if (origin != null) {
      distance.clear();
      for (int count = 0; count < groupLatLng.length; count++) {
        try {
          await Geolocator()
              .distanceBetween(
                latLngOrigin.latitude,
                latLngOrigin.longitude,
                groupLatLng[count].latitude,
                groupLatLng[count].longitude,
              )
              .then((value) => distance.add(value / 1000));
        } catch (e) {
          print(e);
        }
      }
      notifyListeners();
    }
  }

  //Get current location
  Future<void> getCurLocation() async {
    var curLocation = await Geolocator()
        .getCurrentPosition(desiredAccuracy: LocationAccuracy.high);
    //var lastLocation = await Geolocator().getLastKnownPosition();
    latLngOrigin = LatLng(curLocation.latitude, curLocation.longitude);
    origin = null;
    notifyListeners();
  }

  //Set directions
  Future<void> getDirection() async {
    await DirectionRepository()
        .getDirections(
            origin: latLngOrigin, destination: groupLatLng[curIndexOfMarker])
        .then((value) {
      info = value;
    });

    notifyListeners();
  }

  //Get pos for origin
  Future<void> setPosOrigin(LatLng pos) async {
    if (pos != null) {
      latLngOrigin = pos;
    }

    notifyListeners();
  }

  //Get pos for origin
  Future<LatLng> getPosOrigin() async {
    return new Future(() => latLngOrigin);
  }

  //Convert from Address to LatLng
  Future<LatLng> convertAddressToLatLng(String address) async {
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

  //Get group list
  Future<void> getListParty() async {
    List<LatLng> latLngList = [];
    List<GroupMap> groupList = [];
    try {
      List<Party> partyList = await PartyRepository().getAll();
      if (partyList != null) {
        for (int count = 0; count < partyList.length; count++) {
          if (partyList[count].address != null ||
              partyList[count].address.isNotEmpty) {
            String skill = "";
            if (partyList[count].skills != null &&
                partyList[count].skills.length > 0) {
              skill = partyList[count].skills[0].name;
              for (int i = 1; i < partyList[count].skills.length; i++) {
                skill = skill + ", " + partyList[count].skills[i].name;
              }
            }

            LatLng tmp = await convertAddressToLatLng(partyList[count].address);
            latLngList.add(tmp);
            groupList.add(GroupMap(
                partyList[count].id,
                partyList[count].name,
                skill,
                '${partyList[count].currentMember.toString()}/${partyList[count].maximum.toString()}',
                partyList[count].address,
                partyList[count].description));
          }
        }
      }
    } catch (e) {
      print(e);
    }
    groupInforList = groupList;
    groupLatLng = latLngList;
    notifyListeners();
  }
}
