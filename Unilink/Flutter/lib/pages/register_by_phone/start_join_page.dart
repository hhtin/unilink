import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:unilink_flutter_app/constant/path_router.dart';
import 'package:unilink_flutter_app/models/member_model.dart';
import 'package:unilink_flutter_app/translate/vn.dart';
import 'package:unilink_flutter_app/utils/asset_icon.dart';
import 'package:unilink_flutter_app/utils/button.dart';
import 'package:unilink_flutter_app/view_model/auth_view_model.dart';
import 'package:unilink_flutter_app/view_model/firebase_init.dart';
import 'package:unilink_flutter_app/view_model/member_view_model.dart';
import 'package:unilink_flutter_app/widgets/app_bar_child_widget.dart';

class StartJoinApp extends StatefulWidget {
  const StartJoinApp({Key key}) : super(key: key);

  @override
  _StartJoinAppState createState() => _StartJoinAppState();
}

class _StartJoinAppState extends State<StartJoinApp> {
  bool isLoad = false;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: isLoad
            ? Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Center(child: CircularProgressIndicator()),
                  Center(child: Text("Chờ tí nhé ..."))
                ],
              )
            : Column(mainAxisAlignment: MainAxisAlignment.center, children: [
                Center(child: Image.asset(getPathOfIcon("invite.png"))),
                Center(
                  child: Padding(
                    padding: const EdgeInsets.only(top: 10.0),
                    child: Text(
                      "Bắt đầu “học dạo” thôi nào",
                      style:
                          TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
                    ),
                  ),
                ),
                Center(
                  child: Padding(
                    padding: const EdgeInsets.only(top: 30.0),
                    child: ElevatedButton(
                        onPressed: () {
                          startJoin();
                        },
                        style: getStyleElevatedButton(width: 302, height: 44),
                        child: Text(
                          "Bắt đầu",
                          style: TextStyle(
                              fontSize: 17, fontWeight: FontWeight.bold),
                        )),
                  ),
                ),
              ]));
  }

  Future<void> startJoin() async {
    setState(() {
      isLoad = true;
    });
    String email = Provider.of<MemberListViewModel>(context, listen: false)
        .insertMember
        .member
        .email;
    Provider.of<MemberListViewModel>(context, listen: false)
        .insertMember
        .member
        .email = null;
    String deviceToken =
        Provider.of<FireBaseInit>(context, listen: false).token;
    await Provider.of<AuthViewModel>(context, listen: false)
        .loginByEmail(email, deviceToken);
    Navigator.of(context).pushReplacementNamed(MAIN_ROUTE);
  }
}
