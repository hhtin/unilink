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
import 'package:unilink_flutter_app/widgets/modal_detail_group.dart';
import 'package:unilink_flutter_app/widgets/model_add_member.dart';
import 'package:unilink_flutter_app/widgets/model_out_of_group.dart';
import 'package:unilink_flutter_app/widgets/page_title_widget.dart';

class PartyInvitationPage extends StatefulWidget {
  @override
  _PartyInvitationPageState createState() => _PartyInvitationPageState();
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

class _PartyInvitationPageState extends State<PartyInvitationPage> {
  List<MemberViewModel> listMember = <MemberViewModel>[];
  String currentPartyId = "";
  showMemberTopic() {
    showDialog(
        context: context,
        builder: (context) {
          return ModelAddMember();
        });
  }

  showDetailGroup() {
    showDialog(
        context: context,
        builder: (context) {
          return ModalDetailGroup();
        });
  }

  showQuitGroup() {
    showDialog(
        context: context,
        builder: (context) {
          return ModelOutOfGroup();
        });
  }

  @override
  void initState() {
    super.initState();
  }

  Future<List<MemberViewModel>> getMemberInParty() async {
    currentPartyId = Provider.of<PartyListViewModel>(context, listen: false)
        .currentParty
        .party
        .id;
    print(currentPartyId);
    return await Provider.of<MemberListViewModel>(context, listen: false)
        .partyGetListInvitation(currentPartyId, "0");
  }

  onRouter(String path) => Navigator.of(context).pushNamed(path);
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
          preferredSize: const Size(double.infinity, kToolbarHeight),
          child: AppBarChildWidget()),
      body: Container(
          child: Container(
        color: Colors.white,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Container(
              margin: EdgeInsets.only(right: 20),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  PageTitleWidget(title: TITLE_PARTY_INVITATION),
                ],
              ),
            ),
            Expanded(
              child: Container(
                  margin: EdgeInsets.only(right: 10, left: 10),
                  child: Spinner.spinnerWithFuture(getMemberInParty(), (data) {
                    if (data == null) {
                      return Container();
                    }
                    listMember.clear();
                    listMember = data;
                    return ListView.builder(
                      shrinkWrap: true,
                      scrollDirection: Axis.vertical,
                      itemCount: listMember.length,
                      itemBuilder: (BuildContext context, int index) {
                        return InkWell(
                            onTap: () {
                              // Provider.of<MemberListViewModel>(context,
                              //         listen: false)
                              //     .setMemberId(listParty[index].party.id);
                              // onRouter(OTHER_PROFILE_INGROUP_PAGE_ROUTE);
                            },
                            child: Container(
                              height: 150,
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
                                          backgroundImage: (listMember[index]
                                                          .member
                                                          .avatar !=
                                                      null &&
                                                  listMember[index]
                                                          .member
                                                          .avatar !=
                                                      "")
                                              ? NetworkImage(
                                                  "${listMember[index].member.avatar}")
                                              : AssetImage(
                                                  "assets/icons/user-1.png"),
                                        )),
                                        Container(
                                            width: 180,
                                            margin: EdgeInsets.only(left: 20),
                                            child: Container(
                                                child: Text(
                                                    listMember[index].fullName,
                                                    style: TextStyle(
                                                        fontWeight:
                                                            FontWeight.bold),
                                                    overflow:
                                                        TextOverflow.ellipsis)))
                                      ],
                                    ),
                                  ),
                                  Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Container(
                                        padding: EdgeInsets.all(5),
                                        child: Column(
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          children: [
                                            Container(
                                              width: 100,
                                              decoration: BoxDecoration(
                                                  color: Colors.blue,
                                                  borderRadius:
                                                      BorderRadius.all(
                                                          Radius.circular(5))),
                                              child: InkWell(
                                                  onTap: () {},
                                                  child: Container(
                                                      padding:
                                                          EdgeInsets.all(5),
                                                      child: Icon(
                                                        Icons.perm_identity,
                                                        color: Colors.white,
                                                      ))),
                                            )
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
                                                  onTap: () async {
                                                    if (await Provider.of<
                                                                PartyListViewModel>(
                                                            context,
                                                            listen: false)
                                                        .partyRejectInvitation(
                                                            currentPartyId,
                                                            listMember[index]
                                                                .member
                                                                .id)) {
                                                      Fluttertoast.showToast(
                                                          msg: "Reject success",
                                                          toastLength: Toast
                                                              .LENGTH_SHORT);
                                                    } else {
                                                      Fluttertoast.showToast(
                                                          msg:
                                                              "This member doesnt has invitation",
                                                          toastLength: Toast
                                                              .LENGTH_SHORT);
                                                    }
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
                                      ),
                                    ],
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
                    );
                  })),
            ),
          ],
        ),
      )),
    );
  }
}
