import 'package:dotted_border/dotted_border.dart';
import 'package:flutter/cupertino.dart';

import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:provider/provider.dart';
import 'package:unilink_flutter_app/constant/path_router.dart';
import 'package:unilink_flutter_app/translate/vn.dart';
import 'package:unilink_flutter_app/utils/button.dart';
import 'package:unilink_flutter_app/utils/color.dart';
import 'package:unilink_flutter_app/utils/spinner.dart';
import 'package:unilink_flutter_app/view_model/member_view_model.dart';
import 'package:unilink_flutter_app/view_model/party_view_model.dart';

class ModalDetailGroup extends StatefulWidget {
  Function callback;
  ModalDetailGroup({Key key, this.callback}) : super(key: key);
  @override
  _ModalDetailGroupState createState() => _ModalDetailGroupState();
}

class _ModalDetailGroupState extends State<ModalDetailGroup> {
  Function callback;
  String currentMemberId = "";
  String partyId = "";
  String typeOfList = "";
  Future<PartyViewModel> getInforParty() async {
    currentMemberId =
        Provider.of<MemberListViewModel>(context, listen: false).identifier;
    typeOfList =
        Provider.of<PartyListViewModel>(context, listen: false).typeOfList;
    partyId = Provider.of<PartyListViewModel>(context, listen: false)
        .currentParty
        .party
        .id;

    return await Provider.of<PartyListViewModel>(context, listen: false)
        .getPartyById(partyId);
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    callback = widget.callback;
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Spinner.spinnerWithFuture(getInforParty(), (data) {
        PartyViewModel party = data;
        if (party == null) return SimpleDialog();
        return SimpleDialog(
          children: [
            Container(
              width: 400,
              padding: EdgeInsets.all(20),
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    Container(
                      margin: EdgeInsets.only(left: 230, bottom: 20),
                      width: 20,
                      height: 20,
                      decoration: BoxDecoration(
                        image: DecorationImage(
                            image: AssetImage("assets/icons/x-icon.png")),
                      ),
                      child: InkWell(
                        onTap: () {
                          Navigator.of(context).pop();
                        },
                      ),
                    ),
                    Container(
                      margin: EdgeInsets.only(top: 10),
                      child: CircleAvatar(
                        backgroundImage: (party.party.image != null &&
                                party.party.image != "")
                            ? NetworkImage(party.party.image)
                            : AssetImage("assets/icons/group-1.png"),
                      ),
                    ),
                    Container(
                      margin: EdgeInsets.only(top: 10, bottom: 10),
                      child: Text(party.party.name,
                          style: TextStyle(
                              fontWeight: FontWeight.bold, fontSize: 20)),
                    ),

                    Column(
                      children: [
                        DottedBorder(
                          strokeWidth: 1,
                          color: PrimaryColor,
                          radius: Radius.circular(20),
                          child: Container(
                            color: Colors.white,
                            padding: EdgeInsets.all(2.0),
                            child: Center(
                                child: Padding(
                              padding: EdgeInsets.all(20),
                              child: Text(
                                "${party.party.description}",
                                textAlign: TextAlign.center,
                                style: TextStyle(fontSize: 20),
                              ),
                            )),
                          ),
                        ),
                        Table(children: [
                          TableRow(
                            children: [
                              Container(
                                margin: EdgeInsets.only(top: 10, bottom: 10),
                                child: Text(
                                  "Thành viên",
                                  style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 17),
                                ),
                              ),
                              Container(
                                margin: EdgeInsets.only(top: 10, bottom: 10),
                                child: Text(
                                    party.party.currentMember.toString() +
                                        "/" +
                                        party.party.maximum.toString(),
                                    style: TextStyle(fontSize: 17)),
                              ),
                            ],
                          ),
                        ]),
                        Row(
                          children: [
                            Container(
                              margin: EdgeInsets.only(top: 10),
                              child: Text(
                                "Kỹ năng",
                                style: TextStyle(
                                    fontWeight: FontWeight.bold, fontSize: 17),
                              ),
                            ),
                          ],
                        ),
                        Container(
                            margin: EdgeInsets.only(top: 5, bottom: 5),
                            child: Wrap(
                              children: [
                                for (var i in party.party.skills)
                                  Container(
                                    margin: EdgeInsets.only(left: 5, right: 5),
                                    child: Chip(
                                      padding: EdgeInsets.all(0),
                                      backgroundColor: Colors.grey[300],
                                      label: Text(i.name,
                                          style: TextStyle(
                                              color: Colors.black,
                                              fontWeight: FontWeight.bold)),
                                    ),
                                  ),
                              ],
                            )),
                        Row(
                          children: [
                            Container(
                              margin: EdgeInsets.only(top: 10),
                              child: Text(
                                "Địa chỉ",
                                style: TextStyle(
                                    fontWeight: FontWeight.bold, fontSize: 17),
                              ),
                            ),
                          ],
                        ),
                        Container(
                          margin: EdgeInsets.only(bottom: 10, top: 5),
                          child: Text(party.party.address,
                              style: TextStyle(fontSize: 17)),
                        ),
                      ],
                    ),

                    // Container(
                    //   margin: EdgeInsets.only(top: 10, bottom: 10),
                    //   child: Text(
                    //     'Bạn cần trả lời 1 số câu hỏi trước khi được phê duyệt',
                    //     style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                    //   ),
                    // ),
                    // Container(
                    //   margin: EdgeInsets.only(top: 5, bottom: 5),
                    //   child: Column(
                    //     children: [
                    //       Text(
                    //         'Bạn có biết gì về những công nghệ chúng ta sắp học chưa?',
                    //         style: TextStyle(
                    //           fontSize: 17,
                    //         ),
                    //       ),
                    //       TextField(
                    //         textInputAction: TextInputAction.go,
                    //       ),
                    //     ],
                    //   ),
                    // ),
                    (typeOfList == "MemberInvitation")
                        ? Container(
                            margin: EdgeInsets.all(10),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Container(
                                  padding: EdgeInsets.all(5),
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Container(
                                        width: 100,
                                        decoration: BoxDecoration(
                                            color: Colors.green,
                                            borderRadius: BorderRadius.all(
                                                Radius.circular(5))),
                                        child: InkWell(
                                            onTap: () async {
                                              if (await Provider.of<
                                                          MemberListViewModel>(
                                                      context,
                                                      listen: false)
                                                  .memberAcceptInvitation(
                                                      currentMemberId,
                                                      partyId)) {
                                                Fluttertoast.showToast(
                                                    msg:
                                                        "Gia nhập nhóm thành công",
                                                    toastLength:
                                                        Toast.LENGTH_SHORT);
                                              } else {
                                                Fluttertoast.showToast(
                                                    msg:
                                                        "Gia nhập nhóm thất bại",
                                                    toastLength:
                                                        Toast.LENGTH_SHORT);
                                              }
                                            },
                                            child: Container(
                                                padding: EdgeInsets.all(5),
                                                child: Icon(
                                                  Icons.check,
                                                  color: Colors.white,
                                                ))),
                                      )
                                    ],
                                  ),
                                ),
                                Container(
                                  padding: EdgeInsets.all(5),
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Container(
                                        width: 100,
                                        decoration: BoxDecoration(
                                            color: Colors.red,
                                            borderRadius: BorderRadius.all(
                                                Radius.circular(5))),
                                        child: InkWell(
                                            onTap: () async {
                                              if (await Provider.of<
                                                          MemberListViewModel>(
                                                      context,
                                                      listen: false)
                                                  .memberRejectInvitation(
                                                      currentMemberId,
                                                      partyId)) {
                                                Fluttertoast.showToast(
                                                    msg:
                                                        "Từ chối vào nhóm thành công",
                                                    toastLength:
                                                        Toast.LENGTH_SHORT);
                                              } else {
                                                Fluttertoast.showToast(
                                                    msg:
                                                        "Từ chối vào nhóm thất bại",
                                                    toastLength:
                                                        Toast.LENGTH_SHORT);
                                              }
                                            },
                                            child: Container(
                                                padding: EdgeInsets.all(5),
                                                child: Icon(
                                                  Icons.logout,
                                                  color: Colors.white,
                                                ))),
                                      )
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          )
                        : Container(
                            margin: EdgeInsets.all(10),
                            child: ElevatedButton(
                              onPressed: () async {
                                if (await Provider.of<MemberListViewModel>(
                                        context,
                                        listen: false)
                                    .requestForParty(partyId)) {
                                  Navigator.of(context).pop();
                                  Fluttertoast.showToast(
                                    msg: TOAST_SENT_REQUEST_TO_GROUP_SUCCESS,
                                    toastLength: Toast.LENGTH_LONG,
                                  );
                                } else {
                                  Navigator.of(context).pop();
                                  Fluttertoast.showToast(
                                    msg: TOAST_SENT_REQUEST_TO_GROUP_FAILT,
                                    toastLength: Toast.LENGTH_LONG,
                                  );
                                }
                                callback.call();
                              },
                              child: Text("Xin vào nhóm"),
                              style: getStyleElevatedButton(),
                            ),
                          )
                  ],
                ),
              ),
            ),
          ],
        );
      }),
    );
  }
}
