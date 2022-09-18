import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:provider/provider.dart';
import 'package:unilink_flutter_app/constant/path_router.dart';
import 'package:unilink_flutter_app/models/member_model.dart';
import 'package:unilink_flutter_app/pages/main_page.dart';
import 'package:unilink_flutter_app/translate/vn.dart';
import 'package:unilink_flutter_app/utils/asset_icon.dart';
import 'package:unilink_flutter_app/utils/authenticate-firebase.dart';
import 'package:unilink_flutter_app/view_model/auth_view_model.dart';
import 'package:unilink_flutter_app/view_model/member_view_model.dart';
import 'package:unilink_flutter_app/widgets/app_bar_child_widget.dart';

class CreateAccountDetailPage extends StatefulWidget {
  @override
  _CreateAccountDetailPageState createState() =>
      _CreateAccountDetailPageState();
}

class _CreateAccountDetailPageState extends State<CreateAccountDetailPage> {
  onRouter(String path) => Navigator.of(context).pushNamed(path);
  bool isLoad = false;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
          preferredSize: const Size(double.infinity, kToolbarHeight),
          child: AppBarChildWidget(
            indexScreen: 0,
            path: CREATE_ACCOUNT_ROUTE,
          )),
      body: isLoad
          ? Center(
              child: CircularProgressIndicator(),
            )
          : Container(
              decoration: BoxDecoration(color: Colors.white),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Expanded(
                    child: Center(
                      child: Container(
                        margin: EdgeInsets.all(30.0),
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(10)),
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
                                      child: ElevatedButton(
                                        onPressed: () {
                                          setState(() {
                                            isLoad = true;
                                          });
                                          Authentication.signOut(
                                                  context: context,
                                                  isShowToast: false)
                                              .then((value) async {
                                            User user = await Authentication
                                                .signInWithGoogle(
                                                    context: context,
                                                    isSignIn: false);
                                            if (user != null) {
                                              bool isExisted = await Provider
                                                      .of<MemberListViewModel>(
                                                          context,
                                                          listen: false)
                                                  .checkIsExistedEmail(
                                                      user.email);
                                              setState(() {
                                                isLoad = false;
                                              });
                                              if (isExisted) {
                                                Fluttertoast.showToast(
                                                    msg:
                                                        "Email is existed, choose another email",
                                                    toastLength:
                                                        Toast.LENGTH_SHORT);
                                                return;
                                              }
                                              Provider.of<MemberListViewModel>(
                                                          context,
                                                          listen: false)
                                                      .insertMember =
                                                  MemberViewModel(Member(
                                                      email: user.email));
                                              Navigator.of(context)
                                                  .popAndPushNamed(
                                                      WELCOME_ROUTE);
                                            }
                                          });
                                        },
                                        style: ButtonStyle(
                                            padding: MaterialStateProperty
                                                .resolveWith((states) {
                                              return EdgeInsets.zero;
                                            }),
                                            shape: MaterialStateProperty
                                                .resolveWith((states) {
                                              return RoundedRectangleBorder(
                                                borderRadius:
                                                    BorderRadius.circular(20.0),
                                              );
                                            }),
                                            fixedSize:
                                                MaterialStateProperty.all<Size>(
                                                    Size(302, 44))),
                                        child: Ink(
                                          decoration: BoxDecoration(
                                              color: Colors.redAccent
                                                  .withOpacity(0.9),
                                              borderRadius:
                                                  BorderRadius.circular(20)),
                                          child: Container(
                                            child: Row(children: [
                                              Padding(
                                                padding: const EdgeInsets.only(
                                                    left: 12),
                                                child: IconButton(
                                                    onPressed: null,
                                                    icon: Image.asset(
                                                        getPathOfIcon(
                                                            "google-2.png"))),
                                              ),
                                              Padding(
                                                padding: const EdgeInsets.only(
                                                    left: 22),
                                                child: Text(
                                                    LABEL_ACCOUNT_REGISTER_BY_GMAIL,
                                                    style: TextStyle(
                                                        color: Colors.white,
                                                        fontSize: 15,
                                                        shadows: [
                                                          Shadow(
                                                            offset: Offset(
                                                                1.5, 1.5),
                                                            blurRadius: 3.0,
                                                            color:
                                                                Color.fromARGB(
                                                                    0, 0, 0, 0),
                                                          ),
                                                        ])),
                                              ),
                                            ]),
                                          ),
                                        ),
                                      ),
                                    ),
                                    Container(
                                      margin: EdgeInsets.only(bottom: 20),
                                      child: ElevatedButton(
                                        onPressed: () {
                                          Provider.of<AuthViewModel>(context,
                                                  listen: false)
                                              .setIsLogin(false);
                                          onRouter(
                                              REGISTER_BY_PHONE_INUT_PHONE_ROUTE);
                                        },
                                        style: ButtonStyle(
                                            padding: MaterialStateProperty
                                                .resolveWith((states) {
                                              return EdgeInsets.zero;
                                            }),
                                            shape: MaterialStateProperty
                                                .resolveWith((states) {
                                              return RoundedRectangleBorder(
                                                borderRadius:
                                                    BorderRadius.circular(20.0),
                                              );
                                            }),
                                            fixedSize:
                                                MaterialStateProperty.all<Size>(
                                                    Size(302, 44))),
                                        child: Ink(
                                          decoration: BoxDecoration(
                                              color:
                                                  Colors.green.withOpacity(0.9),
                                              borderRadius:
                                                  BorderRadius.circular(20)),
                                          child: Container(
                                            child: Row(children: [
                                              Padding(
                                                padding: const EdgeInsets.only(
                                                    left: 12),
                                                child: IconButton(
                                                    onPressed: null,
                                                    icon: Image.asset(
                                                        getPathOfIcon(
                                                            "phone-1.png"))),
                                              ),
                                              Padding(
                                                padding: const EdgeInsets.only(
                                                    left: 22),
                                                child: Text(
                                                    LABEL_ACCOUNT_REGISTER_BY_PHONE,
                                                    style: TextStyle(
                                                        color: Colors.white,
                                                        fontSize: 15,
                                                        shadows: [
                                                          Shadow(
                                                            offset: Offset(
                                                                1.5, 1.5),
                                                            blurRadius: 3.0,
                                                            color:
                                                                Color.fromARGB(
                                                                    0, 0, 0, 0),
                                                          ),
                                                        ])),
                                              ),
                                            ]),
                                          ),
                                        ),
                                      ),
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
