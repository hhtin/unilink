import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:unilink_flutter_app/constant/path_router.dart';
import 'package:unilink_flutter_app/translate/vn.dart';

class Member {
  String name;
  String image;
  String content;
  Member({@required this.name, @required this.image, @required this.content});
}

// ignore: must_be_immutable
class ModelComment extends StatelessWidget {
  List<String> listSkill = ["java", "C#", "C++"];
  List<Member> listMember = [
    Member(
        name: "Long", image: "assets/icons/avatar-long.jpg", content: "Good"),
    Member(
        name: "Vinh", image: "assets/icons/avatar-vinh.jpg", content: "Good"),
    Member(
        name: "Tuan", image: "assets/icons/avatar-tuan.jpg", content: "Good"),
  ];
  @override
  Widget build(BuildContext context) {
    return SimpleDialog(
      children: [
        Container(
          margin: EdgeInsets.only(left: 250, top: 10),
          width: 20,
          height: 20,
          decoration: BoxDecoration(
            image:
                DecorationImage(image: AssetImage("assets/icons/x-icon.png")),
          ),
          child: InkWell(
            onTap: () {
              Navigator.of(context).pop();
            },
          ),
        ),
        Container(
          width: 400,
          padding: EdgeInsets.only(top: 0, bottom: 10, left: 10, right: 10),
          decoration: BoxDecoration(
              border:
                  Border(bottom: BorderSide(color: Colors.black, width: 1))),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Container(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(left: 8.0, top: 8.0),
                      child: Container(
                        padding: EdgeInsets.only(right: 30, left: 10),
                        // color: HexColor.fromHex("#CAFBCF"),
                        height: 85,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Padding(
                                  padding: const EdgeInsets.only(top: 5),
                                  child: Container(
                                    width: 50,
                                    height: 100,
                                    decoration: BoxDecoration(
                                      shape: BoxShape.circle,
                                      image: DecorationImage(
                                        image: AssetImage(
                                            "assets/icons/avatar-vinh.jpg"),
                                      ),
                                    ),
                                  ),
                                ),
                                Padding(
                                  padding:
                                      const EdgeInsets.only(top: 10, left: 20),
                                  child: Text(
                                    LABEL_20_MINUTES_AGO,
                                    style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 15),
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(top: 20, left: 8.0),
                child: Column(
                  children: <Widget>[
                    Align(
                      alignment: Alignment.centerLeft,
                      child: Container(
                        // color: Colors.red,
                        child: Text(
                          LABEL_QUESTION_TOPIC,
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(top: 20, left: 8.0),
                child: Column(
                  children: <Widget>[
                    Align(
                      alignment: Alignment.centerLeft,
                      child: Container(
                        // color: Colors.red,
                        child: Image.asset(
                          "assets/icons/question-image.png",
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
        Container(
          width: 400,
          padding: EdgeInsets.all(0),
          child: Container(
            child: ListView.builder(
              shrinkWrap: true,
              scrollDirection: Axis.vertical,
              itemCount: listMember.length,
              itemBuilder: (BuildContext context, int index) {
                return Container(
                  margin: EdgeInsets.all(10),
                  width: 250,
                  alignment: Alignment.bottomCenter,
                  child: Container(
                    padding: EdgeInsets.only(right: 5, left: 5),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Container(
                          width: 50,
                          height: 50,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            image: DecorationImage(
                              image: AssetImage(listMember[index].image),
                            ),
                          ),
                        ),
                        Container(
                          margin: EdgeInsets.only(left: 10),
                          width: 200,
                          height: 50,
                          decoration: BoxDecoration(
                              border: Border.all(width: 1),
                              borderRadius:
                                  BorderRadius.all(Radius.circular(15))),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              Container(
                                padding: EdgeInsets.only(right: 150),
                                child: Text(
                                  listMember[index].name,
                                  style: TextStyle(fontSize: 15),
                                ),
                              ),
                              Container(
                                padding: EdgeInsets.only(right: 150),
                                child: Text(
                                  listMember[index].content,
                                  style: TextStyle(fontSize: 15),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
          ),
        ),
        Align(
          alignment: Alignment.bottomLeft,
          child: Container(
            padding: EdgeInsets.only(left: 10, bottom: 10, top: 10),
            height: 60,
            width: double.infinity,
            color: Colors.white,
            child: Row(
              children: <Widget>[
                SizedBox(
                  width: 15,
                ),
                Expanded(
                  child: TextField(
                    decoration: InputDecoration(
                        hintText: "Write comment...",
                        hintStyle: TextStyle(color: Colors.black54),
                        border: InputBorder.none),
                  ),
                ),
                SizedBox(
                  width: 15,
                ),
                FloatingActionButton(
                  onPressed: () {},
                  child: Icon(
                    Icons.send,
                    color: Colors.white,
                    size: 18,
                  ),
                  backgroundColor: Colors.blue,
                  elevation: 0,
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
