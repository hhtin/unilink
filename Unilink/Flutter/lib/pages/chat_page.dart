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

class ChatPage extends StatefulWidget {
  @override
  _ChatPageState createState() => _ChatPageState();
}

class _ChatPageState extends State<ChatPage> {
  var groupNearYou = [];
  String groupId = "";
  List<PartyViewModel> listParties = [];
  @override
  void initState() {
    super.initState();
    groupNearYou =
        Provider.of<GroupViewModel>(context, listen: false).groupNearYou;
  }

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
          channelName: "longpc",
        ),
      ),
    );
  }

  Future<void> getPartiesByMemberId() async {
    String id =
        Provider.of<MemberListViewModel>(context, listen: false).identifier;
    print(id);
    listParties = await Provider.of<PartyListViewModel>(context, listen: false)
        .getPartyByMemberId(id);
  }

  onClickToChat(PartyViewModel currentParty) async {
    Provider.of<PartyListViewModel>(context, listen: false).currentParty =
        currentParty;
    await Provider.of<PartyListViewModel>(context, listen: false)
        .getPartyById(currentParty.party.id);
    Navigator.of(context).pushNamed(CHAT_DETAIL_ROUTE);
  }

  onRouter(String path) => Navigator.of(context).pushNamed(path);
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: PreferredSize(
            preferredSize: const Size(double.infinity, kToolbarHeight),
            child: AppBarMainWidget()),
        body: Center(
            child: Spinner.spinnerWithFuture(getPartiesByMemberId(), (data) {
          if (listParties == null) {
            return Container();
          }
          return Container(
            color: Colors.white,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                PageTitleWidget(title: "CHAT"),
                Expanded(
                  child: Container(
                    margin: EdgeInsets.all(10),
                    child: RefreshIndicator(
                      onRefresh: () => getPartiesByMemberId(),
                      child: ListView.builder(
                        shrinkWrap: true,
                        scrollDirection: Axis.vertical,
                        itemCount: listParties.length,
                        itemBuilder: (BuildContext context, int index) {
                          return InkWell(
                              onTap: () {
                                onClickToChat(listParties[index]);
                              },
                              child: Container(
                                margin: EdgeInsets.only(
                                    right: 20, left: 20, bottom: 10, top: 10),
                                padding: EdgeInsets.all(20),
                                child: Column(
                                  children: [
                                    Container(
                                      child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.start,
                                        children: [
                                          Container(
                                            margin: EdgeInsets.only(top: 10),
                                            child: Icon(Icons.people,
                                                size: 35, color: Colors.orange),
                                          ),
                                          Container(
                                            padding: EdgeInsets.all(10),
                                            child: Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.center,
                                              children: [
                                                Container(
                                                    child: Container(
                                                        child: Text(
                                                            listParties[index]
                                                                .party
                                                                .name,
                                                            style: TextStyle(
                                                                color: Colors
                                                                    .black,
                                                                fontSize: 25,
                                                                fontWeight:
                                                                    FontWeight
                                                                        .bold),
                                                            overflow:
                                                                TextOverflow
                                                                    .ellipsis))),
                                              ],
                                            ),
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
                                      spreadRadius: 3,
                                      blurRadius: 3,
                                      offset: Offset(
                                          0, 3), // changes position of shadow
                                    ),
                                  ],
                                ),
                              ));
                        },
                      ),
                    ),
                  ),
                )
              ],
            ),
          );
        })));
  }
}
