import 'package:agora_rtc_engine/rtc_engine.dart';
import 'package:badges/badges.dart';
import 'package:flutter/material.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:provider/provider.dart';
import 'package:unilink_flutter_app/constant/path_router.dart';
import 'package:unilink_flutter_app/models/party_model.dart';
import 'package:unilink_flutter_app/models/topic_model.dart';
import 'package:unilink_flutter_app/pages/call_page.dart';
import 'package:unilink_flutter_app/utils/button.dart';
import 'package:unilink_flutter_app/utils/color.dart';
import 'package:unilink_flutter_app/utils/hex_color.dart';
import 'package:unilink_flutter_app/utils/spinner.dart';
import 'package:unilink_flutter_app/view_model/group_view_model.dart';
import 'package:unilink_flutter_app/view_model/member_view_model.dart';
import 'package:unilink_flutter_app/view_model/party_view_model.dart';
import 'package:unilink_flutter_app/view_model/topic_view_model.dart';
import 'package:unilink_flutter_app/widgets/app_bar_child_widget.dart';
import 'package:unilink_flutter_app/widgets/model_add_member.dart';
import 'package:unilink_flutter_app/widgets/model_create_topic.dart';
import 'package:unilink_flutter_app/widgets/model_delete_topic.dart';
import 'package:unilink_flutter_app/widgets/model_edit_topic.dart';
import 'package:unilink_flutter_app/widgets/model_quit_group.dart';
import 'package:unilink_flutter_app/widgets/page_title_widget.dart';
import 'package:unilink_flutter_app/view_model/post_view_model.dart';

class GroupPage extends StatefulWidget {
  @override
  _GroupPageState createState() => _GroupPageState();
}

class _GroupPageState extends State<GroupPage> {
  List<TopicViewModel> listTopic = <TopicViewModel>[];
  List<MemberViewModel> listMembers = [];
  bool isLoading = false;
  PartyViewModel data;
  showCreateTopic() {
    showDialog(
        context: context,
        builder: (context) {
          return ModelCreateTopic(
            callback: onRefresh,
          );
        });
  }

  showEditTopic() {
    showDialog(
        context: context,
        builder: (context) {
          return ModelEditTopic(callback: onRefresh);
        });
  }

  showDeleteTopic() {
    showDialog(
        context: context,
        builder: (context) {
          return ModelDeleteTopic(
            callback: onRefresh,
          );
        });
  }

  showMemberTopic() {
    showDialog(
        context: context,
        builder: (context) {
          return ModelAddMember();
        });
  }

  showQuitGroupDialog() {
    showDialog(
        context: context,
        builder: (context) {
          return ModelQuitGroup();
        });
  }

  void onRefresh() {
    setState(() {});
  }

  onRouter(String path) => Navigator.of(context).pushNamed(path);
  var members = [
    'assets/icons/avatar-long.jpg',
    'assets/icons/avatar-tuan.jpg',
    'assets/icons/avatar-tin.jpg',
    'assets/icons/avatar-vinh.jpg',
  ];
  int topicLength = 0;
  // ignore: deprecated_member_use
  List yourlist = new List();

  Future<void> _handleCameraAndMic(Permission permission) async {
    final status = await permission.request();
    print(status);
  }

  Future<void> onJoin(BuildContext context) async {
    // update input validation
    await _handleCameraAndMic(Permission.camera);
    await _handleCameraAndMic(Permission.microphone);
    // push video page with given channel name
    await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => CallPage(
          role: ClientRole.Broadcaster,
          channelName: Provider.of<PartyListViewModel>(context, listen: false)
              .currentParty
              .party
              .id,
        ),
      ),
    );
  }

  Future<List<TopicViewModel>> getTopicByParty() async {
    return await Provider.of<TopicListViewModel>(context, listen: false)
        .getTopicByParty(
            Provider.of<PartyListViewModel>(context, listen: false)
                .currentParty
                .party
                .id,
            "0",
            "0",
            "",
            "");
  }

  Future<Null> refreshList() async {
    await loadDetail();
    await Future.delayed(Duration(seconds: 2));
    List<TopicViewModel> listRefresh =
        await Provider.of<TopicListViewModel>(context, listen: false)
            .getTopicByParty(
                Provider.of<PartyListViewModel>(context, listen: false)
                    .currentParty
                    .party
                    .id,
                "0",
                "0",
                "",
                "");
    setState(() {
      listTopic = listRefresh;
    });
    return null;
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    loadDetail();
  }

  loadDetail() async {
    setState(() {
      isLoading = true;
    });
    String id = Provider.of<PartyListViewModel>(context, listen: false)
        .currentParty
        .party
        .id;
    listMembers = await Provider.of<PartyListViewModel>(context, listen: false)
        .getMemberInParty(id);
    await Provider.of<PartyListViewModel>(context, listen: false)
        .getPartyById(id);
    setState(() {
      isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    data = Provider.of<PartyListViewModel>(context).currentParty;
    return Scaffold(
        body: Container(
          child: Center(
              child: isLoading
                  ? Center(child: CircularProgressIndicator())
                  : Container(
                      decoration: BoxDecoration(color: Colors.white),
                      child: RefreshIndicator(
                        onRefresh: refreshList,
                        child: SingleChildScrollView(
                          child: Container(
                            color: Colors.white,
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Container(
                                    child: Column(
                                  children: [
                                    Stack(
                                      children: [
                                        Container(
                                            width: double.infinity,
                                            decoration: BoxDecoration(
                                              color: PrimaryColor,
                                            ),
                                            padding: EdgeInsets.only(
                                                left: 40.0,
                                                right: 40.0,
                                                bottom: 50.0),
                                            child: Row(
                                              children: [
                                                Container(
                                                    child: CircleAvatar(
                                                  radius: 40.0,
                                                  backgroundImage: (data.party
                                                                  .image !=
                                                              null &&
                                                          data.party.image !=
                                                              "")
                                                      ? NetworkImage(
                                                          "${data.party.image}")
                                                      : AssetImage(
                                                          "assets/icons/group-4.png"),
                                                )),
                                                Container(
                                                  margin:
                                                      EdgeInsets.only(left: 20),
                                                  child: Column(
                                                    children: [
                                                      Container(
                                                        width: 200,
                                                        padding:
                                                            const EdgeInsets
                                                                    .only(
                                                                right: 10.0,
                                                                bottom: 10.0),
                                                        child: Center(
                                                          child: Text(
                                                              data.party.name,
                                                              overflow:
                                                                  TextOverflow
                                                                      .ellipsis,
                                                              softWrap: false,
                                                              style: TextStyle(
                                                                  color: Colors
                                                                      .white,
                                                                  fontSize: 25,
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .bold)),
                                                        ),
                                                      ),
                                                      Row(
                                                        children: [
                                                          Container(
                                                            padding:
                                                                const EdgeInsets
                                                                        .only(
                                                                    bottom:
                                                                        10.0),
                                                            child: Text(
                                                                data.party.major
                                                                    .name,
                                                                style: TextStyle(
                                                                    color: Colors
                                                                        .white,
                                                                    fontSize:
                                                                        15,
                                                                    fontWeight:
                                                                        FontWeight
                                                                            .bold)),
                                                          ),
                                                        ],
                                                      ),
                                                      Row(
                                                        children: [
                                                          Container(
                                                            child: Text(
                                                                data.party
                                                                        .currentMember
                                                                        .toString() +
                                                                    "/" +
                                                                    data.party
                                                                        .maximum
                                                                        .toString() +
                                                                    " members",
                                                                style: TextStyle(
                                                                    color: Colors
                                                                        .white,
                                                                    fontSize:
                                                                        15,
                                                                    fontWeight:
                                                                        FontWeight
                                                                            .bold)),
                                                          ),
                                                        ],
                                                      ),
                                                      Row(
                                                        children: [
                                                          Container(
                                                              margin: EdgeInsets
                                                                  .only(
                                                                      bottom:
                                                                          5),
                                                              child: Wrap(
                                                                children: [
                                                                  for (var i
                                                                      in data
                                                                          .party
                                                                          .skills)
                                                                    Container(
                                                                      margin: EdgeInsets.only(
                                                                          right:
                                                                              5),
                                                                      child:
                                                                          Chip(
                                                                        padding:
                                                                            EdgeInsets.all(0),
                                                                        backgroundColor:
                                                                            Colors.white,
                                                                        label: Text(
                                                                            i.name,
                                                                            style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold)),
                                                                      ),
                                                                    ),
                                                                ],
                                                              )),
                                                        ],
                                                      )
                                                    ],
                                                  ),
                                                ),
                                              ],
                                            )),
                                        Container(
                                          margin: EdgeInsets.only(
                                              left: 20, right: 20, bottom: 30),
                                          decoration: BoxDecoration(
                                            borderRadius:
                                                BorderRadius.circular(20),
                                            boxShadow: [
                                              BoxShadow(
                                                color: PrimaryColor.withOpacity(
                                                    0.2),
                                                spreadRadius: 5,
                                                blurRadius: 10,
                                                offset: Offset(0,
                                                    3), // changes position of shadow
                                              ),
                                            ],
                                          ),
                                          child: Container(
                                            margin: EdgeInsets.only(
                                                top: 160, left: 10, right: 10),
                                            decoration: BoxDecoration(
                                                color: Colors.white,
                                                borderRadius:
                                                    BorderRadius.circular(20)),
                                            padding: EdgeInsets.all(2.0),
                                            child: Center(
                                                child: Padding(
                                              padding: EdgeInsets.all(20),
                                              child: Text(
                                                data.party.description,
                                                textAlign: TextAlign.center,
                                                style: TextStyle(fontSize: 20),
                                              ),
                                            )),
                                          ),
                                        ),
                                      ],
                                    )
                                  ],
                                )),
                                Container(
                                  height: 230,
                                  child: GridView.count(
                                    primary: false,
                                    padding: const EdgeInsets.only(
                                        top: 5, bottom: 10),
                                    mainAxisSpacing: 5,
                                    crossAxisCount: 4,
                                    children: [
                                      InkWell(
                                        child: Container(
                                          width: 60,
                                          height: 100,
                                          margin: EdgeInsets.only(
                                              left: 10, right: 10, bottom: 10),
                                          child: Column(
                                            children: [
                                              Container(
                                                  margin: EdgeInsets.only(
                                                      bottom: 10),
                                                  padding: EdgeInsets.all(10),
                                                  decoration: BoxDecoration(
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            10),
                                                    color: Colors.white,
                                                    boxShadow: [
                                                      BoxShadow(
                                                        color: PrimaryColor
                                                            .withOpacity(0.5),
                                                        spreadRadius: 5,
                                                        blurRadius: 7,
                                                        offset: Offset(0,
                                                            3), // changes position of shadow
                                                      ),
                                                    ],
                                                  ),
                                                  child: Image.asset(
                                                    "assets/icons/mute-notify-1.png",
                                                    width: 34,
                                                    height: 36,
                                                  )),
                                              Text(
                                                "Tắt thông báo",
                                                textAlign: TextAlign.center,
                                                style: TextStyle(
                                                  fontWeight: FontWeight.bold,
                                                  fontSize: 12,
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                      ),
                                      InkWell(
                                        onTap: () {
                                          Navigator.of(context)
                                              .pushNamed(NOTE_PAGE_ROUTE);
                                        },
                                        child: Container(
                                          width: 60,
                                          height: 100,
                                          margin: EdgeInsets.only(
                                              left: 10, right: 10, bottom: 10),
                                          child: Column(
                                            children: [
                                              Container(
                                                  padding: EdgeInsets.all(10),
                                                  margin: EdgeInsets.only(
                                                      bottom: 10),
                                                  decoration: BoxDecoration(
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            10),
                                                    color: Colors.white,
                                                    boxShadow: [
                                                      BoxShadow(
                                                        color: PrimaryColor
                                                            .withOpacity(0.5),
                                                        spreadRadius: 5,
                                                        blurRadius: 7,
                                                        offset: Offset(0,
                                                            3), // changes position of shadow
                                                      ),
                                                    ],
                                                  ),
                                                  child: Image.asset(
                                                    "assets/icons/note-1.png",
                                                    width: 34,
                                                    height: 36,
                                                  )),
                                              Text(
                                                "Ghi chú",
                                                style: TextStyle(
                                                    fontWeight: FontWeight.bold,
                                                    fontSize: 12),
                                              )
                                            ],
                                          ),
                                        ),
                                      ),
                                      InkWell(
                                        onTap: () {
                                          onRouter(GROUP_MEMBER_PAGE_ROUTE);
                                        },
                                        child: Container(
                                          width: 60,
                                          height: 100,
                                          margin: EdgeInsets.only(
                                              left: 10, right: 10, bottom: 10),
                                          child: Column(
                                            children: [
                                              Container(
                                                  padding: EdgeInsets.all(10),
                                                  margin: EdgeInsets.only(
                                                      bottom: 10),
                                                  decoration: BoxDecoration(
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            10),
                                                    color: Colors.white,
                                                    boxShadow: [
                                                      BoxShadow(
                                                        color: PrimaryColor
                                                            .withOpacity(0.5),
                                                        spreadRadius: 5,
                                                        blurRadius: 7,
                                                        offset: Offset(0,
                                                            3), // changes position of shadow
                                                      ),
                                                    ],
                                                  ),
                                                  child: Image.asset(
                                                    "assets/icons/invite-1.png",
                                                    width: 34,
                                                    height: 36,
                                                  )),
                                              Text(
                                                "Thành viên",
                                                textAlign: TextAlign.center,
                                                style: TextStyle(
                                                    fontWeight: FontWeight.bold,
                                                    fontSize: 12),
                                              )
                                            ],
                                          ),
                                        ),
                                      ),
                                      InkWell(
                                        onTap: () {
                                          onRouter(GROUP_EDIT_PAGE_ROUTE);
                                        },
                                        child: Container(
                                          width: 60,
                                          height: 100,
                                          margin: EdgeInsets.only(
                                              left: 10, right: 10, bottom: 10),
                                          child: Column(
                                            children: [
                                              Container(
                                                  padding: EdgeInsets.all(10),
                                                  margin: EdgeInsets.only(
                                                      bottom: 10),
                                                  decoration: BoxDecoration(
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            10),
                                                    color: Colors.white,
                                                    boxShadow: [
                                                      BoxShadow(
                                                        color: PrimaryColor
                                                            .withOpacity(0.5),
                                                        spreadRadius: 5,
                                                        blurRadius: 7,
                                                        offset: Offset(0,
                                                            3), // changes position of shadow
                                                      ),
                                                    ],
                                                  ),
                                                  child: Image.asset(
                                                    "assets/icons/group_image.png",
                                                    width: 34,
                                                    height: 36,
                                                  )),
                                              Text(
                                                "Cập nhật nhóm",
                                                textAlign: TextAlign.center,
                                                style: TextStyle(
                                                    fontWeight: FontWeight.bold,
                                                    fontSize: 12),
                                              )
                                            ],
                                          ),
                                        ),
                                      ),
                                      InkWell(
                                        onTap: () {
                                          Navigator.of(context)
                                              .pushNamed(PARTY_INVITATION_PAGE);
                                        },
                                        child: Container(
                                          width: 60,
                                          height: 100,
                                          margin: EdgeInsets.only(
                                              left: 10, right: 10, bottom: 10),
                                          child: Column(
                                            children: [
                                              Container(
                                                  padding: EdgeInsets.all(10),
                                                  margin: EdgeInsets.only(
                                                      bottom: 10),
                                                  decoration: BoxDecoration(
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            10),
                                                    color: Colors.white,
                                                    boxShadow: [
                                                      BoxShadow(
                                                        color: PrimaryColor
                                                            .withOpacity(0.5),
                                                        spreadRadius: 5,
                                                        blurRadius: 7,
                                                        offset: Offset(0,
                                                            3), // changes position of shadow
                                                      ),
                                                    ],
                                                  ),
                                                  child: Image.asset(
                                                    "assets/icons/invite-3.png",
                                                    width: 34,
                                                    height: 36,
                                                  )),
                                              Text(
                                                "Lời mời đã gởi",
                                                style: TextStyle(
                                                    fontWeight: FontWeight.bold,
                                                    fontSize: 12),
                                              )
                                            ],
                                          ),
                                        ),
                                      ),
                                      InkWell(
                                        onTap: () {
                                          return showQuitGroupDialog();
                                        },
                                        child: Container(
                                          width: 60,
                                          height: 100,
                                          margin: EdgeInsets.only(
                                              left: 10, right: 10, bottom: 10),
                                          child: Column(
                                            children: [
                                              Container(
                                                  padding: EdgeInsets.all(10),
                                                  margin: EdgeInsets.only(
                                                      bottom: 10),
                                                  decoration: BoxDecoration(
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            10),
                                                    color: Colors.white,
                                                    boxShadow: [
                                                      BoxShadow(
                                                        color: PrimaryColor
                                                            .withOpacity(0.5),
                                                        spreadRadius: 5,
                                                        blurRadius: 7,
                                                        offset: Offset(0,
                                                            3), // changes position of shadow
                                                      ),
                                                    ],
                                                  ),
                                                  child: Image.asset(
                                                    "assets/icons/out-1.png",
                                                    width: 34,
                                                    height: 36,
                                                  )),
                                              Text(
                                                "Rời nhóm",
                                                style: TextStyle(
                                                    fontWeight: FontWeight.bold,
                                                    fontSize: 12),
                                              )
                                            ],
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                Container(
                                  alignment: Alignment.topLeft,
                                  margin: EdgeInsets.only(
                                      top: 10, left: 20, bottom: 20, right: 20),
                                  child: Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceAround,
                                    children: [
                                      InkWell(
                                        onTap: () {
                                          onJoin(context);
                                        },
                                        child: Column(
                                          children: [
                                            Container(
                                                padding: EdgeInsets.all(10),
                                                margin:
                                                    EdgeInsets.only(bottom: 10),
                                                decoration: BoxDecoration(
                                                  borderRadius:
                                                      BorderRadius.circular(35),
                                                  color: Colors.white,
                                                  boxShadow: [
                                                    BoxShadow(
                                                      color: PrimaryColor
                                                          .withOpacity(0.5),
                                                      spreadRadius: 5,
                                                      blurRadius: 7,
                                                      offset: Offset(0,
                                                          3), // changes position of shadow
                                                    ),
                                                  ],
                                                ),
                                                child: Image.asset(
                                                  "assets/icons/video-1.png",
                                                  width: 70,
                                                  height: 70,
                                                )),
                                            Text(
                                              "Gọi nhóm",
                                              style: TextStyle(
                                                  fontWeight: FontWeight.bold,
                                                  fontSize: 14),
                                            )
                                          ],
                                        ),
                                      ),
                                      InkWell(
                                        onTap: () {
                                          Navigator.of(context).pushNamed(
                                              CHAT_DETAIL_ROUTE,
                                              arguments: GROUP_ROUTE);
                                        },
                                        child: Column(
                                          children: [
                                            Container(
                                                padding: EdgeInsets.all(10),
                                                margin:
                                                    EdgeInsets.only(bottom: 10),
                                                decoration: BoxDecoration(
                                                  borderRadius:
                                                      BorderRadius.circular(35),
                                                  color: Colors.white,
                                                  boxShadow: [
                                                    BoxShadow(
                                                      color: PrimaryColor
                                                          .withOpacity(0.5),
                                                      spreadRadius: 5,
                                                      blurRadius: 7,
                                                      offset: Offset(0,
                                                          3), // changes position of shadow
                                                    ),
                                                  ],
                                                ),
                                                child: Image.asset(
                                                  "assets/icons/chat-1.png",
                                                  width: 70,
                                                  height: 70,
                                                )),
                                            Text(
                                              "Tin nhắn",
                                              style: TextStyle(
                                                  fontWeight: FontWeight.bold,
                                                  fontSize: 14),
                                            )
                                          ],
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                Container(
                                  alignment: Alignment.topLeft,
                                  margin: EdgeInsets.only(
                                      top: 10, left: 20, bottom: 20, right: 20),
                                  child: Text(
                                    "Thành viên (${listMembers.length})",
                                    style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 20),
                                  ),
                                ),
                                Container(
                                  height: 100,
                                  child: ListView.builder(
                                    scrollDirection: Axis.horizontal,
                                    itemCount: listMembers.length,
                                    itemBuilder:
                                        (BuildContext context, int index) {
                                      return InkWell(
                                        onTap: () {
                                          Provider.of<MemberListViewModel>(
                                                      context,
                                                      listen: false)
                                                  .memberId =
                                              listMembers[index].member.id;
                                          onRouter(
                                              OTHER_PROFILE_INGROUP_PAGE_ROUTE);
                                        },
                                        child: Container(
                                          alignment: Alignment.bottomLeft,
                                          margin: EdgeInsets.all(10),
                                          child: Container(
                                            height: 100,
                                            child: Column(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.end,
                                              children: [
                                                Container(
                                                  child: Row(
                                                    mainAxisAlignment:
                                                        MainAxisAlignment
                                                            .spaceBetween,
                                                    children: [
                                                      InkWell(
                                                        onTap: () {},
                                                        child: Container(
                                                          alignment: Alignment
                                                              .bottomRight,
                                                          margin:
                                                              EdgeInsets.only(
                                                                  right: 20),
                                                          decoration:
                                                              BoxDecoration(
                                                            boxShadow: [
                                                              BoxShadow(
                                                                color: PrimaryColor
                                                                    .withOpacity(
                                                                        0.5),
                                                                spreadRadius: 4,
                                                                blurRadius: 6,
                                                                offset: Offset(
                                                                    0,
                                                                    3), // changes position of shadow
                                                              ),
                                                            ],
                                                          ),
                                                          child: Badge(
                                                            badgeColor: HexColor
                                                                .fromHex(
                                                                    "#2dce89"),
                                                            padding:
                                                                EdgeInsets.all(
                                                                    12),
                                                          ),
                                                        ),
                                                      )
                                                    ],
                                                  ),
                                                )
                                              ],
                                            ),
                                          ),
                                          width: 80,
                                          decoration: BoxDecoration(
                                            borderRadius:
                                                BorderRadius.circular(50),
                                            color: Colors.white,
                                            image: DecorationImage(
                                              image: (listMembers[index]
                                                              .member
                                                              .avatar !=
                                                          null &&
                                                      listMembers[index]
                                                              .member
                                                              .avatar !=
                                                          "")
                                                  ? NetworkImage(
                                                      "${listMembers[index].member.avatar}")
                                                  : AssetImage(
                                                      "assets/icons/user-1.png",
                                                    ),
                                              fit: BoxFit.cover,
                                            ),
                                            boxShadow: [
                                              BoxShadow(
                                                color: PrimaryColor.withOpacity(
                                                    0.5),
                                                spreadRadius: 4,
                                                blurRadius: 6,
                                                offset: Offset(0,
                                                    3), // changes position of shadow
                                              ),
                                            ],
                                          ),
                                        ),
                                      );
                                    },
                                  ),
                                ),
                                Container(
                                    alignment: Alignment.topLeft,
                                    margin: EdgeInsets.only(
                                        top: 20, left: 20, right: 20),
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        Text("Topic",
                                            style: TextStyle(
                                                fontSize: 20,
                                                fontWeight: FontWeight.bold)),
                                        ElevatedButton(
                                          onPressed: () {
                                            return showCreateTopic();
                                          },
                                          child: Text(
                                            'Tạo Topic',
                                            style: TextStyle(
                                                fontSize: 17,
                                                fontWeight: FontWeight.bold),
                                          ),
                                          style: getStyleElevatedButton(
                                              type: ButtonType.PRIMARY_COLOR,
                                              radius: 10),
                                        )
                                      ],
                                    )),
                                Container(
                                    margin: EdgeInsets.all(10),
                                    padding: EdgeInsets.all(5),
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(10),
                                      color: Colors.white,
                                      // boxShadow: [
                                      //   BoxShadow(
                                      //     color: PrimaryColor.withOpacity(0.1),
                                      //     spreadRadius: 5,
                                      //     blurRadius: 7,
                                      //     offset: Offset(0, 3), // changes position of shadow
                                      //   ),
                                      // ],
                                    ),
                                    height: 500,
                                    child: Spinner.spinnerWithFuture(
                                      getTopicByParty(),
                                      (data) {
                                        List<TopicViewModel> listTopic = data;
                                        return listTopic.isEmpty
                                            ? Text("Chưa có topic",
                                                style: TextStyle(
                                                    fontWeight: FontWeight.bold,
                                                    fontSize: 30))
                                            : ListView.builder(
                                                scrollDirection: Axis.vertical,
                                                itemCount: listTopic.length,
                                                itemBuilder:
                                                    (BuildContext context,
                                                        int index) {
                                                  return InkWell(
                                                    onTap: () {
                                                      Provider.of<PostListViewModel>(
                                                              context,
                                                              listen: false)
                                                          .setTopicId(
                                                              listTopic[index]
                                                                  .topic
                                                                  .id);
                                                      onRouter(
                                                          POST_QUESTION_ANSWER);
                                                    },
                                                    child: Container(
                                                      alignment:
                                                          Alignment.bottomLeft,
                                                      margin:
                                                          EdgeInsets.all(10),
                                                      child: Container(
                                                        height: 100,
                                                        padding:
                                                            EdgeInsets.all(20),
                                                        child: Column(
                                                          mainAxisAlignment:
                                                              MainAxisAlignment
                                                                  .center,
                                                          children: [
                                                            Container(
                                                              child: Row(
                                                                mainAxisAlignment:
                                                                    MainAxisAlignment
                                                                        .spaceBetween,
                                                                children: [
                                                                  Container(
                                                                    child: Text(
                                                                      listTopic[
                                                                              index]
                                                                          .topic
                                                                          .title,
                                                                      style: TextStyle(
                                                                          fontWeight: FontWeight
                                                                              .bold,
                                                                          fontSize:
                                                                              17),
                                                                    ),
                                                                  ),
                                                                  Container(
                                                                      alignment:
                                                                          Alignment
                                                                              .centerRight,
                                                                      margin: EdgeInsets.only(
                                                                          right:
                                                                              10),
                                                                      child: Container(
                                                                          child: Row(
                                                                        children: [
                                                                          Image
                                                                              .asset(
                                                                            'assets/icons/notify-2.png',
                                                                            width:
                                                                                30,
                                                                            height:
                                                                                30,
                                                                          ),
                                                                          Container(
                                                                              alignment: Alignment.bottomRight,
                                                                              margin: EdgeInsets.only(right: 10),
                                                                              child: Container(
                                                                                child: Badge(
                                                                                  toAnimate: false,
                                                                                  shape: BadgeShape.circle,
                                                                                  badgeColor: HexColor.fromHex("#eb4034"),
                                                                                  borderRadius: BorderRadius.circular(8),
                                                                                  badgeContent: Text('12', style: TextStyle(color: Colors.white)),
                                                                                ),
                                                                              )),
                                                                          Container(
                                                                            padding:
                                                                                EdgeInsets.only(right: 10),
                                                                            height:
                                                                                30,
                                                                            width:
                                                                                30,
                                                                            decoration:
                                                                                BoxDecoration(
                                                                              image: DecorationImage(
                                                                                image: AssetImage('assets/icons/setting.png'),
                                                                              ),
                                                                            ),
                                                                            child:
                                                                                InkWell(
                                                                              onTap: () {
                                                                                Provider.of<TopicListViewModel>(context, listen: false).topicName = listTopic[index].topic.title;
                                                                                Provider.of<TopicListViewModel>(context, listen: false).description = listTopic[index].topic.description;
                                                                                Provider.of<TopicListViewModel>(context, listen: false).topicId = listTopic[index].topic.id;
                                                                                return showEditTopic();
                                                                              },
                                                                            ),
                                                                          ),
                                                                          Container(
                                                                            padding:
                                                                                EdgeInsets.only(right: 10),
                                                                            height:
                                                                                30,
                                                                            width:
                                                                                30,
                                                                            decoration:
                                                                                BoxDecoration(
                                                                              image: DecorationImage(
                                                                                image: AssetImage('assets/icons/delete.png'),
                                                                              ),
                                                                            ),
                                                                            child:
                                                                                InkWell(
                                                                              onTap: () {
                                                                                Provider.of<TopicListViewModel>(context, listen: false).topicName = listTopic[index].topic.title;
                                                                                Provider.of<TopicListViewModel>(context, listen: false).description = listTopic[index].topic.description;
                                                                                Provider.of<TopicListViewModel>(context, listen: false).topicId = listTopic[index].topic.id;
                                                                                return showDeleteTopic();
                                                                              },
                                                                            ),
                                                                          ),
                                                                        ],
                                                                      ))),
                                                                ],
                                                              ),
                                                            )
                                                          ],
                                                        ),
                                                      ),
                                                      width: 80,
                                                      decoration: BoxDecoration(
                                                        borderRadius:
                                                            BorderRadius
                                                                .circular(10),
                                                        color: Colors.white,
                                                        boxShadow: [
                                                          BoxShadow(
                                                            color: PrimaryColor
                                                                .withOpacity(
                                                                    0.5),
                                                            spreadRadius: 4,
                                                            blurRadius: 6,
                                                            offset: Offset(0,
                                                                3), // changes position of shadow
                                                          ),
                                                        ],
                                                      ),
                                                    ),
                                                  );
                                                },
                                              );
                                      },
                                    )),
                              ],
                            ),
                          ),
                        ),
                      ),
                    )),
        ),
        appBar: PreferredSize(
            preferredSize: const Size(double.infinity, kToolbarHeight),
            child: AppBarChildWidget(
              path: MAIN_ROUTE,
              indexScreen: 1,
              color: PrimaryColor,
            )));
  }
}
