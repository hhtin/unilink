import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:unilink_flutter_app/constant/path_router.dart';
import 'package:unilink_flutter_app/models/party_model.dart';
import 'package:unilink_flutter_app/translate/vn.dart';
import 'package:unilink_flutter_app/utils/color.dart';
import 'package:unilink_flutter_app/view_model/group_view_model.dart';
import 'package:unilink_flutter_app/view_model/party_view_model.dart';
import 'package:unilink_flutter_app/widgets/app_bar_child_widget.dart';
import 'package:unilink_flutter_app/widgets/modal_detail_group.dart';
import 'package:unilink_flutter_app/widgets/page_title_widget.dart';

class SuitableGroupsPage extends StatefulWidget {
  @override
  _SuitableGroupsPageState createState() => _SuitableGroupsPageState();
}

class _SuitableGroupsPageState extends State<SuitableGroupsPage> {
  showDetailGroup() {
    showDialog(
        context: context,
        builder: (context) {
          return ModalDetailGroup();
        });
  }

  var groupNearYou = [];
  var listGroup = [];
  @override
  void initState() {
    super.initState();
    listGroup =
        Provider.of<PartyListViewModel>(context, listen: false).filterGroup;
    // print(listGroup.length);
  }

  onRouter(String path) => Navigator.of(context).pushNamed(path);
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
          preferredSize: const Size(double.infinity, kToolbarHeight),
          child: AppBarChildWidget(
            path: LOOKING_FOR_STUDY_GROUPS,
          )),
      body: Container(
          child: Container(
              color: Colors.white,
              child: Padding(
                padding: EdgeInsets.all(10),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    PageTitleWidget(title: TITLE_FIND_GROUP),
                    Expanded(
                      child: Container(
                        margin: EdgeInsets.only(right: 10, left: 10),
                        child: listGroup.length == 0
                            ? Text(
                                "Không tìm thấy nhóm phù hợp",
                                style: TextStyle(
                                    fontWeight: FontWeight.bold, fontSize: 20),
                              )
                            : ListView.builder(
                                scrollDirection: Axis.vertical,
                                itemCount: listGroup.length,
                                itemBuilder: (BuildContext context, int index) {
                                  return InkWell(
                                      onTap: () {},
                                      child: Container(
                                        height: 110,
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
                                              margin: EdgeInsets.only(left: 20),
                                              child: Icon(
                                                Icons.people,
                                                size: 35,
                                              ),
                                            ),
                                            Container(
                                                width: 180,
                                                child: Column(
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.start,
                                                  children: [
                                                    Container(
                                                        width: 180,
                                                        margin: EdgeInsets.only(
                                                            top: 13),
                                                        child: Text(
                                                            listGroup[index]
                                                                .name,
                                                            style: TextStyle(
                                                                fontWeight:
                                                                    FontWeight
                                                                        .bold),
                                                            overflow:
                                                                TextOverflow
                                                                    .ellipsis)),
                                                    Container(
                                                        width: 180,
                                                        margin: EdgeInsets.only(
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
                                                                      left: 10),
                                                              child: Container(
                                                                  width: 150,
                                                                  height: 20,
                                                                  child: ListView
                                                                      .builder(
                                                                          scrollDirection: Axis
                                                                              .horizontal,
                                                                          itemCount: listGroup[index]
                                                                              .skills
                                                                              .length,
                                                                          itemBuilder: (BuildContext context, int position) =>
                                                                              Container(
                                                                                child: Row(
                                                                                  children: [
                                                                                    Text(
                                                                                      listGroup[index].skills[position].name,
                                                                                      overflow: TextOverflow.ellipsis,
                                                                                    ),
                                                                                    listGroup[index].skills.length - 1 != position ? Text(", ") : Text("")
                                                                                  ],
                                                                                ),
                                                                              ))),
                                                            )
                                                          ],
                                                        )),
                                                    Container(
                                                      margin: EdgeInsets.only(
                                                          top: 7),
                                                      child: Row(
                                                        children: [
                                                          Image.asset(
                                                            'assets/icons/location_15px.png',
                                                            width: 17,
                                                          ),
                                                          Padding(
                                                            padding:
                                                                EdgeInsets.only(
                                                                    left: 10),
                                                            child: Container(
                                                              width: 150,
                                                              child: Text(
                                                                  listGroup[
                                                                          index]
                                                                      .address,
                                                                  overflow:
                                                                      TextOverflow
                                                                          .ellipsis),
                                                            ),
                                                          )
                                                        ],
                                                      ),
                                                    ),
                                                    Container(
                                                      margin: EdgeInsets.only(
                                                          top: 7),
                                                      child: Row(
                                                        children: [
                                                          Image.asset(
                                                            'assets/icons/member_15px.png',
                                                            width: 17,
                                                          ),
                                                          Padding(
                                                            padding:
                                                                EdgeInsets.only(
                                                                    left: 10),
                                                            child: Container(
                                                              width: 150,
                                                              child: Text(
                                                                  listGroup[index]
                                                                          .currentMember
                                                                          .toString() +
                                                                      "/" +
                                                                      listGroup[
                                                                              index]
                                                                          .maximum
                                                                          .toString(),
                                                                  overflow:
                                                                      TextOverflow
                                                                          .ellipsis),
                                                            ),
                                                          )
                                                        ],
                                                      ),
                                                    ),
                                                  ],
                                                )),
                                            Container(
                                              margin:
                                                  EdgeInsets.only(right: 20),
                                              child: ElevatedButton(
                                                style: ElevatedButton.styleFrom(
                                                    primary: PrimaryColor),
                                                child: Text("Chi tiết"),
                                                onPressed: () {
                                                  Provider.of<PartyListViewModel>(
                                                              context,
                                                              listen: false)
                                                          .currentParty =
                                                      new PartyViewModel(
                                                          listGroup[index]);

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
                                              color:
                                                  PrimaryColor.withOpacity(0.5),
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
                      ),
                    )
                  ],
                ),
              ))),
    );
  }
}
