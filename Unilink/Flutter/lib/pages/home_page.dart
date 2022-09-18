import 'package:carousel_slider/carousel_slider.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:provider/provider.dart';
import 'package:unilink_flutter_app/constant/path_router.dart';
import 'package:unilink_flutter_app/main.dart';
import 'package:unilink_flutter_app/utils/spinner.dart';
import 'package:unilink_flutter_app/view_model/google_map_view_model.dart';
import 'package:unilink_flutter_app/view_model/member_view_model.dart';
import 'package:unilink_flutter_app/view_model/party_view_model.dart';
import 'package:unilink_flutter_app/widgets/app_bar_main_widget.dart';
import 'package:unilink_flutter_app/widgets/mini_swipe_card.dart';
import 'package:unilink_flutter_app/utils/color.dart';
import 'package:unilink_flutter_app/widgets/modal_detail_group.dart';
import 'package:unilink_flutter_app/widgets/model_view_list_req.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int sizeGroupNearYou = 1;
  ScrollController controller;
  int currentPage = 1;
  bool isLoading = false;
  showDetailGroup() {
    showDialog(
        context: context,
        builder: (context) {
          return ModalDetailGroup(
            callback: callBack,
          );
        });
  }

  showViewListReq() {
    showDialog(
        context: context,
        builder: (context) {
          return ModelViewListReq(
            callback: callBack,
          );
        });
  }

  var groupNearYou = [];
  Map<String, double> mapDistance = Map();
  var members = [
    'assets/icons/avatar-long.jpg',
    'assets/icons/avatar-tuan.jpg',
    'assets/icons/avatar-tin.jpg',
  ];
  callBack() {
    getParties(true);
  }

  @override
  void initState() {
    super.initState();
    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      RemoteNotification notification = message.notification;
      AndroidNotification android = message.notification?.android;
      if (notification != null && android != null) {
        flutterLocalNotificationsPlugin.show(
            notification.hashCode,
            notification.title,
            notification.body,
            NotificationDetails(
              android: AndroidNotificationDetails(
                channel.id,
                channel.name,
                channel.description,
                color: Colors.blue,
                playSound: true,
                icon: '@mipmap/ic_launcher',
              ),
            ));
      }
    });
    getParties(true);
    controller = new ScrollController();
    controller.addListener(() {
      if (controller.position.pixels == controller.position.maxScrollExtent) {
        currentPage = currentPage += 1;
        print(currentPage);
        getParties(false);
      }
    });
  }

  Future<void> getParties(bool isReload) async {
    if (isReload) {
      setState(() {
        currentPage = 1;
        isLoading = true;
      });
    }
    await Provider.of<PartyListViewModel>(this.context, listen: false)
        .getParties(currentPage, isReload);
    groupNearYou =
        Provider.of<PartyListViewModel>(this.context, listen: false).partyList;
    mapDistance = Provider.of<PartyListViewModel>(this.context, listen: false)
        .mapDistance;
    setState(() {
      sizeGroupNearYou = groupNearYou.length;
      isLoading = false;
    });
  }

  onRouter(String path) => Navigator.of(context).pushNamed(path);
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: SingleChildScrollView(
            child: Container(
          decoration: BoxDecoration(color: Colors.white),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: <Widget>[
              Container(
                margin: EdgeInsets.all(10),
                padding: EdgeInsets.all(10),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                  color: PrimaryColor,
                  boxShadow: [
                    BoxShadow(
                      color: PrimaryColor.withOpacity(0.5),
                      spreadRadius: 1,
                      blurRadius: 10,
                      offset: Offset(0, 3), // changes position of shadow
                    ),
                  ],
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    InkWell(
                      onTap: () {
                        Provider.of<GoogleMapViewModel>(context, listen: false)
                            .groupMarker = [];
                        Spinner.blockUiWithSpinnerScreen(context);
                        Provider.of<GoogleMapViewModel>(context, listen: false)
                            .getListParty()
                            .then((value) => Navigator.pushReplacementNamed(
                                context, GOOGLE_MAP_ROUTE));
                      },
                      child: Container(
                          child: Column(
                        children: [
                          Container(
                            margin: EdgeInsets.all(10),
                            child: Padding(
                                padding: EdgeInsets.all(10),
                                child: Image.asset(
                                  'assets/icons/map-1.png',
                                  height: 40,
                                )),
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(10),
                              boxShadow: [
                                BoxShadow(
                                  color: PrimaryColor.withOpacity(0.5),
                                  spreadRadius: 1,
                                  blurRadius: 10,
                                  offset: Offset(
                                      0, 3), // changes position of shadow
                                ),
                              ],
                            ),
                          ),
                          Container(
                            margin: EdgeInsets.only(top: 5),
                            child: Text(
                              'Tìm nhóm',
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ],
                      )),
                    ),
                    InkWell(
                      onTap: () {
                        onRouter(GROUP_CREATE_ROUTE);
                      },
                      child: Container(
                          child: Column(
                        children: [
                          Container(
                            margin: EdgeInsets.all(10),
                            child: Padding(
                                padding: EdgeInsets.all(10),
                                child: Image.asset(
                                  'assets/icons/store-1.png',
                                  height: 40,
                                )),
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(10),
                              boxShadow: [
                                BoxShadow(
                                  color: PrimaryColor.withOpacity(0.5),
                                  spreadRadius: 1,
                                  blurRadius: 10,
                                  offset: Offset(
                                      0, 3), // changes position of shadow
                                ),
                              ],
                            ),
                          ),
                          Container(
                            margin: EdgeInsets.only(top: 5),
                            child: Text(
                              'Tạo nhóm',
                              style: TextStyle(fontWeight: FontWeight.bold),
                            ),
                          ),
                        ],
                      )),
                    ),
                    InkWell(
                      onTap: () {
                        return showViewListReq();
                      },
                      child: Container(
                        child: Column(
                          children: [
                            Container(
                              margin: EdgeInsets.all(10),
                              child: Padding(
                                  padding: EdgeInsets.all(10),
                                  child: Image.asset(
                                    'assets/icons/invite-2.png',
                                    height: 40,
                                  )),
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(10),
                                boxShadow: [
                                  BoxShadow(
                                    color: PrimaryColor.withOpacity(0.5),
                                    spreadRadius: 1,
                                    blurRadius: 10,
                                    offset: Offset(
                                        0, 3), // changes position of shadow
                                  ),
                                ],
                              ),
                            ),
                            Container(
                              margin: EdgeInsets.only(top: 5),
                              child: Text(
                                'Yêu cầu đã gởi',
                                style: TextStyle(fontWeight: FontWeight.bold),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    InkWell(
                      onTap: () {
                        Navigator.of(context).pushNamed(MEMBER_INVITATION_PAGE);
                      },
                      child: Container(
                          child: Column(
                        children: [
                          Container(
                            margin: EdgeInsets.all(10),
                            child: Padding(
                                padding: EdgeInsets.all(10),
                                child: Image.asset(
                                  'assets/icons/handshake.png',
                                  height: 40,
                                )),
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(10),
                              boxShadow: [
                                BoxShadow(
                                  color: PrimaryColor.withOpacity(0.5),
                                  spreadRadius: 1,
                                  blurRadius: 10,
                                  offset: Offset(
                                      0, 3), // changes position of shadow
                                ),
                              ],
                            ),
                          ),
                          Container(
                            margin: EdgeInsets.only(top: 5),
                            child: Text(
                              'Lời mời',
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ],
                      )),
                    ),
                  ],
                ),
              ),
              // Container(
              //   margin: EdgeInsets.all(10),
              //   padding: EdgeInsets.all(10),
              //   decoration: BoxDecoration(
              //     borderRadius: BorderRadius.circular(10),
              //     color: PrimaryColor,
              //     boxShadow: [
              //       BoxShadow(
              //         color: PrimaryColor.withOpacity(0.5),
              //         spreadRadius: 1,
              //         blurRadius: 10,
              //         offset: Offset(0, 3), // changes position of shadow
              //       ),
              //     ],
              //   ),
              //   child: Row(
              //     children: [
              //       InkWell(
              //         onTap: () async {
              //           if (await Provider.of<PartyListViewModel>(context,
              //                   listen: false)
              //               .invitationMember(
              //                   "1fbbb7be-cd05-4b02-9f0d-855d28b1afe2",
              //                   "610b6bc3-b48f-4ebd-bb72-0aaf798b16db")) {
              //             Fluttertoast.showToast(
              //                 msg: "Invitation success",
              //                 toastLength: Toast.LENGTH_SHORT);
              //           } else {
              //             Fluttertoast.showToast(
              //                 msg: "Invitation already",
              //                 toastLength: Toast.LENGTH_SHORT);
              //           }
              //         },
              //         child: Container(
              //             child: Column(
              //           children: [
              //             Container(
              //               margin: EdgeInsets.all(10),
              //               child: Padding(
              //                   padding: EdgeInsets.all(10),
              //                   child: Image.asset(
              //                     'assets/icons/map-1.png',
              //                     height: 40,
              //                   )),
              //               decoration: BoxDecoration(
              //                 color: Colors.white,
              //                 borderRadius: BorderRadius.circular(10),
              //                 boxShadow: [
              //                   BoxShadow(
              //                     color: PrimaryColor.withOpacity(0.5),
              //                     spreadRadius: 1,
              //                     blurRadius: 10,
              //                     offset: Offset(
              //                         0, 3), // changes position of shadow
              //                   ),
              //                 ],
              //               ),
              //             ),
              //             Container(
              //               margin: EdgeInsets.only(top: 5),
              //               child: Text(
              //                 'mời vào nhóm',
              //                 style: TextStyle(
              //                   fontWeight: FontWeight.bold,
              //                 ),
              //               ),
              //             ),
              //           ],
              //         )),
              //       ),
              //     ],
              //   ),
              // ),
              Container(
                height: 150,
                width: 400,
                margin: EdgeInsets.all(20),
                child: CarouselSlider(
                  options: CarouselOptions(
                      height: 400.0,
                      autoPlay: true,
                      autoPlayInterval: Duration(seconds: 3)),
                  items: [
                    'assets/icons/group-3.png',
                    'assets/icons/group-1.png',
                    'assets/icons/group-2.png'
                  ].map((i) {
                    return Builder(
                      builder: (BuildContext context) {
                        return ClipRect(
                            child: Container(
                                child: Image.asset(
                          i,
                          width: 300,
                          fit: BoxFit.fitWidth,
                        )));
                      },
                    );
                  }).toList(),
                ),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                  color: Colors.white,
                  boxShadow: [
                    BoxShadow(
                      color: PrimaryColor.withOpacity(0.5),
                      spreadRadius: 5,
                      blurRadius: 7,
                      offset: Offset(0, 3), // changes position of shadow
                    ),
                  ],
                ),
              ),
              Container(
                margin: EdgeInsets.only(left: 15, right: 15, top: 20),
                alignment: Alignment.centerLeft,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Container(
                      margin: EdgeInsets.only(bottom: 30),
                      child: Text(
                        'Nhóm gần tôi',
                        textAlign: TextAlign.left,
                        style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 20,
                            color: PrimaryColor),
                      ),
                    ),
                    Container(
                      margin: EdgeInsets.only(bottom: 20),
                      child: TextButton(
                        onPressed: () => onRouter(LOOKING_FOR_STUDY_GROUPS),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Container(
                              child: Image.asset('assets/icons/tim-nhom.png',
                                  height: 30),
                            )
                          ],
                        ),
                      ),
                    )
                  ],
                ),
              ),
              Container(
                margin: EdgeInsets.only(right: 20, left: 20),
                height: sizeGroupNearYou > 1 ? 200 : 200,
                child: Center(
                    child: isLoading
                        ? Center(
                            child: CircularProgressIndicator(),
                          )
                        : groupNearYou.length == 0
                            ? Center(
                                child: Text("Không có nhóm nào gần bạn"),
                              )
                            : RefreshIndicator(
                                onRefresh: () => getParties(true),
                                child: ListView.builder(
                                  controller: controller,
                                  scrollDirection: Axis.vertical,
                                  itemCount: groupNearYou.length,
                                  itemBuilder:
                                      (BuildContext context, int index) {
                                    return InkWell(
                                        onTap: () {},
                                        child: Container(
                                          height: 140,
                                          margin: EdgeInsets.only(
                                              right: 5,
                                              left: 5,
                                              bottom: 10,
                                              top: 10),
                                          child: Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceBetween,
                                            children: [
                                              Container(
                                                margin:
                                                    EdgeInsets.only(left: 20),
                                                child: Icon(
                                                  Icons.people,
                                                  size: 35,
                                                ),
                                              ),
                                              Container(
                                                  width: 180,
                                                  child: Column(
                                                    crossAxisAlignment:
                                                        CrossAxisAlignment
                                                            .start,
                                                    children: [
                                                      Container(
                                                          width: 180,
                                                          margin:
                                                              EdgeInsets.only(
                                                                  top: 13),
                                                          child: Container(
                                                              child: Text(
                                                                  groupNearYou[
                                                                          index]
                                                                      .party
                                                                      .name,
                                                                  style: TextStyle(
                                                                      fontWeight:
                                                                          FontWeight
                                                                              .bold),
                                                                  overflow:
                                                                      TextOverflow
                                                                          .ellipsis))),
                                                      Container(
                                                          width: 180,
                                                          margin:
                                                              EdgeInsets.only(
                                                                  top: 7),
                                                          child: Row(
                                                            children: [
                                                              Image.asset(
                                                                'assets/icons/skill_15px.png',
                                                                width: 17,
                                                              ),
                                                              Padding(
                                                                padding: EdgeInsets
                                                                    .only(
                                                                        left:
                                                                            10),
                                                                child: Container(
                                                                    width: 150,
                                                                    height: 20,
                                                                    child: ListView.builder(
                                                                        scrollDirection: Axis.horizontal,
                                                                        itemCount: groupNearYou[index].party.skills.length,
                                                                        itemBuilder: (BuildContext context, int position) => Container(
                                                                              child: Row(
                                                                                children: [
                                                                                  Text(
                                                                                    groupNearYou[index].party.skills[position].name,
                                                                                    overflow: TextOverflow.ellipsis,
                                                                                  ),
                                                                                  groupNearYou[index].party.skills.length - 1 != position ? Text(", ") : Text("")
                                                                                ],
                                                                              ),
                                                                            ))),
                                                              )
                                                            ],
                                                          )),
                                                      Container(
                                                          margin:
                                                              EdgeInsets.only(
                                                                  top: 7),
                                                          child: Row(
                                                            children: [
                                                              Image.asset(
                                                                'assets/icons/location_15px.png',
                                                                width: 17,
                                                              ),
                                                              Padding(
                                                                padding: EdgeInsets
                                                                    .only(
                                                                        left:
                                                                            10),
                                                                child: Container(
                                                                    width: 150,
                                                                    child: Text(
                                                                        groupNearYou[index]
                                                                            .party
                                                                            .address,
                                                                        overflow:
                                                                            TextOverflow.ellipsis)),
                                                              )
                                                            ],
                                                          )),
                                                      Container(
                                                          margin:
                                                              EdgeInsets.only(
                                                                  top: 7),
                                                          child: Row(
                                                            children: [
                                                              Image.asset(
                                                                'assets/icons/distance.png',
                                                                width: 17,
                                                              ),
                                                              Padding(
                                                                padding: EdgeInsets
                                                                    .only(
                                                                        left:
                                                                            10),
                                                                child: Container(
                                                                    width: 150,
                                                                    child: Text(
                                                                        '${mapDistance[groupNearYou[index].party.id] != null ? mapDistance[groupNearYou[index].party.id].toStringAsFixed(2) : ""} Km',
                                                                        overflow:
                                                                            TextOverflow.ellipsis)),
                                                              )
                                                            ],
                                                          )),
                                                      Container(
                                                          margin:
                                                              EdgeInsets.only(
                                                                  top: 7),
                                                          child: Row(
                                                            children: [
                                                              Image.asset(
                                                                'assets/icons/member_15px.png',
                                                                width: 17,
                                                              ),
                                                              Padding(
                                                                padding: EdgeInsets
                                                                    .only(
                                                                        left:
                                                                            10),
                                                                child: Container(
                                                                    width: 150,
                                                                    child: Text(
                                                                        "2/" +
                                                                            groupNearYou[index]
                                                                                .party
                                                                                .maximum
                                                                                .toString(),
                                                                        overflow:
                                                                            TextOverflow.ellipsis)),
                                                              )
                                                            ],
                                                          )),
                                                    ],
                                                  )),
                                              Container(
                                                margin:
                                                    EdgeInsets.only(right: 20),
                                                child: ElevatedButton(
                                                  style:
                                                      ElevatedButton.styleFrom(
                                                          primary:
                                                              PrimaryColor),
                                                  child: Text("Chi Tiết"),
                                                  onPressed: () {
                                                    Provider.of<PartyListViewModel>(
                                                                context,
                                                                listen: false)
                                                            .currentParty =
                                                        groupNearYou[index];
                                                    Provider.of<PartyListViewModel>(
                                                                context,
                                                                listen: false)
                                                            .typeOfList =
                                                        "ViewDetailGroupNearYou";
                                                    return showDetailGroup();
                                                  },
                                                ),
                                              ),
                                            ],
                                          ),
                                          decoration: BoxDecoration(
                                            borderRadius:
                                                BorderRadius.circular(10),
                                            color: Colors.white,
                                            boxShadow: [
                                              BoxShadow(
                                                color: PrimaryColor.withOpacity(
                                                    0.5),
                                                spreadRadius: 2,
                                                blurRadius: 7,
                                                offset: Offset(0,
                                                    3), // changes position of shadow
                                              ),
                                            ],
                                          ),
                                        ));
                                  },
                                ),
                              )),
              ),

              // Container(
              //   margin: EdgeInsets.only(right: 20, left: 20),
              //   height: 400,
              //   child: ListView.builder(
              //     scrollDirection: Axis.vertical,
              //     itemCount: groupNearYou.length,
              //     itemBuilder: (BuildContext context, int index) {
              //       return InkWell(
              //           onTap: () {},
              //           child: Container(
              //             height: 110,
              //             margin: EdgeInsets.only(
              //                 right: 5, left: 5, bottom: 10, top: 10),
              //             child: Row(
              //               mainAxisAlignment: MainAxisAlignment.spaceBetween,
              //               children: [
              //                 Container(
              //                   margin: EdgeInsets.only(left: 20),
              //                   child: Icon(
              //                     Icons.people,
              //                     size: 35,
              //                   ),
              //                 ),
              //                 Container(
              //                     width: 180,
              //                     child: Column(
              //                       crossAxisAlignment:
              //                           CrossAxisAlignment.start,
              //                       children: [
              //                         Container(
              //                             width: 180,
              //                             margin: EdgeInsets.only(top: 13),
              //                             child: Container(
              //                                 child: Text(
              //                                     groupNearYou[index].title,
              //                                     style: TextStyle(
              //                                         fontWeight:
              //                                             FontWeight.bold),
              //                                     overflow:
              //                                         TextOverflow.ellipsis))),
              //                         Container(
              //                             width: 180,
              //                             margin: EdgeInsets.only(top: 7),
              //                             child: Row(
              //                               children: [
              //                                 Image.asset(
              //                                   'assets/icons/skill_15px.png',
              //                                   width: 17,
              //                                 ),
              //                                 Padding(
              //                                   padding:
              //                                       EdgeInsets.only(left: 10),
              //                                   child: Container(
              //                                       width: 150,
              //                                       child: Text(
              //                                           groupNearYou[index]
              //                                               .skill,
              //                                           overflow: TextOverflow
              //                                               .ellipsis)),
              //                                 )
              //                               ],
              //                             )),
              //                         Container(
              //                             margin: EdgeInsets.only(top: 7),
              //                             child: Row(
              //                               children: [
              //                                 Image.asset(
              //                                   'assets/icons/location_15px.png',
              //                                   width: 17,
              //                                 ),
              //                                 Padding(
              //                                   padding:
              //                                       EdgeInsets.only(left: 10),
              //                                   child: Container(
              //                                       width: 150,
              //                                       child: Text(
              //                                           groupNearYou[index]
              //                                               .location,
              //                                           overflow: TextOverflow
              //                                               .ellipsis)),
              //                                 )
              //                               ],
              //                             )),
              //                         Container(
              //                             margin: EdgeInsets.only(top: 7),
              //                             child: Row(
              //                               children: [
              //                                 Image.asset(
              //                                   'assets/icons/member_15px.png',
              //                                   width: 17,
              //                                 ),
              //                                 Padding(
              //                                   padding:
              //                                       EdgeInsets.only(left: 10),
              //                                   child: Container(
              //                                       width: 150,
              //                                       child: Text(
              //                                           groupNearYou[index]
              //                                               .size,
              //                                           overflow: TextOverflow
              //                                               .ellipsis)),
              //                                 )
              //                               ],
              //                             )),
              //                       ],
              //                     )),
              //                 Container(
              //                   margin: EdgeInsets.only(right: 20),
              //                   child: ElevatedButton(
              //                     style: ElevatedButton.styleFrom(
              //                         primary: PrimaryColor),
              //                     child: Text("Chi tiết"),
              //                     onPressed: () {
              //                       return showDetailGroup();
              //                     },
              //                   ),
              //                 ),
              //               ],
              //             ),
              //             decoration: BoxDecoration(
              //               borderRadius: BorderRadius.circular(10),
              //               color: Colors.white,
              //               boxShadow: [
              //                 BoxShadow(
              //                   color: PrimaryColor.withOpacity(0.5),
              //                   spreadRadius: 2,
              //                   blurRadius: 7,
              //                   offset:
              //                       Offset(0, 3), // changes position of shadow
              //                 ),
              //               ],
              //             ),
              //           ));
              //     },
              //   ),
              // ),
              Container(
                margin: EdgeInsets.only(left: 15, right: 15, top: 25),
                alignment: Alignment.centerLeft,
                child: Text(
                  'Tìm thành viên phù hợp',
                  textAlign: TextAlign.left,
                  style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 20,
                      color: PrimaryColor),
                ),
              ),
              Container(
                margin: EdgeInsets.all(10),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Image.asset(
                      'assets/icons/invite.png',
                      width: 170,
                    ),
                    Container(
                      child: Column(
                        children: [
                          Container(
                            width: 160,
                            margin: EdgeInsets.only(top: 20, bottom: 10),
                            child: Text(
                              "Bắt đầu 'mời dạo' thôi nào!",
                              style: TextStyle(
                                  fontWeight: FontWeight.bold, fontSize: 20),
                            ),
                          ),
                          ElevatedButton(
                              style: ButtonStyle(
                                  backgroundColor:
                                      MaterialStateProperty.all<Color>(Success),
                                  shape: MaterialStateProperty.all<
                                          RoundedRectangleBorder>(
                                      RoundedRectangleBorder(
                                          borderRadius:
                                              BorderRadius.circular(18.0),
                                          side: BorderSide(color: Success)))),
                              onPressed: () {
                                onRouter(FILTER_FOR_FINDING_GROUP);
                              },
                              child: Text(
                                'Tìm thành viên',
                                style: TextStyle(fontSize: 18),
                              ))
                        ],
                      ),
                    )
                  ],
                ),
              ),
              Container(
                margin: EdgeInsets.only(left: 15, right: 15, top: 25),
                alignment: Alignment.centerLeft,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Phù hợp với nhóm bạn',
                      textAlign: TextAlign.left,
                      style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 20,
                          color: PrimaryColor),
                    ),
                    InkWell(
                      onTap: () {
                        onRouter(MEMBER_CARD_ROUTE);
                      },
                      child: Icon(Icons.navigate_next, size: 40),
                    )
                  ],
                ),
              ),
              MiniSwipeCard(),
              SizedBox(
                height: 10,
              )
            ],
          ),
        )),
        appBar: PreferredSize(
            preferredSize: const Size(double.infinity, kToolbarHeight),
            child: AppBarMainWidget()));
  }
}
