import 'package:flutter/material.dart';
import 'package:unilink_flutter_app/constant/path_router.dart';
import 'package:unilink_flutter_app/utils/asset_icon.dart';
import 'package:unilink_flutter_app/utils/authenticate-firebase.dart';
import 'package:unilink_flutter_app/utils/button.dart';
import 'package:unilink_flutter_app/utils/hex_color.dart';
import 'package:unilink_flutter_app/translate/vn.dart';
import 'package:unilink_flutter_app/widgets/app_bar_child_widget.dart';

class RegisterByPhonePage extends StatefulWidget {
  @override
  _RegisterByPhonePageState createState() => _RegisterByPhonePageState();
}

class _RegisterByPhonePageState extends State<RegisterByPhonePage> {
  String phone;
  onRouter(String path) => Navigator.of(context).pushNamed(path);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: PreferredSize(
            preferredSize: const Size(double.infinity, kToolbarHeight),
            child: AppBarChildWidget(
              path: LOGIN_ROUTE,
            )),
        body: Builder(builder: (context) {
          return Container(
            alignment: Alignment.center,
            color: Colors.white,
            child: Column(
              children: [
                Padding(
                  padding: const EdgeInsets.only(right: 50, left: 50, top: 11),
                  child: Center(
                    child: Text(LABEL_ENTER_PHONE,
                        textAlign: TextAlign.center,
                        style: TextStyle(
                            fontSize: 24,
                            color: Colors.black.withOpacity(0.75),
                            fontWeight: FontWeight.w500)),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(right: 50, left: 50, top: 35),
                  child: Row(
                    children: [
                      Container(
                        alignment: Alignment.center,
                        width: 101,
                        height: 46,
                        decoration: BoxDecoration(
                            color: HexColor.fromHex("E6EAF0"),
                            borderRadius: BorderRadius.circular(10)),
                        child: Text(
                          LABEL_REGION_VN,
                          style: TextStyle(
                              fontSize: 18, fontWeight: FontWeight.w300),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(left: 12.0),
                        child: Container(
                          padding: EdgeInsets.only(left: 10.0),
                          alignment: Alignment.center,
                          width: 188,
                          height: 46,
                          decoration: BoxDecoration(
                              color: HexColor.fromHex("E6EAF0"),
                              borderRadius: BorderRadius.circular(10)),
                          child: TextField(
                              onChanged: (String value) {
                                setState(() {
                                  phone = value;
                                });
                              },
                              keyboardType: TextInputType.numberWithOptions(
                                  decimal: true),
                              style: TextStyle(
                                  fontSize: 18, fontWeight: FontWeight.w300),
                              decoration: InputDecoration(
                                  hintText: LABEL_HINT_PHONE_TEXT,
                                  border: InputBorder.none)),
                        ),
                      ),
                    ],
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(right: 50, left: 50, top: 52),
                  child: Text(
                    LABEL_ENTER_PHONE_INFO,
                    style: TextStyle(
                      fontSize: 14,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ),
                Expanded(child: Container()),
                Padding(
                  padding: const EdgeInsets.only(bottom: 34),
                  child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        ElevatedButton(
                            onPressed: () {
                              Authentication.signInWithPhone(context,
                                  nationalCode: "+84", phone: phone);
                            },
                            style: getStyleElevatedButton(
                                type: ButtonType.PRIMARY_COLOR,
                                width: 302,
                                height: 44),
                            child: Text(
                              LABEL_BUTTON_NEXT,
                              style: TextStyle(
                                  fontSize: 17, fontWeight: FontWeight.bold),
                            ))
                      ]),
                )
              ],
            ),
          );
        }));
  }
}
