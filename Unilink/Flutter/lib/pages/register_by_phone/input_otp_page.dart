// ignore_for_file: dead_code

import 'dart:async';

import 'package:flutter/material.dart';
import 'package:pin_code_fields/pin_code_fields.dart';
import 'package:provider/provider.dart';
import 'package:unilink_flutter_app/constant/path_router.dart';
import 'package:unilink_flutter_app/utils/asset_icon.dart';
import 'package:unilink_flutter_app/utils/authenticate-firebase.dart';
import 'package:unilink_flutter_app/utils/button.dart';
import 'package:unilink_flutter_app/translate/vn.dart';
import 'package:unilink_flutter_app/utils/spinner.dart';
import 'package:unilink_flutter_app/view_model/auth_view_model.dart';

class RegisterByPhoneInputOTPPage extends StatefulWidget {
  String verificationId;
  RegisterByPhoneInputOTPPage({Key key, this.verificationId}) : super(key: key);
  @override
  _RegisterByPhoneInputOTPPageState createState() =>
      _RegisterByPhoneInputOTPPageState();
}

class _RegisterByPhoneInputOTPPageState
    extends State<RegisterByPhoneInputOTPPage> {
  StreamController<ErrorAnimationType> errorController =
      StreamController<ErrorAnimationType>();
  TextEditingController textEditingController = TextEditingController();
  String sms;
  bool isLogin = true;
  @override
  void initState() {
    super.initState();
    errorController.add(ErrorAnimationType.shake);
    sms = "";
    isLogin = Provider.of<AuthViewModel>(context, listen: false).isLogin;
  }

  void navigateField(
      {String value, FocusNode nextNode, FocusNode previousNode}) {
    if (value.length == 1 && nextNode != null) {
      sms += value;
      nextNode.requestFocus();
    }
    if (value.length == 0 && previousNode != null) {
      sms = sms.substring(0, sms.length - 1);
      previousNode.requestFocus();
    }
    print("Sms: $sms");
  }

  onRouter(String path) => Navigator.of(context).pushNamed(path);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Builder(builder: (context) {
        return Container(
            color: Colors.white,
            child: Column(
              children: [
                Container(
                  alignment: Alignment.topLeft,
                  child: Padding(
                      padding: const EdgeInsets.only(top: 25, left: 5),
                      child: Ink(
                        decoration: ShapeDecoration(
                          shape: CircleBorder(),
                        ),
                        child: IconButton(
                            onPressed: () {
                              onRouter(LOGIN_ROUTE);
                            },
                            color: Colors.white,
                            iconSize: 50,
                            icon: Image.asset(getPathOfIcon("back.png"))),
                      )),
                ),
                Container(
                    margin: EdgeInsets.only(left: 50),
                    alignment: Alignment.topLeft,
                    child: Column(
                      children: [
                        Container(
                          alignment: Alignment.topLeft,
                          child: Text(LABEL_ENTER_OTP,
                              style: TextStyle(
                                  fontSize: 26,
                                  color: Colors.black.withOpacity(0.75),
                                  fontWeight: FontWeight.w500)),
                        ),
                        SizedBox(height: 10),
                        Container(
                          alignment: Alignment.topLeft,
                          child: Row(
                            children: [
                              Text(LABEL_ENTER_PHONE_OTP,
                                  style: TextStyle(
                                      fontSize: 15,
                                      color: Colors.black.withOpacity(0.75),
                                      fontWeight: FontWeight.bold)),
                              Padding(
                                padding: EdgeInsets.only(left: 10),
                                child: Text(LABEL_SEND_AGAIN,
                                    style: TextStyle(
                                        fontSize: 11,
                                        color: Colors.black.withOpacity(0.5),
                                        fontWeight: FontWeight.bold)),
                              )
                            ],
                          ),
                        )
                      ],
                    )),
                Padding(
                  padding: const EdgeInsets.only(right: 50, left: 50, top: 35),
                ),
                Container(
                  padding: EdgeInsets.all(10.0),
                  width: 350,
                  child: PinCodeTextField(
                    appContext: context,
                    length: 6,
                    obscureText: false,
                    animationType: AnimationType.fade,
                    pinTheme: PinTheme(
                      shape: PinCodeFieldShape.box,
                      borderRadius: BorderRadius.circular(5),
                      fieldHeight: 50,
                      fieldWidth: 40,
                      activeFillColor: Colors.white,
                    ),
                    animationDuration: Duration(milliseconds: 300),
                    enableActiveFill: true,
                    errorAnimationController: errorController,
                    controller: textEditingController,
                    keyboardType: TextInputType.number,
                    pastedTextStyle: TextStyle(
                      color: Colors.green.shade600,
                      fontWeight: FontWeight.bold,
                    ),
                    boxShadows: [
                      BoxShadow(
                        offset: Offset(0, 1),
                        color: Colors.black12,
                        blurRadius: 10,
                      )
                    ],
                    validator: (v) {
                      RegExp exp = RegExp("[,.]");
                      Match matchLetter = exp.firstMatch(v);
                      String valid = "";
                      if (v.length != 6) {
                        valid += "Input full 6 field";
                      }
                      if (matchLetter != null) {
                        valid += "\nJust input a number for input field";
                      }
                      return valid;
                    },
                    onCompleted: (value) {
                      print("Complete");
                      setState(() {
                        sms = value;
                      });
                    },
                    onChanged: (value) {},
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(right: 50, left: 50, top: 52),
                  child: Text(
                    LABEL_ENTER_OTP_INFOR,
                    style: TextStyle(
                      fontSize: 14,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ),
                Row(mainAxisAlignment: MainAxisAlignment.center, children: [
                  ElevatedButton(
                      onPressed: () {
                        if (sms == "") return;
                        RegExp exp = RegExp("[,.]");
                        Match matchLetter = exp.firstMatch(sms);
                        if (matchLetter != null) return;
                        Spinner.blockUiWithSpinnerScreen(context);
                        Authentication.confirmSms(widget.verificationId, sms)
                            .then((user) {
                          Navigator.of(context).pop();
                          if (user != null) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              Authentication.customSnackBar(
                                content: 'Sign in successfully',
                              ),
                            );
                            if (isLogin) {
                              Navigator.of(context).pushNamed(MAIN_ROUTE);
                            } else {
                              Navigator.of(context)
                                  .popAndPushNamed(WELCOME_ROUTE);
                            }
                          } else {
                            ScaffoldMessenger.of(context).showSnackBar(
                              Authentication.customSnackBar(
                                content: 'Wrong sms code, try again !',
                              ),
                            );
                          }
                        });
                      },
                      style: getStyleElevatedButton(width: 302, height: 44),
                      child: Text(LABEL_BUTTON_NEXT))
                ])
              ],
            ));
      }),
    );
  }
}
