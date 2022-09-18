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

class ModelViewListReq extends StatefulWidget {
  Function callback;
  ModelViewListReq({Key key, this.callback}) : super(key: key);
  @override
  _ModelViewListReqState createState() => _ModelViewListReqState();
}

class _ModelViewListReqState extends State<ModelViewListReq> {
  List<String> listSkill = ["java", "C#", "C++"];
  String currentMemberId = "";
  List<PartyViewModel> listReq = <PartyViewModel>[];
  Function callback;
  Future<List<PartyViewModel>> getRequestForParty() async {
    currentMemberId =
        Provider.of<MemberListViewModel>(context, listen: false).identifier;
    return await Provider.of<PartyListViewModel>(context, listen: false)
        .getListRequestByMemberId(currentMemberId, "0");
  }

  Future<Null> refreshList() async {
    await Future.delayed(Duration(seconds: 2));
    currentMemberId =
        Provider.of<MemberListViewModel>(context, listen: false).identifier;
    List<PartyViewModel> listRefresh =
        await Provider.of<PartyListViewModel>(context, listen: false)
            .getListRequestByMemberId(currentMemberId, "0");
    setState(() {
      listReq = listRefresh;
    });
    return null;
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    callback = widget.callback;
  }

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
              callback.call();
              Navigator.of(context, rootNavigator: true).pop();
            },
          ),
        ),
        Container(
            width: 400,
            padding: EdgeInsets.only(top: 10, bottom: 20, left: 5, right: 5),
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
                      child: Spinner.spinnerWithFuture(getRequestForParty(),
                          (data) {
                        listReq = data;
                        if (listReq.length == 0)
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
                                        "Doesnt has request",
                                        style: TextStyle(fontSize: 15),
                                      ),
                                    );
                                  }));
                        return Container(
                          height: 480,
                          child: ListView.builder(
                            shrinkWrap: true,
                            scrollDirection: Axis.vertical,
                            itemCount: listReq.length,
                            itemBuilder: (BuildContext context, int index) {
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
                                      image: (listReq[index].party.image ==
                                                  null ||
                                              listReq[index]
                                                  .party
                                                  .image
                                                  .isEmpty)
                                          ? AssetImage(
                                              "assets/icons/avatar-group.png")
                                          : AssetImage(
                                              listReq[index].party.image),
                                      fit: BoxFit.cover),
                                ),
                                child: Container(
                                  padding: EdgeInsets.only(right: 5, left: 5),
                                  height: 200,
                                  decoration: BoxDecoration(
                                    gradient: LinearGradient(
                                        begin: FractionalOffset.topCenter,
                                        end: FractionalOffset.bottomCenter,
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
                                    mainAxisAlignment: MainAxisAlignment.end,
                                    children: [
                                      Container(
                                        child: Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceBetween,
                                          children: [
                                            Container(
                                              alignment: Alignment.bottomLeft,
                                              padding: EdgeInsets.only(
                                                  top: 5, left: 5, bottom: 10),
                                              child: Column(
                                                children: [
                                                  Container(
                                                    child: Text(
                                                      listReq[index].party.name,
                                                      style: TextStyle(
                                                          color: Colors.white,
                                                          fontSize: 20,
                                                          fontWeight:
                                                              FontWeight.bold),
                                                    ),
                                                  ),
                                                  Container(
                                                    padding: EdgeInsets.only(
                                                        left: 0),
                                                    child: Text(
                                                      listReq[index]
                                                          .party
                                                          .description,
                                                      style: TextStyle(
                                                          color: Colors.white,
                                                          fontSize: 20,
                                                          fontWeight: FontWeight
                                                              .normal),
                                                    ),
                                                  ),
                                                  // Container(
                                                  //   padding: EdgeInsets.only(
                                                  //       left: 10, top: 5),
                                                  //   child: Row(
                                                  //     children: [
                                                  //       for (var i = 0;
                                                  //           i <
                                                  //               listReq[index]
                                                  //                   .skills
                                                  //                   .length;
                                                  //           i++)
                                                  //         (Text(
                                                  //           "${listReq[index].skills[i]} , ",
                                                  //           style: TextStyle(
                                                  //             color:
                                                  //                 Colors.white,
                                                  //           ),
                                                  //         )),
                                                  //     ],
                                                  //   ),
                                                  // )
                                                ],
                                              ),
                                            ),
                                            Container(
                                              child: ElevatedButton(
                                                onPressed: () {
                                                  Provider.of<MemberListViewModel>(
                                                          context,
                                                          listen: false)
                                                      .rejectReqByMember(
                                                          currentMemberId,
                                                          listReq[index]
                                                              .party
                                                              .id);
                                                  refreshList();
                                                  Fluttertoast.showToast(
                                                      msg:
                                                          "Huỷ yêu cầu thành công");
                                                },
                                                child: Container(
                                                  padding: EdgeInsets.all(10),
                                                  child: Text("Hủy yêu cầu"),
                                                ),
                                                style: getStyleElevatedButton(
                                                    height: 40,
                                                    width: 100,
                                                    type: ButtonType.ERROR),
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
}
