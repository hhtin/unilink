import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:unilink_flutter_app/constant/path_router.dart';
import 'package:unilink_flutter_app/utils/button.dart';
import 'package:unilink_flutter_app/translate/vn.dart';
import 'package:unilink_flutter_app/view_model/major_view_model.dart';
import 'package:unilink_flutter_app/view_model/skill_view_model.dart';
import 'package:unilink_flutter_app/view_model/university_view_model.dart';

class WelcomePage extends StatefulWidget {
  @override
  _WelcomePageState4 createState() => _WelcomePageState4();
}

class _WelcomePageState4 extends State<WelcomePage> {
  String phone;
  onRouter(String path) => Navigator.of(context).pushNamed(path);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        color: Colors.white,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: <Widget>[
            Container(
                margin: EdgeInsets.only(top: 50),
                child: Column(
                  children: [
                    Image.asset(
                      "assets/icons/logo.png",
                      height: 120,
                      width: 120,
                    ),
                    Container(
                        margin: EdgeInsets.only(top: 10),
                        padding: EdgeInsets.only(right: 25, left: 25),
                        child: Column(
                          children: [
                            Text(
                              TITTLE_ACCEPTION_TEXT,
                              style: TextStyle(fontSize: 25),
                            ),
                            Padding(
                              padding: EdgeInsets.only(top: 9),
                              child: Text(
                                REQUIRED_SLOGAN,
                                style: TextStyle(fontSize: 15),
                              ),
                            )
                          ],
                        )),
                  ],
                )),
            Container(
              padding: EdgeInsets.only(left: 30, right: 30),
              child: Column(
                children: [
                  Container(
                      margin: EdgeInsets.only(bottom: 20),
                      child: Column(
                        children: [
                          Row(
                            children: [
                              Image.asset("assets/icons/tick.png"),
                              Padding(
                                padding: EdgeInsets.only(left: 12),
                                child: Text(
                                  ACCEPT_SLOGAN1,
                                  style: TextStyle(fontSize: 20),
                                ),
                              )
                            ],
                          ),
                          Padding(
                            padding: EdgeInsets.only(top: 9, left: 35),
                            child: Text(
                              LABEL_ACCEPTION_TEXT_1,
                              style: TextStyle(fontSize: 16),
                            ),
                          )
                        ],
                      )),
                  Container(
                      margin: EdgeInsets.only(bottom: 20),
                      child: Column(
                        children: [
                          Row(
                            children: [
                              Image.asset("assets/icons/tick.png"),
                              Padding(
                                padding: EdgeInsets.only(left: 12),
                                child: Text(
                                  ACCEPT_SLOGAN2,
                                  style: TextStyle(fontSize: 20),
                                ),
                              )
                            ],
                          ),
                          Padding(
                            padding: EdgeInsets.only(top: 9, left: 35),
                            child: Text(
                              LABEL_ACCEPTION_TEXT_2,
                              style: TextStyle(fontSize: 16),
                            ),
                          )
                        ],
                      )),
                  Container(
                      child: Column(
                    children: [
                      Row(
                        children: [
                          Image.asset("assets/icons/tick.png"),
                          Padding(
                            padding: EdgeInsets.only(left: 12),
                            child: Text(
                              ACCEPT_SLOGAN3,
                              style: TextStyle(fontSize: 20),
                            ),
                          )
                        ],
                      ),
                      Padding(
                        padding: EdgeInsets.only(top: 9, left: 35),
                        child: Text(
                          LABEL_ACCEPTION_TEXT_3,
                          style: TextStyle(fontSize: 16),
                        ),
                      )
                    ],
                  )),
                ],
              ),
            ),
            Container(
              margin: EdgeInsets.only(bottom: 20),
              child: Column(
                children: [
                  ElevatedButton(
                      onPressed: () {
                        Navigator.pushNamed(
                            context, REGISTER_BY_PHOME_BASE_INFO);
                      },
                      child: Text(
                        LABEL_BUTTON_NEXT,
                        style: TextStyle(fontSize: 17),
                      ),
                      style: getStyleElevatedButton(
                          height: 44,
                          width: 302,
                          type: ButtonType.PRIMARY_COLOR))
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
