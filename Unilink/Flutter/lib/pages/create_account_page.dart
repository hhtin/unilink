import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:unilink_flutter_app/constant/path_router.dart';
import 'package:unilink_flutter_app/pages/main_page.dart';
import 'package:unilink_flutter_app/translate/vn.dart';
import 'package:unilink_flutter_app/utils/button.dart';

class CreateAccountPage extends StatefulWidget {
  @override
  _CreateAccountPageState createState() => _CreateAccountPageState();
}

class _CreateAccountPageState extends State<CreateAccountPage> {
  onRouter(String path) => Navigator.of(context).pushNamed(path);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(color: Colors.white),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Expanded(
              child: Center(
                child: Container(
                  margin: EdgeInsets.all(30.0),
                  decoration:
                      BoxDecoration(borderRadius: BorderRadius.circular(10)),
                  child: Container(
                    child: Padding(
                      padding: EdgeInsets.all(20),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [
                          Container(
                            child: Image.asset(
                              "assets/icons/logo.png",
                              width: 146,
                            ),
                          ),
                          Text(
                            LABEL_APP_NAME,
                            style: TextStyle(
                                fontSize: 25,
                                color: Colors.black,
                                fontWeight: FontWeight.bold),
                          ),
                          Container(
                            child: Column(
                              children: [
                                Text(
                                  LABEL_ACCOUNT_ACCEPTED,
                                  style: TextStyle(
                                      fontSize: 15,
                                      fontWeight: FontWeight.bold),
                                ),
                                Checkbox(
                                  checkColor: Colors.greenAccent,
                                  activeColor: Colors.red,
                                  value: false,
                                  onChanged: (bool value) {},
                                ),
                              ],
                            ),
                          ),
                          Column(
                            children: [
                              Container(
                                margin: EdgeInsets.only(bottom: 20),
                                decoration: BoxDecoration(),
                                child: ElevatedButton(
                                    onPressed: () {
                                      onRouter(CREATE_ACCOUNT_DETAIL_ROUTE);
                                    },
                                    style: getStyleElevatedButton(
                                        width: 302, height: 44),
                                    child: Text(
                                      LABEL_ACCOUNT_REGISTER,
                                      style: TextStyle(
                                          fontSize: 17,
                                          fontWeight: FontWeight.bold),
                                    )),
                              ),
                              Container(
                                margin: EdgeInsets.only(bottom: 20),
                                decoration: BoxDecoration(),
                                child: ElevatedButton(
                                    onPressed: () {
                                      onRouter(LOGIN_ROUTE);
                                    },
                                    style: getStyleElevatedButton(
                                        width: 302, height: 44),
                                    child: Text(
                                      LABEL_ACCOUNT_LOGIN,
                                      style: TextStyle(
                                          fontSize: 17,
                                          fontWeight: FontWeight.bold),
                                    )),
                              ),
                            ],
                          )
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
