import 'package:flutter/material.dart';

// ignore: must_be_immutable
class PageTitleWidget extends StatefulWidget {
  String title;
  PageTitleWidget({Key key, this.title}) : super(key: key);
  @override
  _PageTitleWidgetState createState() => _PageTitleWidgetState();
}

class _PageTitleWidgetState extends State<PageTitleWidget> {
  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Container(
          margin: EdgeInsets.only(top: 10, bottom: 10),
          decoration: BoxDecoration(
              borderRadius: BorderRadius.only(
                  topRight: Radius.circular(10),
                  bottomRight: Radius.circular(10)),
              color: Colors.orange.shade200),
          child: Padding(
            padding: const EdgeInsets.all(10),
            child: Container(
              child: Text(
                widget.title,
                style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 20,
                    color: Colors.white),
              ),
            ),
          ),
        )
      ],
    );
  }
}
