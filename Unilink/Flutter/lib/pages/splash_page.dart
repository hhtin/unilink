import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:unilink_flutter_app/pages/register_by_phone/input_image_page.dart';
import 'package:unilink_flutter_app/utils/color.dart';
import 'package:unilink_flutter_app/constant/path_router.dart';
import 'package:unilink_flutter_app/utils/asset_icon.dart';
import 'package:unilink_flutter_app/translate/vn.dart';
import 'package:unilink_flutter_app/utils/spinner.dart';
import 'package:unilink_flutter_app/view_model/firebase_init.dart';

class SplashPage extends StatefulWidget {
  @override
  _SplashPageState createState() => _SplashPageState();
}

class _SplashPageState extends State<SplashPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
          decoration: BoxDecoration(color: Colors.white),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Padding(
                padding: const EdgeInsets.only(top: 20.0),
                child: Center(
                  child: Image.asset(getPathOfIcon("logo.png")),
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(top: 10.0),
                child: Center(
                  child: Spinner.spinnerWithFuture(initFireBase(), (data) {
                    Future.delayed(
                        new Duration(seconds: 1),
                        () => Navigator.of(context)
                            .popAndPushNamed(CREATE_ACCOUNT_ROUTE));
                    return _showAppName();
                  }, customWidget: _customWidget()),
                ),
              )
            ],
          )),
    );
  }

  Future<void> initFireBase() async {
    await Provider.of<FireBaseInit>(context, listen: false).init();
    await Future.delayed(Duration(seconds: 2));
  }

  Widget _customWidget() {
    return CircularProgressIndicator(
      color: Primary,
      strokeWidth: 5,
    );
  }

  Widget _showAppName() {
    return Text(LABEL_APP_NAME,
        style: TextStyle(
            fontSize: 30.0,
            fontWeight: FontWeight.bold,
            color: Colors.black.withAlpha(220),
            shadows: [
              Shadow(
                offset: Offset(1.5, 2.5),
                blurRadius: 3.0,
                color: Colors.white,
              ),
            ]));
  }
}
