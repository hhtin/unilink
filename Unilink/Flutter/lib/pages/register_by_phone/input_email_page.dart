import 'package:flutter/material.dart';
import 'package:unilink_flutter_app/constant/path_router.dart';
import 'package:unilink_flutter_app/utils/asset_icon.dart';
import 'package:unilink_flutter_app/translate/vn.dart';
import 'package:unilink_flutter_app/utils/button.dart';

class RegisterByPhoneInputEmailPage extends StatefulWidget {
  @override
  _RegisterByPhoneInputEmailPageState createState() =>
      _RegisterByPhoneInputEmailPageState();
}

class _RegisterByPhoneInputEmailPageState
    extends State<RegisterByPhoneInputEmailPage> {
  String phone;

  onRouter(String path) => Navigator.of(context).pushNamed(path);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: SingleChildScrollView(
      child: Container(
        color: Colors.white,
        alignment: Alignment.center,
        child: Column(
          children: [
            Container(
              child: Padding(
                padding: EdgeInsets.only(top: 20),
                child: Container(
                  alignment: Alignment.topLeft,
                  child: Ink(
                    decoration: ShapeDecoration(
                      shape: CircleBorder(),
                    ),
                    child: IconButton(
                      onPressed: () {
                        onRouter(REGISTER_BY_PHONE_INUT_PHONE_ROUTE);
                      },
                      color: Colors.white,
                      iconSize: 50,
                      icon: Image.asset(getPathOfIcon("back.png")),
                    ),
                  ),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(
                  right: 50, left: 50, top: 11, bottom: 15),
              child: Center(
                child: Text(
                  LABEL_ENTER_EMAIL,
                  style: TextStyle(
                      fontSize: 24,
                      color: Colors.black.withOpacity(0.75),
                      fontWeight: FontWeight.w500),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(right: 50, left: 50),
              child: Center(
                child: Text(
                  LABEL_NOTIFY_INPUT_EMAIL,
                  style: TextStyle(
                      fontSize: 15,
                      color: Colors.black.withOpacity(0.75),
                      fontWeight: FontWeight.w500),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(
                  right: 75, left: 75, top: 15, bottom: 15),
              child: Center(
                child: TextField(
                  textInputAction: TextInputAction.go,
                  decoration:
                      const InputDecoration(hintText: LABEL_HINT_EMAIL_TEXT),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(bottom: 34),
              child:
                  Row(mainAxisAlignment: MainAxisAlignment.center, children: [
                ElevatedButton(
                    onPressed: () {
                      onRouter(REGISTER_BY_PHONE_INPUT_GENDER_ROUTE);
                    },
                    style: getStyleElevatedButton(width: 302, height: 44),
                    child: Text(
                      LABEL_BUTTON_NEXT,
                      style:
                          TextStyle(fontWeight: FontWeight.bold, fontSize: 17),
                    ))
              ]),
            ),
            Padding(
              padding: const EdgeInsets.only(right: 50, left: 50, top: 1),
              child: Center(
                child: Text(
                  LABEL_OR,
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.w400),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(top: 34),
              child:
                  Row(mainAxisAlignment: MainAxisAlignment.center, children: [
                ElevatedButton(
                  onPressed: () {
                    Navigator.pushNamed(
                        context, REGISTER_BY_PHONE_INPUT_GENDER_ROUTE);
                  },
                  style: getStyleElevatedButton(width: 302, height: 44),
                  child: Ink(
                    decoration: BoxDecoration(
                        color: Colors.redAccent.withOpacity(0.9),
                        borderRadius: BorderRadius.circular(20)),
                    child: Container(
                      child: Row(children: [
                        Padding(
                          padding: const EdgeInsets.only(left: 12),
                          child: IconButton(
                              onPressed: null,
                              icon: Image.asset(getPathOfIcon("google-2.png"))),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(left: 22),
                          child: Text(LABEL_LOGIN_WITH_GOOGLE,
                              style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 15,
                                  shadows: [
                                    Shadow(
                                      offset: Offset(1.5, 1.5),
                                      blurRadius: 3.0,
                                      color: Color.fromARGB(0, 0, 0, 0),
                                    ),
                                  ])),
                        ),
                      ]),
                    ),
                  ),
                )
              ]),
            ),
          ],
        ),
      ),
    ));
  }
}
