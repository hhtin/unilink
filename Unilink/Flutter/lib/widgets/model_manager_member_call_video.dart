import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:unilink_flutter_app/translate/vn.dart';
import 'package:unilink_flutter_app/utils/color.dart';
import 'package:unilink_flutter_app/utils/hex_color.dart';

class Member {
  String avatar;
  String name;
  String school;
  String skill;
  bool isMute;
  bool isTalking;
  Member(
      {@required this.avatar,
      @required this.school,
      @required this.skill,
      @required this.name,
      @required this.isTalking,
      @required this.isMute});
}

// ignore: must_be_immutable
class ModelManagerMemberCallVideo extends StatefulWidget {
  @override
  State<ModelManagerMemberCallVideo> createState() =>
      _ModelManagerMemberCallVideoState();
}

class _ModelManagerMemberCallVideoState
    extends State<ModelManagerMemberCallVideo> {
  var groupNearYou = ['a', 'b'];

  List<Member> listMember = [
    Member(
        avatar: 'assets/icons/avatar-long.jpg',
        school: "FPT University",
        skill: "Java, Flutter",
        name: "Long",
        isTalking: true,
        isMute: false),
    Member(
        avatar: 'assets/icons/avatar-tin.jpg',
        school: "FPT University",
        skill: "C++",
        name: "Tin",
        isTalking: true,
        isMute: false),
    Member(
        avatar: 'assets/icons/avatar-tuan.jpg',
        school: "FPT University",
        skill: "C#",
        name: "Tuan",
        isTalking: false,
        isMute: true),
    Member(
        avatar: 'assets/icons/avatar-vinh.jpg',
        school: "FPT University",
        skill: "Js",
        name: "Vinh",
        isTalking: false,
        isMute: true),
  ];

  @override
  Widget build(BuildContext context) {
    return SimpleDialog(
      children: [
        Container(
          margin: EdgeInsets.only(left: 250, top: 10),
          width: 20,
          height: 20,
          decoration: BoxDecoration(
            image:
                DecorationImage(image: AssetImage("assets/icons/x-icon.png")),
          ),
          child: InkWell(
            onTap: () {
              Navigator.of(context).pop();
            },
          ),
        ),
        Container(
          margin: EdgeInsets.all(20),
          child: Text(
            "Thành viên",
            textAlign: TextAlign.center,
            style: TextStyle(fontSize: 30),
          ),
        ),
        Container(
          width: 500,
          margin: EdgeInsets.only(right: 10, left: 10),
          child: ListView.builder(
            shrinkWrap: true,
            scrollDirection: Axis.vertical,
            itemCount: listMember.length,
            itemBuilder: (BuildContext context, int index) {
              return Container(
                margin: EdgeInsets.only(right: 5, left: 5, bottom: 10, top: 10),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Container(
                      child: Row(
                        children: [
                          Container(
                            height: 40,
                            width: 40,
                            margin: EdgeInsets.only(left: 20),
                            decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                border: listMember[index].isTalking
                                    ? Border.all(color: Colors.red, width: 2)
                                    : Border.all(color: Colors.white),
                                image: DecorationImage(
                                  image: AssetImage(listMember[index].avatar),
                                )),
                          ),
                          Container(
                              margin: EdgeInsets.only(left: 20),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Container(
                                      margin: EdgeInsets.only(top: 13),
                                      child: Container(
                                          child: Text(listMember[index].name,
                                              style: TextStyle(
                                                  fontWeight: FontWeight.bold),
                                              overflow:
                                                  TextOverflow.ellipsis))),
                                  Container(
                                    margin: EdgeInsets.only(top: 7),
                                    padding: EdgeInsets.only(left: 10),
                                    child: Text(listMember[index].skill,
                                        overflow: TextOverflow.ellipsis),
                                  ),
                                  Container(
                                    margin: EdgeInsets.only(top: 7, bottom: 13),
                                    padding: EdgeInsets.only(left: 10),
                                    child: Text(listMember[index].school,
                                        overflow: TextOverflow.ellipsis),
                                  ),
                                ],
                              )),
                        ],
                      ),
                    ),
                    Container(
                      padding: EdgeInsets.all(5),
                      child: Row(
                        children: [
                          listMember[index].isMute == true
                              ? (Container(
                                  margin: EdgeInsets.all(5),
                                  decoration: BoxDecoration(
                                      color: Colors.red,
                                      borderRadius:
                                          BorderRadius.all(Radius.circular(5))),
                                  child: InkWell(
                                      onTap: () {
                                        Fluttertoast.showToast(
                                          msg: TOAST_UNMUTE_MEMBER,
                                          toastLength: Toast.LENGTH_LONG,
                                        );
                                      },
                                      child: Container(
                                          padding: EdgeInsets.all(5),
                                          child: Icon(
                                            Icons.mic,
                                            color: Colors.white,
                                          ))),
                                ))
                              : (Container(
                                  margin: EdgeInsets.all(5),
                                  decoration: BoxDecoration(
                                      color: Colors.red,
                                      borderRadius:
                                          BorderRadius.all(Radius.circular(5))),
                                  child: InkWell(
                                      onTap: () {
                                        Fluttertoast.showToast(
                                          msg: TOAST_MUTE_MEMBER,
                                          toastLength: Toast.LENGTH_LONG,
                                        );
                                      },
                                      child: Container(
                                          padding: EdgeInsets.all(5),
                                          child: Icon(
                                            Icons.mic_off,
                                            color: Colors.white,
                                          ))),
                                )),
                          Container(
                            margin: EdgeInsets.all(5),
                            decoration: BoxDecoration(
                                color: Colors.red,
                                borderRadius:
                                    BorderRadius.all(Radius.circular(5))),
                            child: InkWell(
                                onTap: () {
                                  Fluttertoast.showToast(
                                    msg: TOAST_KICK_MEMBER_CALL_VIDEO,
                                    toastLength: Toast.LENGTH_LONG,
                                  );
                                },
                                child: Container(
                                    padding: EdgeInsets.all(5),
                                    child: Icon(
                                      Icons.logout,
                                      color: Colors.white,
                                    ))),
                          ),
                        ],
                      ),
                    ),
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
                      offset: Offset(0, 3), // changes position of shadow
                    ),
                  ],
                ),
              );
            },
          ),
        ),
      ],
    );
  }
}
