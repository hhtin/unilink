import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:unilink_flutter_app/constant/path_router.dart';
import 'package:unilink_flutter_app/models/notify.dart';
import 'package:unilink_flutter_app/translate/vn.dart';
import 'package:unilink_flutter_app/utils/color.dart';
import 'package:unilink_flutter_app/utils/decoration_box.dart';
import 'package:unilink_flutter_app/view_model/notify_view_model.dart';
import 'package:unilink_flutter_app/widgets/app_bar_child_widget.dart';
import 'package:unilink_flutter_app/widgets/page_title_widget.dart';

class NotificationPage extends StatefulWidget {
  @override
  _NotificationPageState createState() => _NotificationPageState();
}

class _NotificationPageState extends State<NotificationPage> {
  var notis = [];
  @override
  void initState() {
    super.initState();
    notis = Provider.of<NotifyViewModel>(context, listen: false).notis;
  }

  Widget notifyDetailDialog(Notify noti) {
    return SimpleDialog(
      children: [
        Container(
          padding: EdgeInsets.all(20),
          child: Column(
            children: [
              Container(
                margin: EdgeInsets.only(bottom: 20),
                child: Text(noti.title,
                    style:
                        TextStyle(fontWeight: FontWeight.bold, fontSize: 17)),
              ),
              Text(
                noti.content,
                style: TextStyle(fontSize: 15),
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
      appBar: PreferredSize(
          preferredSize: const Size(double.infinity, kToolbarHeight),
          child: AppBarChildWidget(
            path: MAIN_ROUTE,
          )),
      body: Container(
          color: Colors.white,
          child: Column(
            children: [
              PageTitleWidget(title: TITLE_NOTIFICATION),
              Expanded(
                child: ListView.builder(
                    shrinkWrap: true,
                    scrollDirection: Axis.vertical,
                    itemCount: notis.length,
                    itemBuilder: (BuildContext context, int index) {
                      return InkWell(
                          onTap: () {
                            showDialog(
                                context: context,
                                builder: (context) {
                                  return notifyDetailDialog(notis[index]);
                                });
                          },
                          child: Container(
                            height: 120,
                            margin: EdgeInsets.all(10),
                            padding: EdgeInsets.all(20),
                            decoration: getBoxDecoration(),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Container(
                                  child: Column(
                                    children: [
                                      Container(
                                        margin: EdgeInsets.only(bottom: 10),
                                        child: Row(
                                          children: [
                                            Container(
                                                padding: EdgeInsets.all(5),
                                                decoration: BoxDecoration(
                                                    color: PrimaryColor,
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            5)),
                                                child: Text(
                                                  notis[index].title,
                                                  textAlign: TextAlign.left,
                                                  style: TextStyle(
                                                      color: Colors.black,
                                                      fontWeight:
                                                          FontWeight.bold),
                                                )),
                                          ],
                                        ),
                                      ),
                                      Container(
                                        margin: EdgeInsets.only(bottom: 10),
                                        child: Row(
                                          children: [
                                            Flexible(
                                              child: new Container(
                                                padding: new EdgeInsets.only(
                                                    right: 13.0),
                                                child: new Text(
                                                  notis[index].content,
                                                  overflow:
                                                      TextOverflow.ellipsis,
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
                                  child: Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Container(
                                        padding:
                                            new EdgeInsets.only(right: 13.0),
                                        child: Text(
                                          notis[index].date,
                                        ),
                                      ),
                                      Container(
                                          padding: EdgeInsets.only(right: 10),
                                          child: notis[index].isSeen
                                              ? Container(
                                                  width: 10,
                                                  height: 10,
                                                  padding: EdgeInsets.all(5),
                                                  decoration: BoxDecoration(
                                                      color: Colors.green,
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              5)),
                                                )
                                              : Container(
                                                  width: 10,
                                                  height: 10,
                                                  padding: EdgeInsets.all(5),
                                                  decoration: BoxDecoration(
                                                      color: Colors.red,
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              5)),
                                                ))
                                    ],
                                  ),
                                )
                              ],
                            ),
                          ));
                    }),
              )
            ],
          )),
    );
  }
}
