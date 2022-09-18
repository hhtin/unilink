import 'package:agora_rtc_engine/rtc_engine.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:provider/provider.dart';
import 'package:unilink_flutter_app/constant/path_router.dart';
import 'package:unilink_flutter_app/models/party_model.dart';
import 'package:unilink_flutter_app/pages/call_page.dart';
import 'package:unilink_flutter_app/translate/vn.dart';
import 'package:unilink_flutter_app/utils/color.dart';
import 'package:unilink_flutter_app/utils/hex_color.dart';
import 'package:unilink_flutter_app/utils/spinner.dart';
import 'package:unilink_flutter_app/view_model/group_view_model.dart';
import 'package:unilink_flutter_app/view_model/member_view_model.dart';
import 'package:unilink_flutter_app/view_model/party_view_model.dart';
import 'package:unilink_flutter_app/view_model/topic_view_model.dart';
import 'package:unilink_flutter_app/widgets/app_bar_main_widget.dart';
import 'package:unilink_flutter_app/widgets/page_title_widget.dart';

class GroupsPage extends StatefulWidget {
  @override
  _GroupsPageState createState() => _GroupsPageState();
}

class _GroupsPageState extends State<GroupsPage> {
  String groupId = "";
  List<PartyViewModel> listParties = [];
  bool isLoading = false;
  @override
  void initState() {
    super.initState();
    getPartiesByMemberId();
  }

  Future<void> getPartiesByMemberId() async {
    setState(() {
      isLoading = true;
    });
    String id =
        Provider.of<MemberListViewModel>(context, listen: false).identifier;
    List<PartyViewModel> listPartiesTemp =
        await Provider.of<PartyListViewModel>(context, listen: false)
            .getPartyByMemberId(id);
    setState(() {
      listParties = listPartiesTemp;
      isLoading = false;
    });
  }

  onRouter(String path) => Navigator.of(context).pushNamed(path);
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: PreferredSize(
            preferredSize: const Size(double.infinity, kToolbarHeight),
            child: AppBarMainWidget()),
        body: Center(
            child: isLoading
                ? CircularProgressIndicator()
                : Container(
                    color: Colors.white,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        PageTitleWidget(title: LABLE_MY_GROUP),
                        Expanded(
                          child: Container(
                            margin: EdgeInsets.only(right: 10, left: 10),
                            child: RefreshIndicator(
                              onRefresh: () => getPartiesByMemberId(),
                              child: GridView.builder(
                                gridDelegate:
                                    SliverGridDelegateWithFixedCrossAxisCount(
                                        crossAxisCount: 2,
                                        crossAxisSpacing: 5,
                                        mainAxisSpacing: 5),
                                shrinkWrap: true,
                                scrollDirection: Axis.vertical,
                                itemCount: listParties.length,
                                itemBuilder: (BuildContext context, int index) {
                                  return InkWell(
                                      onTap: () {
                                        Provider.of<PartyListViewModel>(context,
                                                listen: false)
                                            .currentParty = listParties[index];
                                        Navigator.of(context)
                                            .pushNamed(GROUP_ROUTE);
                                      },
                                      child: Container(
                                          margin: EdgeInsets.only(
                                              right: 10,
                                              left: 10,
                                              bottom: 15,
                                              top: 15),
                                          child: Column(
                                            children: [
                                              Container(
                                                child: Column(
                                                  children: [
                                                    Container(
                                                        margin: EdgeInsets.only(
                                                            top: 10),
                                                        child: CircleAvatar(
                                                          radius: 30.0,
                                                          backgroundImage: (listParties[
                                                                              index]
                                                                          .party
                                                                          .image !=
                                                                      null &&
                                                                  listParties[index]
                                                                          .party
                                                                          .image !=
                                                                      "")
                                                              ? NetworkImage(
                                                                  listParties[
                                                                          index]
                                                                      .party
                                                                      .image)
                                                              : AssetImage(
                                                                  "assets/icons/group-4.png"),
                                                        )),
                                                    Container(
                                                      padding: EdgeInsets.only(
                                                          top: 10,
                                                          left: 10,
                                                          right: 10),
                                                      child: Column(
                                                        mainAxisAlignment:
                                                            MainAxisAlignment
                                                                .center,
                                                        children: [
                                                          Container(
                                                              child: Container(
                                                                  child: Text(
                                                                      listParties[
                                                                              index]
                                                                          .party
                                                                          .name,
                                                                      style: TextStyle(
                                                                          color: Colors
                                                                              .white,
                                                                          fontSize:
                                                                              25,
                                                                          fontWeight: FontWeight
                                                                              .bold),
                                                                      overflow:
                                                                          TextOverflow
                                                                              .ellipsis))),

                                                          Container(
                                                            margin:
                                                                EdgeInsets.only(
                                                                    top: 7),
                                                            child: Container(
                                                              child: Text(
                                                                listParties[index]
                                                                        .party
                                                                        .currentMember
                                                                        .toString() +
                                                                    "/" +
                                                                    listParties[
                                                                            index]
                                                                        .party
                                                                        .maximum
                                                                        .toString() +
                                                                    " members",
                                                                style: TextStyle(
                                                                    fontSize:
                                                                        20,
                                                                    color: Colors
                                                                        .white,
                                                                    fontWeight:
                                                                        FontWeight
                                                                            .bold),
                                                              ),
                                                            ),
                                                          ),

                                                          // Container(
                                                          //   margin:
                                                          //       EdgeInsets.only(top: 7),
                                                          //   child: Row(
                                                          //     children: [
                                                          //       Image.asset(
                                                          //         'assets/icons/location_15px.png',
                                                          //         width: 20,
                                                          //       ),
                                                          //       Padding(
                                                          //         padding:
                                                          //             EdgeInsets.only(
                                                          //                 left: 10),
                                                          //         child: Container(
                                                          //           child: Text("HCM",
                                                          //               style: TextStyle(
                                                          //                   fontSize: 18),
                                                          //               overflow:
                                                          //                   TextOverflow
                                                          //                       .ellipsis),
                                                          //         ),
                                                          //       )
                                                          //     ],
                                                          //   ),
                                                          // ),
                                                        ],
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                              ),
                                              // Container(
                                              //   child: Column(
                                              //     mainAxisAlignment:
                                              //         MainAxisAlignment.center,
                                              //     children: [
                                              //       groupNearYou[index].isCalling == true
                                              //           ? (Container(
                                              //               child: Column(
                                              //                 mainAxisAlignment:
                                              //                     MainAxisAlignment.center,
                                              //                 children: [
                                              //                   Container(
                                              //                     alignment:
                                              //                         Alignment.center,
                                              //                     height: 40,
                                              //                     width: 100,
                                              //                     margin: EdgeInsets.only(
                                              //                         right: 20),
                                              //                     padding: EdgeInsets.only(
                                              //                         left: 20),
                                              //                     decoration: BoxDecoration(
                                              //                         color:
                                              //                             HexColor.fromHex(
                                              //                                 "#88ba97"),
                                              //                         borderRadius:
                                              //                             BorderRadius.all(
                                              //                                 Radius
                                              //                                     .circular(
                                              //                                         5))),
                                              //                     child: InkWell(
                                              //                       onTap: () {
                                              //                         onJoin(context);
                                              //                       },
                                              //                       child: Row(
                                              //                         children: [
                                              //                           Container(
                                              //                             child: Icon(
                                              //                               Icons.call,
                                              //                               color: Colors
                                              //                                   .white,
                                              //                             ),
                                              //                           ),
                                              //                           Container(
                                              //                             padding: EdgeInsets
                                              //                                 .only(
                                              //                                     left: 5),
                                              //                             child: Text(
                                              //                               "Join",
                                              //                               style: TextStyle(
                                              //                                   color: Colors
                                              //                                       .white,
                                              //                                   fontWeight:
                                              //                                       FontWeight
                                              //                                           .bold,
                                              //                                   fontSize:
                                              //                                       14),
                                              //                             ),
                                              //                           )
                                              //                         ],
                                              //                       ),
                                              //                     ),
                                              //                   ),
                                              //                   Container(
                                              //                     padding: EdgeInsets.only(
                                              //                         right: 10, top: 5),
                                              //                     child: Row(
                                              //                       children: [
                                              //                         Text(
                                              //                           "2",
                                              //                           textAlign: TextAlign
                                              //                               .center,
                                              //                           style: TextStyle(
                                              //                               fontSize: 15,
                                              //                               color: Colors
                                              //                                   .green,
                                              //                               fontWeight:
                                              //                                   FontWeight
                                              //                                       .bold),
                                              //                         ),
                                              //                         Text(
                                              //                           "/5",
                                              //                           textAlign: TextAlign
                                              //                               .center,
                                              //                           style: TextStyle(
                                              //                               fontSize: 15,
                                              //                               fontWeight:
                                              //                                   FontWeight
                                              //                                       .bold),
                                              //                         ),
                                              //                         SizedBox(
                                              //                           width: 5,
                                              //                         ),
                                              //                         Icon(
                                              //                           Icons.circle,
                                              //                           color: Error,
                                              //                           size: 18,
                                              //                         )
                                              //                       ],
                                              //                     ),
                                              //                   )
                                              //                 ],
                                              //               ),
                                              //             ))
                                              //           : Container()
                                              //     ],
                                              //   ),
                                              // )
                                            ],
                                          ),
                                          decoration: BoxDecoration(
                                            borderRadius:
                                                BorderRadius.circular(10),
                                            color: HexColor.fromHex("#8abf98"),
                                            boxShadow: [
                                              BoxShadow(
                                                color: Colors.grey
                                                    .withOpacity(0.3),
                                                spreadRadius: 2,
                                                blurRadius: 8,
                                                offset: Offset(5.0,
                                                    5.0), // changes position of shadow
                                              ),
                                            ],
                                          )));
                                },
                              ),
                            ),
                          ),
                        )
                      ],
                    ),
                  )));
  }
}
