import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:unilink_flutter_app/constant/path_router.dart';
import 'package:unilink_flutter_app/models/note.dart';
import 'package:unilink_flutter_app/translate/vn.dart';
import 'package:unilink_flutter_app/utils/button.dart';
import 'package:unilink_flutter_app/utils/color.dart';
import 'package:unilink_flutter_app/widgets/app_bar_child_widget.dart';
import 'package:unilink_flutter_app/widgets/page_title_widget.dart';

class NotePage extends StatefulWidget {
  @override
  _NotePageState createState() => _NotePageState();
}

class _NotePageState extends State<NotePage> {
  final TextEditingController titleDetailController = TextEditingController();
  final TextEditingController contentDetailController = TextEditingController();

  @override
  void initState() {
    super.initState();
    titleDetailController.text = "hello";
    contentDetailController.text =
        "ddddddddddddddddddddddddddddddddddddddddddddddddddddd";
  }

  var note = [
    Note(
        id: "1",
        title: "123",
        content: "1111111111111111111111111111111111111111111",
        dateTime: "12/12/2000",
        status: 1),
    Note(
        id: "1",
        title: "123",
        content: "1111111111111111111111111111111111111111111",
        dateTime: "12/12/2000",
        status: 1),
    Note(
        id: "1",
        title: "123",
        content: "1111111111111111111111111111111111111111111",
        dateTime: "12/12/2002",
        status: 1),
    Note(
        id: "1",
        title: "123",
        content: "1111111111111111111111111111111111111111111",
        dateTime: "12/12/2002",
        status: 1),
    Note(
        id: "1",
        title: "123",
        content: "1111111111111111111111111111111111111111111",
        dateTime: "12/12/2002",
        status: 1),
  ];
  Widget detailNoteDialog(BuildContext context) {
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
              Navigator.of(context, rootNavigator: true).pop();
            },
          ),
        ),
        Center(
          child: Text(
            "Chi tiết ghi chú",
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
          ),
        ),
        Container(
          width: 500,
          margin: EdgeInsets.all(10),
          child: Column(
            children: [
              TextField(
                controller: titleDetailController,
                decoration: const InputDecoration(
                    border: OutlineInputBorder(), labelText: 'Tiêu đề'),
              ),
              Container(
                margin: EdgeInsets.only(top: 20),
                color: Colors.yellow.shade200,
                child: TextField(
                  controller: contentDetailController,
                  maxLines: 20,
                  decoration: const InputDecoration(
                      border: OutlineInputBorder(), labelText: 'Nội dung'),
                ),
              ),
              ElevatedButton(
                onPressed: () {
                  Navigator.of(context).pop();
                  Fluttertoast.showToast(
                    msg: TOAST_EDIT_NOTE,
                    toastLength: Toast.LENGTH_LONG,
                  );
                },
                child: Text("Lưu"),
                style: getStyleElevatedButton(),
              )
            ],
          ),
        )
      ],
    );
  }

  Widget addNoteDialog(BuildContext context) {
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
              Navigator.of(context, rootNavigator: true).pop();
            },
          ),
        ),
        Center(
          child: Text(
            "Thêm ghi chú",
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
          ),
        ),
        Container(
          width: 500,
          margin: EdgeInsets.all(10),
          child: Column(
            children: [
              TextField(
                decoration: const InputDecoration(
                    border: OutlineInputBorder(), labelText: 'Tiêu đề'),
              ),
              Container(
                margin: EdgeInsets.only(top: 20),
                color: Colors.yellow.shade200,
                child: TextField(
                  maxLines: 20,
                  decoration: const InputDecoration(
                      border: OutlineInputBorder(), labelText: 'Nội dung'),
                ),
              ),
              ElevatedButton(
                onPressed: () {
                  Navigator.of(context).pop();
                  Fluttertoast.showToast(
                    msg: TOAST_ADD_NOTE,
                    toastLength: Toast.LENGTH_LONG,
                  );
                },
                child: Text("Lưu"),
                style: getStyleElevatedButton(),
              )
            ],
          ),
        )
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: PreferredSize(
          preferredSize: const Size(double.infinity, kToolbarHeight),
          child: AppBarChildWidget(
            indexScreen: 0,
            path: GROUP_ROUTE,
          )),
      body: Container(
        color: Colors.white,
        child: Column(
          children: [
            PageTitleWidget(title: "Ghi chú"),
            Expanded(
              child: Container(
                margin: EdgeInsets.only(right: 20, left: 20),
                height: 500,
                child: ListView.builder(
                    scrollDirection: Axis.vertical,
                    itemCount: note.length,
                    itemBuilder: (BuildContext context, int index) {
                      return InkWell(
                          onTap: () {
                            showDialog(
                                context: context,
                                builder: (context) {
                                  return detailNoteDialog(context);
                                });
                          },
                          child: Container(
                              padding: EdgeInsets.all(20),
                              margin: EdgeInsets.all(20),
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(10),
                                color: Colors.yellow.shade200,
                                boxShadow: [
                                  BoxShadow(
                                    color: PrimaryColor.withOpacity(0.2),
                                    spreadRadius: 2,
                                    blurRadius: 7,
                                    offset: Offset(
                                        0, 3), // changes position of shadow
                                  ),
                                ],
                              ),
                              width: 400,
                              height: 140,
                              child: Container(
                                child: Column(
                                  children: [
                                    Text(
                                      note[index].title,
                                      style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                          fontSize: 20),
                                    ),
                                    Container(
                                      margin: EdgeInsets.all(10),
                                      child: Text(
                                        note[index].dateTime,
                                        style: TextStyle(
                                            fontWeight: FontWeight.bold,
                                            color: Colors.grey),
                                      ),
                                    ),
                                    Text(note[index].content),
                                  ],
                                ),
                              )));
                    }),
              ),
            ),
          ],
        ),
      ),
      floatingActionButton: Container(
        height: 80,
        width: 80,
        margin: EdgeInsets.only(bottom: 12),
        child: FittedBox(
          child: FloatingActionButton(
            onPressed: () {
              showDialog(
                  context: context,
                  builder: (context) {
                    return addNoteDialog(context);
                  });
            },
            child: const Icon(
              Icons.add,
              size: 30,
            ),
            backgroundColor: PrimaryColor,
          ),
        ),
      ),
    );
  }
}
