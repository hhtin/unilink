import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:provider/provider.dart';
import 'package:unilink_flutter_app/constant/path_router.dart';
import 'package:unilink_flutter_app/translate/vn.dart';
import 'package:unilink_flutter_app/utils/button.dart';
import 'package:unilink_flutter_app/view_model/member_view_model.dart';
import 'package:unilink_flutter_app/view_model/party_view_model.dart';

class ModelQuitGroup extends StatefulWidget {
  @override
  State<ModelQuitGroup> createState() => _ModelQuitGroupState();
}

class _ModelQuitGroupState extends State<ModelQuitGroup> {
  bool loading = false;
  onQuitClick() async {
    setState(() {
      loading = true;
    });
    String partyId = Provider.of<PartyListViewModel>(context, listen: false)
        .currentParty
        .party
        .id;
    String memberId =
        Provider.of<MemberListViewModel>(context, listen: false).identifier;
    await Provider.of<PartyListViewModel>(context, listen: false)
        .quitParty(partyId, memberId);
    Navigator.of(context).pop();
    Navigator.of(context).pop();
    Fluttertoast.showToast(
      msg: TOAST_QUIT_GROUP,
      toastLength: Toast.LENGTH_LONG,
    );
  }

  @override
  Widget build(BuildContext context) {
    return SimpleDialog(
      title: Text(LABEL_MODEL_QUIT_GROUP_TITLE),
      children: [
        Container(
            alignment: Alignment.center,
            width: 400,
            padding: EdgeInsets.only(top: 10, bottom: 20, right: 20, left: 20),
            child: Container(
              child: loading
                  ? Center(
                      child: CircularProgressIndicator(),
                    )
                  : Column(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        ElevatedButton(
                          onPressed: () {
                            onQuitClick();
                          },
                          child: Text("Rời nhóm"),
                          style: getStyleElevatedButton(),
                        )
                      ],
                    ),
            )),
      ],
    );
  }
}
