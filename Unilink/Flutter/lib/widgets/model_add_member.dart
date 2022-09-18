import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:provider/provider.dart';
import 'package:unilink_flutter_app/constant/path_router.dart';
import 'package:unilink_flutter_app/translate/vn.dart';
import 'package:unilink_flutter_app/utils/button.dart';
import 'package:unilink_flutter_app/utils/spinner.dart';
import 'package:unilink_flutter_app/view_model/member_view_model.dart';
import 'package:unilink_flutter_app/view_model/party_view_model.dart';

class Member {
  String name;
  String image;
  List<String> skillList;
  String university;
  Member(
      {@required this.name,
      @required this.image,
      @required this.skillList,
      @required this.university});
}

class ModelAddMember extends StatefulWidget {
  // const ModelAddMember({ Key? key }) : super(key: key);

  @override
  _ModelAddMemberState createState() => _ModelAddMemberState();
}

class _ModelAddMemberState extends State<ModelAddMember> {
  List<String> listSkill = ["java", "C#", "C++"];
  String currentPartyId = "";
  List<MemberViewModel> listMember = <MemberViewModel>[];
  bool isLoad = false;
  Future<List<MemberViewModel>> getRequestForParty() async {
    currentPartyId = Provider.of<PartyListViewModel>(context, listen: false)
        .currentParty
        .party
        .id;
    return await Provider.of<MemberListViewModel>(context, listen: false)
        .getListRequestById(currentPartyId, "0");
  }

  Future<Null> refreshList() async {
    await Future.delayed(Duration(seconds: 2));
    currentPartyId = Provider.of<PartyListViewModel>(context, listen: false)
        .currentParty
        .party
        .id;
    List<MemberViewModel> listRefresh =
        await Provider.of<MemberListViewModel>(context, listen: false)
            .getListRequestById(currentPartyId, "0");
    setState(() {
      listMember = listRefresh;
    });
    return null;
  }

  @override
  Widget build(BuildContext context) {
    return isLoad
        ? Center(
            child: CircularProgressIndicator(),
          )
        : SimpleDialog(
            children: [
              Container(
                margin: EdgeInsets.only(left: 250, top: 10),
                width: 20,
                height: 20,
                decoration: BoxDecoration(
                  image: DecorationImage(
                      image: AssetImage("assets/icons/x-icon.png")),
                ),
                child: InkWell(
                  onTap: () {
                    Navigator.of(context, rootNavigator: true).pop();
                  },
                ),
              ),
              Container(
                  width: 400,
                  padding:
                      EdgeInsets.only(top: 10, bottom: 20, left: 5, right: 5),
                  child: SingleChildScrollView(
                    child: Column(
                      children: [
                        Container(
                          margin: EdgeInsets.only(bottom: 20),
                          child: Text("Danh sách yêu cầu",
                              style: TextStyle(
                                  fontWeight: FontWeight.bold, fontSize: 20)),
                        ),
                        Center(
                          child: RefreshIndicator(
                            onRefresh: refreshList,
                            child: Spinner.spinnerWithFuture(
                                getRequestForParty(), (data) {
                              listMember = data;
                              if (listMember.length == 0)
                                return Container(
                                    child: ListView.builder(
                                        shrinkWrap: true,
                                        scrollDirection: Axis.vertical,
                                        itemCount: 1,
                                        itemBuilder:
                                            (BuildContext context, int index) {
                                          return Container(
                                            alignment: Alignment.center,
                                            child: Text(
                                              "Doesnt have  request",
                                              style: TextStyle(fontSize: 15),
                                            ),
                                          );
                                        }));
                              return Container(
                                height: 480,
                                child: ListView.builder(
                                  shrinkWrap: true,
                                  scrollDirection: Axis.vertical,
                                  itemCount: listMember.length,
                                  itemBuilder:
                                      (BuildContext context, int index) {
                                    return Container(
                                      margin: EdgeInsets.all(20),
                                      width: 250,
                                      height: 250,
                                      alignment: Alignment.bottomLeft,
                                      decoration: BoxDecoration(
                                        borderRadius: BorderRadius.all(
                                          Radius.circular(20),
                                        ),
                                        image: DecorationImage(
                                            colorFilter: new ColorFilter.mode(
                                                Colors.white.withOpacity(0.7),
                                                BlendMode.dstATop),
                                            image: (listMember[index]
                                                            .member
                                                            .avatar !=
                                                        null &&
                                                    listMember[index]
                                                            .member
                                                            .avatar !=
                                                        "")
                                                ? NetworkImage(listMember[index]
                                                    .member
                                                    .avatar)
                                                : AssetImage(
                                                    "assets/icons/user-1.png"),
                                            fit: BoxFit.cover),
                                      ),
                                      child: Container(
                                        padding:
                                            EdgeInsets.only(right: 5, left: 5),
                                        height: 200,
                                        decoration: BoxDecoration(
                                          gradient: LinearGradient(
                                              begin: FractionalOffset.topCenter,
                                              end:
                                                  FractionalOffset.bottomCenter,
                                              colors: [
                                                Colors.grey.withOpacity(0.0),
                                                Colors.black,
                                              ],
                                              stops: [
                                                0.0,
                                                1.0
                                              ]),
                                          borderRadius: BorderRadius.only(
                                            bottomLeft: Radius.circular(20),
                                            bottomRight: Radius.circular(20),
                                          ),
                                        ),
                                        child: Column(
                                          mainAxisAlignment:
                                              MainAxisAlignment.end,
                                          children: [
                                            Container(
                                              child: Column(
                                                mainAxisAlignment:
                                                    MainAxisAlignment
                                                        .spaceBetween,
                                                children: [
                                                  Container(
                                                    alignment:
                                                        Alignment.bottomLeft,
                                                    padding: EdgeInsets.only(
                                                        top: 5,
                                                        left: 5,
                                                        bottom: 10),
                                                    child: Column(
                                                      children: [
                                                        Container(
                                                          child: Text(
                                                            listMember[index]
                                                                .fullName,
                                                            style: TextStyle(
                                                                color: Colors
                                                                    .white,
                                                                fontSize: 20,
                                                                fontWeight:
                                                                    FontWeight
                                                                        .bold),
                                                            overflow:
                                                                TextOverflow
                                                                    .ellipsis,
                                                          ),
                                                        ),
                                                        Container(
                                                          padding:
                                                              EdgeInsets.only(
                                                                  left: 0),
                                                          child: Text(
                                                            listMember[index]
                                                                .member
                                                                .phone,
                                                            style: TextStyle(
                                                                color: Colors
                                                                    .white,
                                                                fontSize: 20,
                                                                fontWeight:
                                                                    FontWeight
                                                                        .normal),
                                                          ),
                                                        ),
                                                      ],
                                                    ),
                                                  ),
                                                  Container(
                                                    child: Row(
                                                      children: [
                                                        ElevatedButton(
                                                          onPressed: () {
                                                            Provider.of<MemberListViewModel>(
                                                                    context,
                                                                    listen:
                                                                        false)
                                                                .setMemberId(
                                                                    listMember[
                                                                            index]
                                                                        .member
                                                                        .id);
                                                            Navigator.of(
                                                                    context)
                                                                .pushNamed(
                                                                    DETAIL_PROFILE_MEMBER_PAGE_ROUTE);
                                                          },
                                                          child: Container(
                                                            padding:
                                                                EdgeInsets.all(
                                                                    10),
                                                            child: Text(
                                                                "Chi tiết"),
                                                          ),
                                                          style:
                                                              getStyleElevatedButton(
                                                                  height: 40,
                                                                  width: 90,
                                                                  type: ButtonType
                                                                      .PRIMARY),
                                                        ),
                                                        ElevatedButton(
                                                          onPressed: () {
                                                            acceptRequest(
                                                                index);
                                                          },
                                                          child: Container(
                                                            padding:
                                                                EdgeInsets.all(
                                                                    10),
                                                            child: Text(
                                                                "Phê duyệt"),
                                                          ),
                                                          style:
                                                              getStyleElevatedButton(
                                                                  height: 40,
                                                                  width: 100,
                                                                  type: ButtonType
                                                                      .SUCCESS),
                                                        ),
                                                        ElevatedButton(
                                                          onPressed: () {
                                                            rejectRequest(
                                                                index);
                                                          },
                                                          child: Container(
                                                            padding:
                                                                EdgeInsets.all(
                                                                    10),
                                                            child:
                                                                Text("Từ chối"),
                                                          ),
                                                          style:
                                                              getStyleElevatedButton(
                                                                  height: 40,
                                                                  width: 80,
                                                                  type: ButtonType
                                                                      .ERROR),
                                                        ),
                                                      ],
                                                    ),
                                                  )
                                                ],
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    );
                                  },
                                ),
                              );
                            }),
                          ),
                        ),
                      ],
                    ),
                  )),
            ],
          );
  }

  Future<void> acceptRequest(int index) async {
    setState(() {
      isLoad = true;
    });
    await Provider.of<PartyListViewModel>(context, listen: false)
        .acceptReq(currentPartyId, listMember[index].member.id);
    await refreshList();
    setState(() {
      isLoad = false;
    });
    Fluttertoast.showToast(
      msg: TOAST_ACCEPT_MEMBER,
      toastLength: Toast.LENGTH_LONG,
    );
  }

  Future<void> rejectRequest(int index) async {
    setState(() {
      isLoad = true;
    });
    Provider.of<PartyListViewModel>(context, listen: false)
        .rejectReq(currentPartyId, listMember[index].member.id);
    refreshList();
    setState(() {
      isLoad = false;
    });
    Fluttertoast.showToast(
      msg: TOAST_REFUSE_MEMBER,
      toastLength: Toast.LENGTH_LONG,
    );
  }
}
