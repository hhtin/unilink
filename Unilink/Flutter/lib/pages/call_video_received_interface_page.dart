import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:unilink_flutter_app/constant/path_router.dart';
import 'package:unilink_flutter_app/utils/asset_icon.dart';
import 'package:unilink_flutter_app/utils/hex_color.dart';

class CallVideoReceivedInterfacePage extends StatefulWidget {
  @override
  _CallVideoReceivedInterfacePageState createState() =>
      _CallVideoReceivedInterfacePageState();
}

class _CallVideoReceivedInterfacePageState
    extends State<CallVideoReceivedInterfacePage> {
  onRouter(String path) => Navigator.of(context).pushNamed(path);
  List<String> listImageMemberJoin = [
    'assets/icons/avatar-long.jpg',
    'assets/icons/avatar-tin.jpg',
    'assets/icons/avatar-tuan.jpg',
    'assets/icons/avatar-vinh.jpg',
    'assets/icons/avatar-tuan.jpg',
    'assets/icons/avatar-tuan.jpg',
  ];
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
            gradient: HexColor.fromHexLinear("7DC584", "3B809D",
                FractionalOffset.topCenter, FractionalOffset.bottomCenter)),
        alignment: Alignment.center,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Padding(
              padding: EdgeInsets.only(top: 40, right: 30, left: 10),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Padding(
                    padding: EdgeInsets.only(top: 0),
                    child: Container(
                      child: Ink(
                        decoration: ShapeDecoration(
                          shape: CircleBorder(),
                        ),
                        child: IconButton(
                          onPressed: () {
                            Navigator.of(context)
                                .pushNamed(CALL_VIDEO_INTERFACE_PAGE_ROUTE);
                          },
                          color: Colors.white,
                          iconSize: 40,
                          icon: Image.asset(getPathOfIcon("back.png")),
                        ),
                      ),
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.only(top: 0),
                    child: Container(
                      width: 30,
                      height: 30,
                      decoration: BoxDecoration(
                        image: DecorationImage(
                            image: AssetImage("assets/icons/setting.png"),
                            fit: BoxFit.fill),
                      ),
                      child: InkWell(
                        onTap: () {},
                      ),
                    ),
                  ),
                ],
              ),
            ),
            Container(
              margin: EdgeInsets.all(0),
              width: 200,
              height: 200,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                image: DecorationImage(
                    image: AssetImage(getPathOfIcon('avatar-long.jpg')),
                    fit: BoxFit.fill),
              ),
            ),
            Container(
              padding: EdgeInsets.all(20),
              child: Text(
                'CALLING....',
                style: TextStyle(
                    fontSize: 25,
                    fontWeight: FontWeight.bold,
                    color: Colors.white),
              ),
            ),
            Container(
              margin: EdgeInsets.symmetric(horizontal: 50),
              height: 60,
              child: ListView.builder(
                shrinkWrap: true,
                scrollDirection: Axis.horizontal,
                itemCount: listImageMemberJoin.length,
                itemBuilder: (BuildContext context, int index) {
                  return Container(
                    padding: EdgeInsets.all(5),
                    margin: EdgeInsets.all(5),
                    width: 60,
                    height: 60,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      image: DecorationImage(
                          image: AssetImage(listImageMemberJoin[index]),
                          fit: BoxFit.fill),
                    ),
                  );
                },
              ),
            ),
            Container(
              padding: EdgeInsets.all(50),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Container(
                    margin: EdgeInsets.all(0),
                    width: 100,
                    height: 100,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      image: DecorationImage(
                          image: AssetImage(getPathOfIcon('accept-call.png')),
                          fit: BoxFit.fill),
                    ),
                    child: InkWell(
                      onTap: () {},
                    ),
                  ),
                  Container(
                    margin: EdgeInsets.all(0),
                    width: 100,
                    height: 100,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      image: DecorationImage(
                          image: AssetImage(getPathOfIcon('refuse-call.png')),
                          fit: BoxFit.fill),
                    ),
                    child: InkWell(
                      onTap: () {},
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
