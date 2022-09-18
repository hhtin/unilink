import 'package:flutter/material.dart';
import 'package:unilink_flutter_app/constant/path_router.dart';
import 'package:unilink_flutter_app/translate/vn.dart';
import 'package:unilink_flutter_app/utils/color.dart';

class AppBarMainWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
        child: AppBar(
      backgroundColor: Colors.white,
      elevation: 0.0,
      leading: Container(),
      bottom: PreferredSize(
        preferredSize: Size.fromHeight(10),
        child: Padding(
            padding: EdgeInsets.all(10),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  LABEL_APP_NAME,
                  style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: Colors.black),
                ),
                Container(
                  margin: EdgeInsets.only(right: 20),
                  width: 80,
                  padding:
                      EdgeInsets.only(left: 10, right: 10, top: 5, bottom: 5),
                  decoration: BoxDecoration(
                      color: PrimaryColor,
                      borderRadius: BorderRadius.circular(10)),
                  child: InkWell(
                      onTap: () {
                        Navigator.of(context).pushNamed(NOTIFY_ROUTE);
                      },
                      child: Center(
                        child: Icon(
                          Icons.notifications,
                          color: Colors.black,
                          size: 25,
                        ),
                      )),
                )
              ],
            )),
      ),
    ));
  }
}
