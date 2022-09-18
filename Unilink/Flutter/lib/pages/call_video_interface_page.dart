import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:unilink_flutter_app/service/party_service.dart';
import 'package:unilink_flutter_app/utils/asset_icon.dart';
import 'package:unilink_flutter_app/utils/color.dart';
import 'package:unilink_flutter_app/utils/hex_color.dart';
import 'package:unilink_flutter_app/view_model/member_view_model.dart';
import 'package:unilink_flutter_app/view_model/party_view_model.dart';
import 'package:unilink_flutter_app/widgets/model_manager_member_call_video.dart';

class CallVideoInterfacePage extends StatefulWidget {
  @override
  _CallVideoInterfacePageState createState() => _CallVideoInterfacePageState();
}

class Member {
  String avatar;
  bool isTalking;
  Member({@required this.avatar, @required this.isTalking});
}

class _CallVideoInterfacePageState extends State<CallVideoInterfacePage> {
  onRouter(String path) => Navigator.of(context).pushNamed(path);
  PartyViewModel curParty;

  List<Member> listImageMemberJoin = [
    Member(avatar: 'assets/icons/avatar-long.jpg', isTalking: true),
    Member(avatar: 'assets/icons/avatar-tin.jpg', isTalking: false),
    Member(avatar: 'assets/icons/avatar-tuan.jpg', isTalking: false),
    Member(avatar: 'assets/icons/avatar-vinh.jpg', isTalking: true),
  ];

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    setData();
  }

  setData() async {
    curParty =
        Provider.of<PartyListViewModel>(context, listen: false).currentParty;
    String memberId =
        Provider.of<MemberListViewModel>(context, listen: false).identifier;
    await PartyService.notifyCall(curParty.party.id, memberId);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: Container(
        decoration: BoxDecoration(
            gradient: HexColor.fromHexLinear("7DC584", "3B809D",
                FractionalOffset.topCenter, FractionalOffset.bottomCenter)),
        alignment: Alignment.center,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            Container(
              margin: EdgeInsets.all(20),
              width: 200,
              height: 200,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                image: DecorationImage(
                    image: (curParty.party.image != null &&
                            curParty.party.image != "")
                        ? NetworkImage(curParty.party.image)
                        : AssetImage("assets/icons/group-4.png"),
                    fit: BoxFit.fill),
              ),
            ),
            Container(
              child: Text(
                'CALLING...',
                style: TextStyle(
                    fontSize: 25,
                    fontWeight: FontWeight.bold,
                    color: Colors.white),
              ),
            ),
            Container(),
          ],
        ),
      ),
    );
  }
}
