import 'package:flutter/material.dart';
import 'package:unilink_flutter_app/utils/asset_icon.dart';

// ignore: must_be_immutable
class AppBarChildWidget extends StatefulWidget {
  String path;
  int indexScreen = 0;
  Color color;
  AppBarChildWidget({Key key, this.path, this.indexScreen, this.color})
      : super(key: key);

  @override
  _AppBarChildWidgetState createState() => _AppBarChildWidgetState();
}

class _AppBarChildWidgetState extends State<AppBarChildWidget> {
  @override
  Widget build(BuildContext context) {
    onRouter(String path) => Navigator.of(context).pop();
    return Container(
        child: AppBar(
      backgroundColor: widget.color == null ? Colors.white : widget.color,
      elevation: 0.0,
      leading: Container(),
      bottom: PreferredSize(
        preferredSize: Size.fromHeight(1),
        child: Padding(
            padding: EdgeInsets.all(1),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Container(
                  alignment: Alignment.topLeft,
                  margin: EdgeInsets.only(left: 10),
                  child: Ink(
                    decoration: ShapeDecoration(
                      shape: CircleBorder(),
                    ),
                    child: IconButton(
                        onPressed: () {
                          onRouter(widget.path);
                        },
                        color: Colors.white,
                        iconSize: 35,
                        icon: Image.asset(getPathOfIcon("back.png"))),
                  ),
                ),
              ],
            )),
      ),
    ));
  }
}
