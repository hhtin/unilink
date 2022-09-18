import 'package:dotted_border/dotted_border.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:provider/provider.dart';
import 'package:unilink_flutter_app/constant/path_router.dart';
import 'package:unilink_flutter_app/models/member_model.dart';
import 'package:unilink_flutter_app/translate/vn.dart';
import 'package:unilink_flutter_app/utils/asset_icon.dart';
import 'package:unilink_flutter_app/utils/authenticate-firebase.dart';
import 'package:unilink_flutter_app/utils/button.dart';
import 'package:unilink_flutter_app/utils/color.dart';
import 'package:unilink_flutter_app/utils/hex_color.dart';
import 'package:unilink_flutter_app/utils/spinner.dart';
import 'package:unilink_flutter_app/view_model/member_view_model.dart';
import 'package:unilink_flutter_app/view_model/party_view_model.dart';
import 'package:unilink_flutter_app/view_model/university_view_model.dart';
import 'package:unilink_flutter_app/widgets/app_bar_child_widget.dart';

class DetailProfileMemberPage extends StatefulWidget {
  @override
  _DetailProfileMemberPageState createState() =>
      _DetailProfileMemberPageState();
}

class _DetailProfileMemberPageState extends State<DetailProfileMemberPage> {
  final List<String> images = [
    "university-30px.png",
    "major-30px.png",
    "skill-30px.png",
    "gender-30px.png",
    "DOB-30px.png",
    "location-30px.png",
  ];
  final List<String> infor = [];
  void convertToInfor(MemberViewModel member) {
    infor.clear();
    String university = "";
    university = (Provider.of<UniversityListViewModel>(context, listen: false)
            .universityList
            .firstWhere((element) =>
                element.university.id == member.member.universityId))
        .university
        .name;
    infor.add(university);
    String major = "";
    member.majors.forEach(
        (element) => major += (major == "" ? "" : ", ") + element.name);
    infor.add(major == "" ? "< No Major >" : major);
    String skill = "";
    member.skills.forEach(
        (element) => skill += (skill == "" ? "" : ", ") + element.name);
    infor.add(skill == "" ? "< No Skill >" : skill);
    int gender = member.member.gender;
    infor.add(gender == 1
        ? "Nam"
        : gender == 0
            ? "Nữ"
            : "Khác");
    infor.add(member.member.dob.toString().split(" ")[0]);
    infor.add(member.member.address);
  }

  Widget _renderProfile(index, MemberViewModel member) {
    convertToInfor(member);
    var size = MediaQuery.of(context).size;
    return Container(
      margin: EdgeInsets.only(bottom: 20),
      child: Row(
        key: UniqueKey(),
        children: [
          Image.asset(getPathOfIcon(images[index])),
          Padding(
            padding: const EdgeInsets.only(left: 40.0),
            child: Container(
              width: size.width * 0.6,
              child: SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Text(
                  infor[index],
                  style:
                      TextStyle(fontSize: 15, overflow: TextOverflow.ellipsis),
                ),
              ),
            ),
          )
        ],
      ),
    );
  }

  Future<MemberViewModel> getInforMember() async {
    return await Provider.of<MemberListViewModel>(context, listen: false)
        .getInforMember(
            Provider.of<MemberListViewModel>(context, listen: false).memberId);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
          preferredSize: const Size(double.infinity, kToolbarHeight),
          child: AppBarChildWidget(path: MAIN_ROUTE, indexScreen: 1)),
      body: Center(
        child: Spinner.spinnerWithFuture(getInforMember(), (data) {
          MemberViewModel member = data;
          if (member == null) return Container();
          return SingleChildScrollView(
              child: Container(
            color: Colors.white,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Stack(
                  children: [
                    Container(
                      width: double.infinity,
                      decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.only(
                              bottomLeft: Radius.circular(60),
                              bottomRight: Radius.circular(60))),
                      padding: EdgeInsets.only(
                          left: 40.0, right: 40.0, bottom: 30.0),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Padding(
                              padding: EdgeInsets.only(bottom: 10.0, top: 40),
                              child: CircleAvatar(
                                radius: 50.0,
                                backgroundImage: (member.member.avatar !=
                                            null &&
                                        member.member.avatar != "")
                                    ? NetworkImage("${member.member.avatar}")
                                    : AssetImage("assets/icons/user-1.png"),
                              )),
                          Padding(
                            padding: const EdgeInsets.only(bottom: 10.0),
                            child: Text(
                                "${member.member.firstName} ${member.member.lastName}",
                                style: TextStyle(
                                    color: Colors.black,
                                    fontSize: 20,
                                    fontWeight: FontWeight.bold)),
                          ),
                        ],
                      ),
                    ),
                    Container(
                      margin: EdgeInsets.only(left: 20, right: 20, bottom: 30),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(20),
                        boxShadow: [
                          BoxShadow(
                            color: PrimaryColor.withOpacity(0.2),
                            spreadRadius: 5,
                            blurRadius: 10,
                            offset: Offset(0, 3), // changes position of shadow
                          ),
                        ],
                      ),
                      child: Container(
                        margin: EdgeInsets.only(top: 180),
                        decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(20)),
                        padding: EdgeInsets.all(2.0),
                        child: Center(
                            child: Padding(
                          padding: EdgeInsets.all(20),
                          child: Text(
                            "${member.member.description}",
                            textAlign: TextAlign.center,
                            style: TextStyle(fontSize: 20),
                          ),
                        )),
                      ),
                    ),
                  ],
                ),
                Container(
                  margin: EdgeInsets.only(left: 20, right: 20),
                  padding: EdgeInsets.only(
                      left: 20, right: 20, bottom: 20.0, top: 20),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(20),
                    color: Colors.white,
                    boxShadow: [
                      BoxShadow(
                        color: PrimaryColor.withOpacity(0.2),
                        spreadRadius: 5,
                        blurRadius: 10,
                        offset: Offset(0, 3), // changes position of shadow
                      ),
                    ],
                  ),
                  child: Column(
                    children: List.generate(images.length,
                        (index) => _renderProfile(index, member)),
                  ),
                ),
                Container(
                  padding: EdgeInsets.all(20),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Container(
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(20),
                          boxShadow: [
                            BoxShadow(
                              color: PrimaryColor.withOpacity(0.2),
                              spreadRadius: 5,
                              blurRadius: 10,
                              offset:
                                  Offset(0, 3), // changes position of shadow
                            ),
                          ],
                        ),
                        margin: EdgeInsets.only(bottom: 20),
                        child: ElevatedButton(
                          child: Container(child: Text("Phê duyệt")),
                          onPressed: () {
                            Navigator.of(context).pop();
                            Provider.of<PartyListViewModel>(context,
                                    listen: false)
                                .acceptReq(
                                    Provider.of<PartyListViewModel>(context,
                                            listen: false)
                                        .currentParty
                                        .party
                                        .id,
                                    member.member.id);
                            Fluttertoast.showToast(
                              msg: TOAST_ACCEPT_MEMBER,
                              toastLength: Toast.LENGTH_LONG,
                            );
                          },
                          style: getStyleElevatedButton(
                            width: 150,
                            height: 50,
                          ),
                        ),
                      ),
                      Container(
                        margin: EdgeInsets.only(bottom: 20),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(20),
                          boxShadow: [
                            BoxShadow(
                              color: PrimaryColor.withOpacity(0.2),
                              spreadRadius: 5,
                              blurRadius: 10,
                              offset:
                                  Offset(0, 3), // changes position of shadow
                            ),
                          ],
                        ),
                        child: ElevatedButton(
                          child: Text("Từ chối"),
                          onPressed: () {
                            Provider.of<PartyListViewModel>(context,
                                    listen: false)
                                .rejectReq(
                                    Provider.of<PartyListViewModel>(context,
                                            listen: false)
                                        .currentParty
                                        .party
                                        .id,
                                    member.member.id);
                            Navigator.of(context).pop();
                            Fluttertoast.showToast(
                              msg: TOAST_REFUSE_MEMBER,
                              toastLength: Toast.LENGTH_LONG,
                            );
                          },
                          style: getStyleElevatedButton(
                              width: 150, height: 50, type: ButtonType.WARNING),
                        ),
                      ),
                    ],
                  ),
                )
              ],
            ),
          ));
        }),
      ),
    );
  }
}
