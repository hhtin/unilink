import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:provider/provider.dart';
import 'package:unilink_flutter_app/translate/vn.dart';
import 'package:unilink_flutter_app/utils/button.dart';
import 'package:unilink_flutter_app/utils/color.dart';
import 'package:unilink_flutter_app/constant/path_router.dart';
import 'package:unilink_flutter_app/utils/hex_color.dart';
import 'package:unilink_flutter_app/view_model/major_view_model.dart';
import 'package:unilink_flutter_app/view_model/member_view_model.dart';
import 'package:unilink_flutter_app/view_model/skill_view_model.dart';
import 'package:unilink_flutter_app/view_model/university_view_model.dart';
import 'package:unilink_flutter_app/widgets/app_bar_child_widget.dart';

class RegisterByPhoneInputGenderPage extends StatefulWidget {
  @override
  _RegisterByPhoneInputGenderPageState createState() =>
      _RegisterByPhoneInputGenderPageState();
}

enum GENTEL_TYPE { MAN, GIRL, DIFF, DEFAULT }

extension convertToGenderType on GENTEL_TYPE {
  static int getType(GENTEL_TYPE type) {
    switch (type) {
      case GENTEL_TYPE.MAN:
        return 1;
      case GENTEL_TYPE.GIRL:
        return 0;
      case GENTEL_TYPE.DIFF:
        return 2;
      default:
        return 2;
    }
  }
}

class _RegisterByPhoneInputGenderPageState
    extends State<RegisterByPhoneInputGenderPage> {
  GENTEL_TYPE type = GENTEL_TYPE.DEFAULT;
  bool _isSelectedCheckbox = false;
  onRouter(String path) => Navigator.of(context).pushNamed(path);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
          preferredSize: const Size(double.infinity, kToolbarHeight),
          child: AppBarChildWidget(
            path: WELCOME_ROUTE,
          )),
      body: Container(
        alignment: Alignment.center,
        color: Colors.white,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            Container(
                child: Column(
              children: [
                Center(
                  child: Text(LABEL_ENTER_GENTLE,
                      textAlign: TextAlign.center,
                      style: TextStyle(
                          fontSize: 24,
                          color: Colors.black.withOpacity(0.75),
                          fontWeight: FontWeight.w500)),
                ),
                Padding(
                  padding: EdgeInsets.only(top: 0, left: 0),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Padding(
                        padding: EdgeInsets.only(top: 0),
                        child: Column(
                          children: [
                            Padding(
                              padding: EdgeInsets.only(top: 54),
                              child: SizedBox(
                                  height: 44,
                                  width: 302,
                                  child: ElevatedButton(
                                      onPressed: () => setState(() {
                                            type = GENTEL_TYPE.GIRL;
                                          }),
                                      style: ElevatedButton.styleFrom(
                                        primary: Colors.white,
                                        side: BorderSide(
                                          width: 2.0,
                                          color: type == GENTEL_TYPE.GIRL
                                              ? PrimaryColor
                                              : Colors.white,
                                        ),
                                        shape: RoundedRectangleBorder(
                                            borderRadius:
                                                BorderRadius.circular(20.0)),
                                      ),
                                      child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: [
                                          Container(
                                            margin: new EdgeInsets.symmetric(
                                                horizontal: 20),
                                            child: Text(
                                              LABEL_GENTLE_WOMEN,
                                              style: TextStyle(
                                                  color: Colors.black,
                                                  fontSize: 20),
                                            ),
                                          )
                                        ],
                                      ))),
                            ),
                            Padding(
                              padding: EdgeInsets.only(top: 35),
                              child: SizedBox(
                                  height: 44,
                                  width: 302,
                                  child: ElevatedButton(
                                      onPressed: () => setState(() {
                                            type = GENTEL_TYPE.MAN;
                                          }),
                                      style: ElevatedButton.styleFrom(
                                        primary: Colors.white,
                                        side: BorderSide(
                                          width: 2.0,
                                          color: type == GENTEL_TYPE.MAN
                                              ? PrimaryColor
                                              : Colors.white,
                                        ),
                                        shape: RoundedRectangleBorder(
                                            borderRadius:
                                                BorderRadius.circular(20.0)),
                                      ),
                                      child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: [
                                          Container(
                                            margin: new EdgeInsets.symmetric(
                                                horizontal: 20),
                                            child: Text(
                                              LABEL_GENTLE_MAN,
                                              style: TextStyle(
                                                  color: Colors.black,
                                                  fontSize: 20),
                                            ),
                                          )
                                        ],
                                      ))),
                            ),
                            Padding(
                              padding: EdgeInsets.only(top: 35),
                              child: SizedBox(
                                height: 44,
                                width: 302,
                                child: ElevatedButton(
                                    onPressed: () => setState(() {
                                          type = GENTEL_TYPE.DIFF;
                                        }),
                                    style: ElevatedButton.styleFrom(
                                      primary: Colors.white,
                                      side: BorderSide(
                                        width: 2.0,
                                        color: type == GENTEL_TYPE.DIFF
                                            ? PrimaryColor
                                            : Colors.white,
                                      ),
                                      shape: RoundedRectangleBorder(
                                          borderRadius:
                                              BorderRadius.circular(20.0)),
                                    ),
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        Container(
                                          margin: new EdgeInsets.symmetric(
                                              horizontal: 20),
                                          child: Text(
                                            LABEL_GENTLE_DIFF,
                                            style: TextStyle(
                                                color: Colors.black,
                                                fontSize: 20),
                                          ),
                                        )
                                      ],
                                    )),
                              ),
                            ),
                            Padding(
                                padding: EdgeInsets.only(top: 22, left: 50),
                                child: Container(
                                  alignment: Alignment.center,
                                  child: Row(
                                    children: [
                                      Checkbox(
                                          value: this._isSelectedCheckbox,
                                          onChanged: (bool value) {
                                            setState(() {
                                              this._isSelectedCheckbox = value;
                                            });
                                          }),
                                      Text(
                                        LABEL_CONFIRM_GENTLE,
                                        textAlign: TextAlign.left,
                                        style: TextStyle(
                                            fontSize: 15,
                                            color: HexColor.fromHex("#000000")),
                                      ),
                                    ],
                                  ),
                                )),
                          ],
                        ),
                      ),
                    ],
                  ),
                )
              ],
            )),
            Container(
              margin: EdgeInsets.only(top: 30),
              alignment: Alignment.center,
              height: 44,
              width: 302,
              child: ElevatedButton(
                  onPressed: () {
                    if (type == GENTEL_TYPE.DEFAULT) {
                      Fluttertoast.showToast(
                          msg: TOAST_SELECT_GENDER,
                          toastLength: Toast.LENGTH_SHORT);
                      return;
                    }
                    Provider.of<MemberListViewModel>(context, listen: false)
                        .insertMember
                        .member
                        .gender = convertToGenderType.getType(type);
                    onRouter(REGISTER_BY_PHONE_INPUT_SCHOOL_MAJOR_ROUTE);
                  },
                  style: getStyleElevatedButton(width: 302, height: 44),
                  child: Text(
                    LABEL_BUTTON_NEXT,
                    style: TextStyle(fontSize: 17, fontWeight: FontWeight.bold),
                  )),
            )
          ],
        ),
      ),
    );
  }
}
