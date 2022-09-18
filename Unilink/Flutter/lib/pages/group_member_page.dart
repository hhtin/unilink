import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:provider/provider.dart';
import 'package:unilink_flutter_app/constant/path_router.dart';
import 'package:unilink_flutter_app/translate/vn.dart';
import 'package:unilink_flutter_app/utils/asset_icon.dart';
import 'package:unilink_flutter_app/utils/button.dart';
import 'package:unilink_flutter_app/utils/color.dart';
import 'package:unilink_flutter_app/utils/spinner.dart';
import 'package:unilink_flutter_app/view_model/group_view_model.dart';
import 'package:unilink_flutter_app/view_model/member_view_model.dart';
import 'package:unilink_flutter_app/view_model/party_view_model.dart';
import 'package:unilink_flutter_app/widgets/app_bar_child_widget.dart';
import 'package:unilink_flutter_app/widgets/app_bar_main_widget.dart';
import 'package:unilink_flutter_app/widgets/model_add_member.dart';
import 'package:unilink_flutter_app/widgets/model_out_of_group.dart';
import 'package:unilink_flutter_app/widgets/page_title_widget.dart';

class GroupMemberPage extends StatefulWidget {
  @override
  _GroupMemberPageState createState() => _GroupMemberPageState();
}

class MemberInfo {
  String avatar;
  String name;
  String skill;
  String major;
  String school;
  MemberInfo(
      {@required this.avatar,
      @required this.name,
      @required this.skill,
      @required this.major,
      @required this.school});
}

class _GroupMemberPageState extends State<GroupMemberPage> {
  bool isLoad = false;
  List<MemberViewModel> data;
  showMemberTopic() {
    showDialog(
        context: context,
        builder: (context) {
          return ModelAddMember();
        });
  }

  showQuitGroup() {
    showDialog(
        context: context,
        builder: (context) {
          return ModelOutOfGroup(callback: getMemberInParty);
        });
  }

  List<MemberInfo> listMember = [
    MemberInfo(
        avatar: getPathOfIcon("avatar-vinh.jpg"),
        name: "Vinh",
        skill: "C#,Java,C++",
        major: "Software Engineer",
        school: "FPT University"),
    MemberInfo(
        avatar: getPathOfIcon("avatar-long.jpg"),
        name: "Long",
        skill: "C#,Java,Flutter",
        major: "Software Engineer",
        school: "FPT University"),
    MemberInfo(
        avatar: getPathOfIcon("avatar-tuan.jpg"),
        name: "Tuấn",
        skill: "C#,Java,Flutter",
        major: "Software Engineer",
        school: "FPT University"),
    MemberInfo(
        avatar: getPathOfIcon("avatar-tin.jpg"),
        name: "Tín",
        skill: "C#,Java,Flutter",
        major: "Software Engineer",
        school: "FPT University"),
  ];
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getMemberInParty();
  }

  Future<List<MemberViewModel>> getMemberInParty() async {
    setState(() {
      isLoad = true;
    });
    String id =
        Provider.of<MemberListViewModel>(context, listen: false).identifier;
    List<MemberViewModel> returnList =
        await Provider.of<PartyListViewModel>(context, listen: false)
            .getMemberInParty(id);
    setState(() {
      isLoad = false;
      data = returnList;
    });
  }

  onRouter(String path) => Navigator.of(context).pushNamed(path);
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: PreferredSize(
            preferredSize: const Size(double.infinity, kToolbarHeight),
            child: AppBarChildWidget()),
        body: isLoad
            ? Center(
                child: CircularProgressIndicator(),
              )
            : Container(
                color: Colors.white,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Container(
                      margin: EdgeInsets.only(right: 20),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          PageTitleWidget(title: TITLE_GROUP_MEMBER),
                          Container(
                            child: ElevatedButton(
                              onPressed: () {
                                return showMemberTopic();
                              },
                              child: Text(
                                "Yêu cầu vào nhóm",
                                style: TextStyle(
                                    fontWeight: FontWeight.bold, fontSize: 15),
                              ),
                              style: getStyleElevatedButton(
                                  width: 150,
                                  radius: 10,
                                  type: ButtonType.SUCCESS),
                            ),
                          )
                        ],
                      ),
                    ),
                    Expanded(
                      child: Container(
                        margin: EdgeInsets.only(right: 10, left: 10),
                        child: ListView.builder(
                          shrinkWrap: true,
                          scrollDirection: Axis.vertical,
                          itemCount: data.length,
                          itemBuilder: (BuildContext context, int index) {
                            return InkWell(
                                onTap: () {
                                  Provider.of<MemberListViewModel>(context,
                                          listen: false)
                                      .setMemberId(data[index].member.id);
                                  onRouter(OTHER_PROFILE_INGROUP_PAGE_ROUTE);
                                },
                                child: Container(
                                  height: 110,
                                  margin: EdgeInsets.only(
                                      right: 5, left: 5, bottom: 10, top: 10),
                                  child: Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Container(
                                        child: Row(
                                          children: [
                                            Container(
                                                child: CircleAvatar(
                                              radius: 30.0,
                                              backgroundImage: (data[index]
                                                              .member
                                                              .avatar !=
                                                          null &&
                                                      data[index]
                                                              .member
                                                              .avatar !=
                                                          "")
                                                  ? NetworkImage(
                                                      "${data[index].member.avatar}")
                                                  : AssetImage(
                                                      "assets/icons/user-1.png"),
                                            )),
                                            Container(
                                                width: 180,
                                                margin:
                                                    EdgeInsets.only(left: 20),
                                                child: Container(
                                                    child: Text(
                                                        data[index].fullName,
                                                        style: TextStyle(
                                                            fontWeight:
                                                                FontWeight
                                                                    .bold),
                                                        overflow: TextOverflow
                                                            .ellipsis)))
                                          ],
                                        ),
                                      ),
                                      Container(
                                        padding: EdgeInsets.all(5),
                                        child: Column(
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          children: [
                                            Container(
                                              width: 100,
                                              decoration: BoxDecoration(
                                                  color: Colors.red,
                                                  borderRadius:
                                                      BorderRadius.all(
                                                          Radius.circular(5))),
                                              child: InkWell(
                                                  onTap: () {
                                                    Provider.of<MemberListViewModel>(
                                                                context,
                                                                listen: false)
                                                            .memberId =
                                                        data[index].member.id;
                                                    return showQuitGroup();
                                                  },
                                                  child: Container(
                                                      padding:
                                                          EdgeInsets.all(5),
                                                      child: Icon(
                                                        Icons.logout,
                                                        color: Colors.white,
                                                      ))),
                                            )
                                          ],
                                        ),
                                      )
                                    ],
                                  ),
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(10),
                                    color: Colors.white,
                                    boxShadow: [
                                      BoxShadow(
                                        color: PrimaryColor.withOpacity(0.2),
                                        spreadRadius: 2,
                                        blurRadius: 7,
                                        offset: Offset(
                                            0, 3), // changes position of shadow
                                      ),
                                    ],
                                  ),
                                ));
                          },
                        ),
                      ),
                    )
                  ],
                ),
              ));
  }
}
