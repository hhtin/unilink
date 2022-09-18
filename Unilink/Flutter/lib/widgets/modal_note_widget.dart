import 'package:flutter/material.dart';
import 'package:unilink_flutter_app/models/note.dart';
import 'package:unilink_flutter_app/utils/button.dart';
import 'package:unilink_flutter_app/utils/color.dart';

class ModalNoteWidget extends StatefulWidget {
  @override
  _ModalNoteWidgetState createState() => _ModalNoteWidgetState();
}

class _ModalNoteWidgetState extends State<ModalNoteWidget> {
  final TextEditingController titleDetailController = TextEditingController();
  final TextEditingController contentDetailController = TextEditingController();
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
                onPressed: () {},
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
                onPressed: () {},
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
    return AlertDialog(
      content: Container(
        color: Colors.white,
        child: Column(
          children: [
            Container(
              child: Text(
                "Ghi chú",
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
              ),
            ),
            Expanded(
              flex: 10,
              child: Container(
                width: 600.0,
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
                              margin: EdgeInsets.all(5),
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
            Container(
              margin: EdgeInsets.only(top: 10),
              child: ElevatedButton(
                onPressed: () {
                  showDialog(
                      context: context,
                      builder: (context) {
                        return addNoteDialog(context);
                      });
                },
                child: Text("Thêm"),
                style: getStyleElevatedButton(),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
