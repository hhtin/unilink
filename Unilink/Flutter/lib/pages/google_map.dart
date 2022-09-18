import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:provider/provider.dart';
import 'package:unilink_flutter_app/constant/path_router.dart';
import 'package:unilink_flutter_app/models/group.dart';
import 'package:unilink_flutter_app/models/group_map_model.dart';
import 'package:unilink_flutter_app/utils/color.dart';
import 'package:unilink_flutter_app/view_model/google_map_view_model.dart';
import 'package:unilink_flutter_app/view_model/member_view_model.dart';

class GoogleMapScreen extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _GooogleMapScreenState();
  }
}

class _GooogleMapScreenState extends State<GoogleMapScreen> {
  //onRouter(String path) => Navigator.of(context).pushNamed(path);

  static const _initialCameraPosition =
      CameraPosition(target: LatLng(10.8011, 106.6471), zoom: 7);
  static GoogleMapController _googleMapController;

  @override
  void initState() {
    super.initState();
    _addMarkerToGroup();
  }

  @override
  void dispose() {
    _googleMapController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Google Maps',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(primaryColor: Colors.white),
      home: Scaffold(

          // App bar for map
          appBar: AppBar(
            centerTitle: false,
            title: Row(mainAxisAlignment: MainAxisAlignment.start, children: [
              IconButton(
                onPressed: () {
                  Navigator.of(context).pop();
                },
                icon: Icon(Icons.arrow_back, color: Colors.black),
              ),
              Image.asset(
                'assets/icons/logo.png',
                fit: BoxFit.contain,
                height: 45,
              )
            ]),
            actions: [
              if (Provider.of<GoogleMapViewModel>(context, listen: false)
                      .origin !=
                  null)
                TextButton(
                  onPressed: () {
                    _googleMapController.animateCamera(
                        CameraUpdate.newCameraPosition(CameraPosition(
                            target: Provider.of<GoogleMapViewModel>(context,
                                    listen: false)
                                .origin
                                .position,
                            zoom: 14.5,
                            tilt: 50.0)));
                  },
                  style: TextButton.styleFrom(
                      primary: Colors.black,
                      textStyle: const TextStyle(fontWeight: FontWeight.w600)),
                  child: Row(
                    children: [
                      Padding(
                          padding: EdgeInsets.only(right: 5),
                          child: Icon(Icons.home)),
                      Padding(
                          padding: EdgeInsets.only(right: 10),
                          child: const Text("ORIGIN"))
                    ],
                  ),
                ),
              if (Provider.of<GoogleMapViewModel>(context, listen: false)
                      .curIndexOfMarker !=
                  null)
                TextButton(
                  onPressed: () => _googleMapController.animateCamera(
                      CameraUpdate.newCameraPosition(CameraPosition(
                          target: Provider.of<GoogleMapViewModel>(context,
                                  listen: false)
                              .groupMarker[Provider.of<GoogleMapViewModel>(
                                      context,
                                      listen: false)
                                  .curIndexOfMarker]
                              .position,
                          zoom: 14.5,
                          tilt: 50.0))),
                  style: TextButton.styleFrom(
                      primary: Colors.black,
                      textStyle: const TextStyle(fontWeight: FontWeight.w600)),
                  child: Row(
                    children: [
                      Padding(
                          padding: EdgeInsets.only(right: 5),
                          child: Icon(Icons.group)),
                      Padding(
                        padding: EdgeInsets.only(right: 10),
                        child: const Text(
                          "DESTINATION",
                          style: TextStyle(fontSize: 13),
                        ),
                      )
                    ],
                  ),
                )
            ],
            backgroundColor: Colors.white,
            titleTextStyle: TextStyle(
                color: Colors.black, fontSize: 20, fontWeight: FontWeight.w500),
          ),

          //Body
          body: Stack(
            alignment: Alignment.center,
            children: [
              //Google map
              GoogleMap(
                  mapType: MapType.hybrid,
                  zoomControlsEnabled: false,
                  myLocationButtonEnabled: false,
                  initialCameraPosition: _initialCameraPosition,
                  onMapCreated: (controller) =>
                      _googleMapController = controller,
                  markers: {
                    if (Provider.of<GoogleMapViewModel>(context, listen: false)
                            .origin !=
                        null)
                      Provider.of<GoogleMapViewModel>(context, listen: false)
                          .origin,
                    for (int count = 0;
                        count <
                            Provider.of<GoogleMapViewModel>(context,
                                    listen: false)
                                .groupMarker
                                .length;
                        count++)
                      Provider.of<GoogleMapViewModel>(context, listen: false)
                          .groupMarker[count],
                    //if (_destination != null) _destination,
                  },
                  polylines: {
                    if (Provider.of<GoogleMapViewModel>(context, listen: false)
                            .info !=
                        null)
                      Polyline(
                          polylineId: const PolylineId('overview_polyline'),
                          color: Colors.red,
                          width: 5,
                          points: Provider.of<GoogleMapViewModel>(context,
                                  listen: false)
                              .info
                              .polyLinePoints
                              .map((e) => LatLng(e.latitude, e.longitude))
                              .toList()),
                  },
                  onLongPress: _addOriginMarker),

              // Text show distance for direction
              if (Provider.of<GoogleMapViewModel>(context, listen: false)
                      .info !=
                  null)
                Positioned(
                  top: 20.0,
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                      vertical: 6.0,
                      horizontal: 12.0,
                    ),
                    decoration: BoxDecoration(
                        color: Colors.yellowAccent,
                        borderRadius: BorderRadius.circular(20.0),
                        boxShadow: const [
                          BoxShadow(
                              color: Colors.black26,
                              offset: Offset(0, 2),
                              blurRadius: 6.0)
                        ]),
                    child: Text(
                      '${Provider.of<GoogleMapViewModel>(context, listen: false).info.totalDistance}, ${Provider.of<GoogleMapViewModel>(context, listen: false).info.totalDuration}',
                      style: const TextStyle(
                          fontSize: 18.0, fontWeight: FontWeight.w600),
                    ),
                  ),
                ),

              // Show list of group
              if (Provider.of<GoogleMapViewModel>(context, listen: false)
                          .showGroupList !=
                      null &&
                  Provider.of<GoogleMapViewModel>(context, listen: false)
                          .showGroupList ==
                      true)
                Positioned(
                  top: 70.0,
                  child: Container(
                    width: 280,
                    height: 460,
                    padding: const EdgeInsets.symmetric(
                      vertical: 6.0,
                      horizontal: 12.0,
                    ),
                    decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(15.0),
                        boxShadow: const [
                          BoxShadow(
                              color: Colors.black26,
                              offset: Offset(0, 2),
                              blurRadius: 6.0)
                        ]),
                    child: Column(
                      children: [
                        Container(
                            alignment: Alignment.topRight,
                            child: IconButton(
                              icon: Icon(
                                Icons.close,
                              ),
                              onPressed: () {
                                setState(() {
                                  Provider.of<GoogleMapViewModel>(context,
                                          listen: false)
                                      .showGroupList = false;
                                });
                              },
                            )),
                        _elementOfGroupList(),
                      ],
                    ),
                  ),
                ),

              //Show information for each group
              if (Provider.of<GoogleMapViewModel>(context, listen: false)
                      .groupInfor !=
                  null)
                Positioned(
                    top: 60.0,
                    child: Container(
                        width: 280,
                        height: 480,
                        decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(15.0),
                            boxShadow: const [
                              BoxShadow(
                                  color: Colors.black26,
                                  offset: Offset(0, 2),
                                  blurRadius: 6.0)
                            ]),
                        child: Column(
                          children: [
                            Container(
                                margin: EdgeInsets.only(bottom: 5),
                                child: Column(children: [
                                  Container(
                                      alignment: Alignment.topRight,
                                      child: IconButton(
                                        icon: Icon(
                                          Icons.close,
                                        ),
                                        onPressed: () {
                                          setState(() {
                                            Provider.of<GoogleMapViewModel>(
                                                    context,
                                                    listen: false)
                                                .groupInfor = null;
                                          });
                                        },
                                      )),
                                  Text(
                                    Provider.of<GoogleMapViewModel>(context,
                                            listen: false)
                                        .groupInfor
                                        .title,
                                    style: const TextStyle(
                                        fontSize: 23.0,
                                        fontWeight: FontWeight.w600),
                                  ),
                                  SizedBox(
                                    height: 5,
                                  ),
                                  Image.asset(
                                    'assets/icons/logo.png',
                                    width: 50,
                                  ),
                                ])),
                            Container(
                              height: 210,
                              child: SingleChildScrollView(
                                child: _buildGroupInforModel(),
                              ),
                            ),
                            Container(
                                alignment: Alignment.centerLeft,
                                margin: EdgeInsets.only(top: 10),
                                child: Column(
                                  children: [
                                    ElevatedButton(
                                      style: ElevatedButton.styleFrom(
                                          primary: Success),
                                      child: Text("Tham gia",
                                          style: TextStyle(fontSize: 16)),
                                      onPressed: () {
                                        Provider.of<MemberListViewModel>(
                                                context,
                                                listen: false)
                                            .requestForParty(
                                                Provider.of<GoogleMapViewModel>(
                                                        context,
                                                        listen: false)
                                                    .groupInfor
                                                    .partyId);
                                        Fluttertoast.showToast(
                                            msg: "Gửi yêu cầu thành công",
                                            toastLength: Toast.LENGTH_LONG);
                                      },
                                    ),
                                    TextButton(
                                      child: Row(
                                        children: [
                                          Padding(
                                              padding:
                                                  EdgeInsets.only(left: 63)),
                                          Icon(
                                            Icons.directions,
                                            size: 30,
                                          ),
                                          Padding(
                                              padding:
                                                  EdgeInsets.only(left: 10)),
                                          Text(
                                            'Chỉ đường',
                                            style: TextStyle(fontSize: 16),
                                          ),
                                        ],
                                      ),
                                      onPressed: () {
                                        if (Provider.of<GoogleMapViewModel>(
                                                    context,
                                                    listen: false)
                                                .origin ==
                                            null) {
                                          Provider.of<GoogleMapViewModel>(context, listen: false)
                                              .getCurLocation()
                                              .then((value) => Provider.of<GoogleMapViewModel>(
                                                      context,
                                                      listen: false)
                                                  .getPosOrigin()
                                                  .then((value) =>
                                                      _addOriginMarker(value)
                                                          .then((value) =>
                                                              Provider.of<GoogleMapViewModel>(
                                                                      context,
                                                                      listen: false)
                                                                  .getDirection()
                                                                  .then((value) => setState(() {
                                                                        Provider.of<GoogleMapViewModel>(context, listen: false).groupInfor =
                                                                            null;
                                                                      })))));
                                        } else {
                                          Provider.of<GoogleMapViewModel>(
                                                  context,
                                                  listen: false)
                                              .getDirection()
                                              .then((value) => setState(() {
                                                    Provider.of<GoogleMapViewModel>(
                                                            context,
                                                            listen: false)
                                                        .groupInfor = null;
                                                  }));
                                        }
                                      },
                                    ),
                                  ],
                                )),
                          ],
                        ))),
            ],
          ),

          //Buttons for features
          floatingActionButton: Stack(
            children: <Widget>[
              Padding(
                padding: EdgeInsets.only(bottom: 65),
                child: Align(
                  alignment: Alignment.bottomRight,
                  child: FloatingActionButton(
                    heroTag: null,
                    backgroundColor: Colors.white,
                    foregroundColor: Colors.black,
                    onPressed: () => _googleMapController.animateCamera(
                        Provider.of<GoogleMapViewModel>(context, listen: false)
                                    .info !=
                                null
                            ? CameraUpdate.newLatLngBounds(
                                Provider.of<GoogleMapViewModel>(context,
                                        listen: false)
                                    .info
                                    .bounds,
                                100.0)
                            : CameraUpdate.newCameraPosition(
                                _initialCameraPosition)),
                    child: const Icon(Icons.center_focus_strong),
                  ),
                ),
              ),
              Padding(
                padding: EdgeInsets.only(bottom: 140),
                child: Align(
                  alignment: Alignment.bottomRight,
                  child: FloatingActionButton(
                    heroTag: null,
                    backgroundColor: Colors.white,
                    foregroundColor: Colors.black,
                    onPressed: () {
                      Provider.of<GoogleMapViewModel>(context, listen: false)
                          .getCurLocation()
                          .then((value) => Provider.of<GoogleMapViewModel>(
                                      context,
                                      listen: false)
                                  .getPosOrigin()
                                  .then((value) {
                                _addOriginMarker(value).then((value) {
                                  _googleMapController.animateCamera(
                                      CameraUpdate.newCameraPosition(
                                          CameraPosition(
                                              target: Provider.of<
                                                          GoogleMapViewModel>(
                                                      context,
                                                      listen: false)
                                                  .latLngOrigin,
                                              zoom: 14.5,
                                              tilt: 50.0)));
                                });
                              }));
                    },
                    child: const Icon(Icons.location_searching),
                  ),
                ),
              ),
              Padding(
                padding: EdgeInsets.only(bottom: 215),
                child: Align(
                  alignment: Alignment.bottomRight,
                  child: FloatingActionButton(
                    heroTag: null,
                    onPressed: () {
                      Provider.of<GoogleMapViewModel>(context, listen: false)
                          .caculateDistanceForAllGroup()
                          .then((value) {
                        setState(() {
                          if (Provider.of<GoogleMapViewModel>(context,
                                      listen: false)
                                  .groupInfor !=
                              null) {
                            Provider.of<GoogleMapViewModel>(context,
                                    listen: false)
                                .groupInfor = null;
                          }
                          if (Provider.of<GoogleMapViewModel>(context,
                                      listen: false)
                                  .showGroupList ==
                              false) {
                            Provider.of<GoogleMapViewModel>(context,
                                    listen: false)
                                .showGroupList = true;
                          }
                        });
                      });
                    },
                    backgroundColor: Colors.white,
                    foregroundColor: Colors.black,
                    child: const Icon(Icons.group),
                  ),
                ),
              ),
            ],
          )),
    );
  }

  //Add marker for list of group on map
  void _addMarkerToGroup() {
    List<Marker> tmpList =
        Provider.of<GoogleMapViewModel>(context, listen: false).groupMarker;
    Provider.of<GoogleMapViewModel>(context, listen: false)
        .groupLatLng
        .forEach((element) {
      Marker curMarker = Marker(
        onTap: () {
          Provider.of<GoogleMapViewModel>(context, listen: false)
                  .curIndexOfMarker =
              Provider.of<GoogleMapViewModel>(context, listen: false)
                  .groupLatLng
                  .indexOf(element);
        },
        infoWindow: InfoWindow(
            title: Provider.of<GoogleMapViewModel>(context, listen: false)
                .groupInforList[
                    Provider.of<GoogleMapViewModel>(context, listen: false)
                        .groupLatLng
                        .indexOf(element)]
                .title,
            onTap: () {
              setState(() {
                Provider.of<GoogleMapViewModel>(context, listen: false)
                        .groupInfor =
                    Provider.of<GoogleMapViewModel>(context, listen: false)
                            .groupInforList[
                        Provider.of<GoogleMapViewModel>(context, listen: false)
                            .groupLatLng
                            .indexOf(element)];
              });
            }),
        markerId: MarkerId(
            '${Provider.of<GoogleMapViewModel>(context, listen: false).groupLatLng.indexOf(element)}'),
        icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueRed),
        position: element,
      );
      tmpList.add(curMarker);
    });

    Provider.of<GoogleMapViewModel>(context, listen: false).groupMarker =
        tmpList;
  }

  //Component for show details of group to map
  Container _buildGroupInforModel() {
    return Container(
        child: Column(
      children: [
        Container(
            margin: EdgeInsets.only(top: 20, bottom: 25),
            width: 180,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _componentDetailsGroup(
                    'assets/icons/skill-30px.png',
                    Provider.of<GoogleMapViewModel>(context, listen: false)
                        .groupInfor
                        .skill),
                _componentDetailsGroup(
                    'assets/icons/location-30px.png',
                    Provider.of<GoogleMapViewModel>(context, listen: false)
                        .groupInfor
                        .location),
                _componentDetailsGroup(
                    'assets/icons/member_15px.png',
                    Provider.of<GoogleMapViewModel>(context, listen: false)
                        .groupInfor
                        .size),
                _componentDetailsGroup(
                    'assets/icons/name-30px.png',
                    Provider.of<GoogleMapViewModel>(context, listen: false)
                        .groupInfor
                        .description),
              ],
            )),
      ],
    ));
  }

  //Component for sub-details of each group
  Container _componentDetailsGroup(String img, String inforDetails) {
    return Container(
        child: Column(
      children: [
        Container(
            width: 180,
            margin: EdgeInsets.only(bottom: 7),
            child: Row(
              children: [
                Image.asset(
                  img,
                  width: 20,
                ),
                Padding(
                  padding: EdgeInsets.only(left: 10),
                  child: Container(
                      width: 150,
                      child: Text(
                        inforDetails,
                        overflow: TextOverflow.clip,
                        style: TextStyle(fontSize: 15),
                      )),
                )
              ],
            )),
        SizedBox(
          height: 3,
        ),
      ],
    ));
  }

  //Component details for each group in group list
  Padding _subDetailsOfEachElementInGroupList(String img, String textType) {
    return Padding(
      padding: const EdgeInsets.only(top: 5),
      child: Row(
        children: [
          Image.asset(
            img,
            width: 17,
          ),
          Padding(
            padding: const EdgeInsets.only(left: 10),
            child: SizedBox(
              width: 135,
              child: Text(
                textType,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                softWrap: false,
              ),
            ),
          ),
        ],
      ),
    );
  }

  //Component each Group in group list
  Container _groupInGroupList(GroupMap group, int count) {
    return Container(
        margin: EdgeInsets.only(bottom: 8),
        decoration: BoxDecoration(
            border: Border.all(
              color: Colors.black,
            ),
            borderRadius: BorderRadius.circular(10)),
        child: ListTile(
          leading: new Image.asset("assets/icons/avatar-group.png",
              alignment: Alignment.center),
          title: Text(
            group.title,
            style: TextStyle(fontSize: 17, fontWeight: FontWeight.w500),
          ),
          subtitle: Column(
            children: [
              _subDetailsOfEachElementInGroupList(
                  'assets/icons/skill_15px.png', group.skill),
              _subDetailsOfEachElementInGroupList(
                  'assets/icons/location_15px.png', group.location),
              _subDetailsOfEachElementInGroupList(
                  'assets/icons/member_15px.png', group.size),
              if (Provider.of<GoogleMapViewModel>(context, listen: false)
                          .distance !=
                      null &&
                  Provider.of<GoogleMapViewModel>(context, listen: false)
                              .distance
                              .length -
                          1 >=
                      count)
                _subDetailsOfEachElementInGroupList('assets/icons/distance.png',
                    '${Provider.of<GoogleMapViewModel>(context, listen: false).distance[count].toStringAsFixed(2)} Km')
            ],
          ),
        ));
  }

  //Component of each group in group list
  Container _elementOfGroupList() {
    return Container(
      child: Column(
        children: [
          Text('Group List',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
          SizedBox(
            height: 10,
          ),
          Container(
            height: 360,
            child: SingleChildScrollView(
              child: Column(
                children: [
                  for (int count = 0;
                      count <
                          Provider.of<GoogleMapViewModel>(context,
                                  listen: false)
                              .groupMarker
                              .length;
                      count++)
                    (InkWell(
                      onTap: () {
                        setState(() {
                          Provider.of<GoogleMapViewModel>(context,
                                  listen: false)
                              .curIndexOfMarker = count;
                          Provider.of<GoogleMapViewModel>(context,
                                  listen: false)
                              .showGroupList = false;
                          Provider.of<GoogleMapViewModel>(context,
                                  listen: false)
                              .groupInfor = (Provider.of<GoogleMapViewModel>(
                                  context,
                                  listen: false)
                              .groupInforList[count]);
                        });
                        _googleMapController.animateCamera(
                            CameraUpdate.newCameraPosition(CameraPosition(
                                target: Provider.of<GoogleMapViewModel>(context,
                                        listen: false)
                                    .groupMarker[
                                        Provider.of<GoogleMapViewModel>(context,
                                                listen: false)
                                            .curIndexOfMarker]
                                    .position,
                                zoom: 14.5,
                                tilt: 50.0)));
                      },
                      child: _groupInGroupList(
                          Provider.of<GoogleMapViewModel>(context,
                                  listen: false)
                              .groupInforList[count],
                          count),
                    ))
                ],
              ),
            ),
          )
        ],
      ),
    );
  }

  //Add original marker on map
  Future<void> _addOriginMarker(LatLng pos) async {
    Provider.of<GoogleMapViewModel>(context, listen: false)
        .setPosOrigin(pos)
        .then((value) => Provider.of<GoogleMapViewModel>(context, listen: false)
            .caculateDistanceForAllGroup()
            .then((value) => setState(() {
                  Provider.of<GoogleMapViewModel>(context, listen: false)
                          .origin =
                      Marker(
                          markerId: MarkerId('origin'),
                          icon: BitmapDescriptor.defaultMarkerWithHue(
                              BitmapDescriptor.hueBlue),
                          position: pos);
                  Provider.of<GoogleMapViewModel>(context, listen: false).info =
                      null;
                  Provider.of<GoogleMapViewModel>(context, listen: false)
                      .showGroupList = false;
                  Provider.of<GoogleMapViewModel>(context, listen: false)
                      .groupInfor = null;
                })));
  }
}
