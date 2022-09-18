import 'package:flutter/material.dart';
import 'package:unilink_flutter_app/translate/vn.dart';
import 'package:unilink_flutter_app/utils/asset_icon.dart';
import 'package:unilink_flutter_app/utils/color.dart';
import 'package:unilink_flutter_app/utils/hex_color.dart';

class MyGroupsPage extends StatefulWidget {
  // const MyGroupsPage({ Key? key }) : super(key: key);

  @override
  _MyGroupsPageState createState() => _MyGroupsPageState();
}

class _MyGroupsPageState extends State<MyGroupsPage> {
  int currentIndex = 1;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Success,
        leading: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Container(
              decoration: BoxDecoration(
                  image: DecorationImage(
                    image: new ExactAssetImage('assets/icons/avatar-long.jpg'),
                  ),
                  borderRadius: BorderRadius.circular(80))),
        ),
        title: Text(
          LABEL_GROUP,
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 28,
            color: Colors.white,
            shadows: [
              Shadow(
                  // bottomLeft
                  offset: Offset(-1.5, -1.5),
                  color: Colors.black),
              Shadow(
                  // bottomRight
                  offset: Offset(1.5, -1.5),
                  color: Colors.black),
              Shadow(
                  // topRight
                  offset: Offset(1.5, 1.5),
                  color: Colors.black),
              Shadow(
                  // topLeft
                  offset: Offset(-1.5, 1.5),
                  color: Colors.black),
            ],
          ),
        ),
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 6),
            child: IconButton(
                onPressed: null,
                icon: Image.asset(
                  getPathOfIcon("edit.png"),
                  width: 28,
                  height: 25,
                )),
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Container(
              margin: EdgeInsets.only(top: 25),
            ),
            Padding(
              padding: const EdgeInsets.only(top: 25),
              child: Container(
                child: Text(
                  LABLE_MY_GROUP,
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 23,
                  ),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(top: 10),
              child: Container(
                height: 120,
                child: Card(
                  color: Colors.white,
                  shadowColor: Colors.blueGrey,
                  elevation: 10,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: <Widget>[
                      Padding(
                        padding: const EdgeInsets.only(top: 12),
                        child: ListTile(
                          leading: new Image.asset(
                              "assets/icons/avatar-group.png",
                              alignment: Alignment.center),
                          title: Text(
                            "Nhóm học Springboot",
                            style: TextStyle(
                                fontSize: 20, fontWeight: FontWeight.bold),
                          ),
                          subtitle: Column(
                            children: [
                              Row(
                                children: [
                                  Image.asset(
                                    'assets/icons/skill_15px.png',
                                    width: 17,
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.only(left: 10),
                                    child: SizedBox(
                                      child: Text(
                                        "Learning springboot",
                                        maxLines: 1,
                                        overflow: TextOverflow.ellipsis,
                                        softWrap: false,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                              Padding(
                                padding: const EdgeInsets.only(top: 5),
                                child: Row(
                                  children: [
                                    Image.asset(
                                      'assets/icons/location_15px.png',
                                      width: 17,
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.only(left: 10),
                                      child: SizedBox(
                                        child: Text(
                                          "Fpt University",
                                          maxLines: 1,
                                          overflow: TextOverflow.ellipsis,
                                          softWrap: false,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.only(top: 5),
                                child: Row(
                                  children: [
                                    Image.asset(
                                      'assets/icons/member_15px.png',
                                      width: 17,
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.only(left: 10),
                                      child: SizedBox(
                                        child: Text(
                                          "2/5",
                                          maxLines: 1,
                                          overflow: TextOverflow.ellipsis,
                                          softWrap: false,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                          trailing: ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                  primary: HexColor.fromHex("#62C5DB")),
                              child: Text(LABLE_DETAIL),
                              onPressed: () {}),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(top: 10),
              child: Container(
                height: 120,
                child: Card(
                  color: Colors.white,
                  shadowColor: Colors.blueGrey,
                  elevation: 10,
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: <Widget>[
                      Padding(
                        padding: const EdgeInsets.only(top: 12),
                        child: ListTile(
                          leading: new Image.asset(
                              "assets/icons/avatar-group.png",
                              alignment: Alignment.center),
                          title: Text(
                            "Nhóm học C#",
                            style: TextStyle(
                                fontSize: 20, fontWeight: FontWeight.bold),
                          ),
                          subtitle: Column(
                            children: [
                              Row(
                                children: [
                                  Image.asset(
                                    'assets/icons/skill_15px.png',
                                    width: 17,
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.only(left: 10),
                                    child: SizedBox(
                                      child: Text(
                                        "Learning C#",
                                        maxLines: 1,
                                        overflow: TextOverflow.ellipsis,
                                        softWrap: false,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                              Padding(
                                padding: const EdgeInsets.only(top: 5),
                                child: Row(
                                  children: [
                                    Image.asset(
                                      'assets/icons/location_15px.png',
                                      width: 17,
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.only(left: 10),
                                      child: SizedBox(
                                        child: Text(
                                          "Fpt University",
                                          maxLines: 1,
                                          overflow: TextOverflow.ellipsis,
                                          softWrap: false,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.only(top: 5),
                                child: Row(
                                  children: [
                                    Image.asset(
                                      'assets/icons/member_15px.png',
                                      width: 17,
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.only(left: 10),
                                      child: SizedBox(
                                        child: Text(
                                          "2/5",
                                          maxLines: 1,
                                          overflow: TextOverflow.ellipsis,
                                          softWrap: false,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                          trailing: ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                  primary: HexColor.fromHex("#62C5DB")),
                              child: Text(LABLE_DETAIL),
                              onPressed: () {}),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(top: 10),
              child: Container(
                height: 120,
                child: Card(
                  color: Colors.white,
                  shadowColor: Colors.blueGrey,
                  elevation: 10,
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: <Widget>[
                      Padding(
                        padding: const EdgeInsets.only(top: 12),
                        child: ListTile(
                          leading: new Image.asset(
                              "assets/icons/avatar-group.png",
                              alignment: Alignment.center),
                          title: Text(
                            "Nhóm học Marketing",
                            style: TextStyle(
                                fontSize: 20, fontWeight: FontWeight.bold),
                          ),
                          subtitle: Column(
                            children: [
                              Row(
                                children: [
                                  Image.asset(
                                    'assets/icons/skill_15px.png',
                                    width: 17,
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.only(left: 10),
                                    child: SizedBox(
                                      child: Text(
                                        "Learning marketing",
                                        maxLines: 1,
                                        overflow: TextOverflow.ellipsis,
                                        softWrap: false,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                              Padding(
                                padding: const EdgeInsets.only(top: 5),
                                child: Row(
                                  children: [
                                    Image.asset(
                                      'assets/icons/location_15px.png',
                                      width: 17,
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.only(left: 10),
                                      child: SizedBox(
                                        child: Text(
                                          "Fpt University",
                                          maxLines: 1,
                                          overflow: TextOverflow.ellipsis,
                                          softWrap: false,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.only(top: 5),
                                child: Row(
                                  children: [
                                    Image.asset(
                                      'assets/icons/member_15px.png',
                                      width: 17,
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.only(left: 10),
                                      child: SizedBox(
                                        child: Text(
                                          "4/5",
                                          maxLines: 1,
                                          overflow: TextOverflow.ellipsis,
                                          softWrap: false,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                          trailing: ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                  primary: HexColor.fromHex("#62C5DB")),
                              child: Text(LABLE_DETAIL),
                              onPressed: () {}),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: Container(
        child: BottomNavigationBar(
          type: BottomNavigationBarType.fixed,
          backgroundColor: Success,
          selectedItemColor: Colors.black,
          unselectedItemColor: Colors.black.withOpacity(.50),
          selectedFontSize: 14,
          elevation: 0,
          unselectedFontSize: 12,
          onTap: (index) => setState(() => currentIndex = index),
          currentIndex: currentIndex,
          items: [
            BottomNavigationBarItem(
              label: 'Trang chủ',
              icon: Icon(Icons.home),
            ),
            BottomNavigationBarItem(
              label: 'Hội nhóm',
              icon: Icon(Icons.group),
            ),
            BottomNavigationBarItem(
              label: 'Tin nhắn',
              icon: Icon(Icons.message),
            ),
            BottomNavigationBarItem(
              label: 'Tài khoản',
              icon: Icon(Icons.account_circle),
            ),
          ],
        ),
      ),
    );
  }
}
