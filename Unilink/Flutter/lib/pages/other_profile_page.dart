import 'package:dotted_border/dotted_border.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:unilink_flutter_app/constant/path_router.dart';
import 'package:unilink_flutter_app/utils/asset_icon.dart';
import 'package:unilink_flutter_app/utils/button.dart';
import 'package:unilink_flutter_app/utils/color.dart';
import 'package:unilink_flutter_app/widgets/app_bar_child_widget.dart';

class OtherProfilePage extends StatefulWidget {
  @override
  _OtherProfilePageState createState() => _OtherProfilePageState();
}

class _OtherProfilePageState extends State<OtherProfilePage> {
  final List<String> images = [
    "name-30px.png",
    "university-30px.png",
    "DOB-30px.png",
    "location-30px.png",
    "major-30px.png",
    "gender-30px.png",
    "skill-30px.png",
  ];
  final List<String> infor = [
    "Nguyễn Quốc Vinh",
    "FPT University",
    "31/02/2021",
    "02 Đường 3/2  CMT8",
    "Software Engineer",
    "Nam",
    "Java",
  ];
  Widget _renderProfile(index) {
    return Container(
      margin: EdgeInsets.only(bottom: 20),
      child: Row(
        key: UniqueKey(),
        children: [
          Image.asset(getPathOfIcon(images[index])),
          Padding(
            padding: const EdgeInsets.only(left: 40.0),
            child: Text(
              infor[index],
              style: TextStyle(fontSize: 20),
            ),
          )
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
          preferredSize: const Size(double.infinity, kToolbarHeight),
          child: AppBarChildWidget(
            indexScreen: 0,
            path: MAIN_ROUTE,
          )),
      body: Container(
        color: Colors.white,
        child: Column(
          children: [
            SingleChildScrollView(
              child: Container(
                padding: EdgeInsets.only(left: 40.0, right: 40.0, bottom: 20.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Padding(
                      padding: EdgeInsets.only(bottom: 10.0),
                      child: Image.asset(getPathOfIcon("avatar-vinh.png")),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(bottom: 10.0),
                      child: Text("Nguyễn Quốc Vinh",
                          style: TextStyle(
                              color: Colors.black,
                              fontSize: 20,
                              fontWeight: FontWeight.bold)),
                    ),
                    Padding(
                      padding: EdgeInsets.only(left: 20, right: 20, bottom: 10),
                      child: ElevatedButton(
                        onPressed: () {},
                        child: Text(
                          "Mời vào nhóm",
                          style: TextStyle(
                              fontWeight: FontWeight.bold, fontSize: 15),
                        ),
                        style: getStyleElevatedButton(
                            width: 150,
                            radius: 10,
                            type: ButtonType.PRIMARY_COLOR),
                      ),
                    ),
                    DottedBorder(
                      strokeWidth: 1,
                      color: Success,
                      child: Container(
                        padding: EdgeInsets.all(2.0),
                        child: Center(
                            child: Padding(
                          child: Text(
                            "Yêu màu hồng ghét sự giả dối, đam mê Java, nghiện C#, cưng chiều Flutter",
                            textAlign: TextAlign.center,
                            style: TextStyle(fontSize: 20),
                          ),
                          padding: EdgeInsets.all(20),
                        )),
                      ),
                    )
                  ],
                ),
              ),
            ),
            Container(
              padding: EdgeInsets.only(left: 40.0, right: 40.0, bottom: 20.0),
              child: Column(
                children: List.generate(
                    images.length, (index) => _renderProfile(index)),
              ),
            )
          ],
        ),
      ),
    );
  }
}
