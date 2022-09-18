import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:provider/provider.dart';
import 'package:unilink_flutter_app/translate/vn.dart';
import 'package:unilink_flutter_app/utils/button.dart';
import 'package:unilink_flutter_app/view_model/topic_view_model.dart';

// ignore: must_be_immutable
class ModelDeleteTopic extends StatefulWidget {
  Function callback;
  ModelDeleteTopic({Key key, this.callback}) : super(key: key);

  @override
  _ModelDeleteTopicState createState() => _ModelDeleteTopicState();
}

class _ModelDeleteTopicState extends State<ModelDeleteTopic> {
  Function callback;
  bool isLoad = false;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    callback = widget.callback;
  }

  @override
  Widget build(BuildContext context) {
    return isLoad
        ? Center(
            child: CircularProgressIndicator(),
          )
        : SimpleDialog(
            children: [
              Container(
                margin: EdgeInsets.only(left: 250, top: 10),
                width: 20,
                height: 20,
                decoration: BoxDecoration(
                  image: DecorationImage(
                      image: AssetImage("assets/icons/x-icon.png")),
                ),
                child: InkWell(
                  onTap: () {
                    Navigator.of(context).pop();
                  },
                ),
              ),
              Container(
                width: 400,
                padding:
                    EdgeInsets.only(top: 10, bottom: 20, left: 20, right: 20),
                child: Column(
                  children: [
                    Text(
                        LABEL_MODEL_DELETE_TOPIC_DELETE +
                            " ${Provider.of<TopicListViewModel>(context, listen: false).topicName}?",
                        style: TextStyle(
                            fontWeight: FontWeight.bold, fontSize: 20)),
                    Container(
                      margin: EdgeInsets.only(top: 20),
                      child: CircleAvatar(
                        backgroundImage:
                            AssetImage("assets/icons/avatar-group.png"),
                      ),
                    ),
                    Container(
                      margin: EdgeInsets.only(top: 20, bottom: 20),
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: <Widget>[
                        ElevatedButton(
                          onPressed: () async {
                            print(Provider.of<TopicListViewModel>(context,
                                    listen: false)
                                .topicId);
                            deleteTopic();
                          },
                          child: Text(LABEL_MODEL_DELETE_TOPIC_DELETE_AGREE),
                          style: getStyleElevatedButton(
                              type: ButtonType.PRIMARY_COLOR,
                              radius: 10,
                              width: 80),
                        ),
                        ElevatedButton(
                          onPressed: () {
                            Navigator.of(context).pop();
                          },
                          child: Text(LABEL_MODEL_DELETE_TOPIC_DELETE_CANCEL),
                          style: getStyleElevatedButton(
                              type: ButtonType.PRIMARY_COLOR,
                              radius: 10,
                              width: 80),
                        ),
                      ],
                    )
                  ],
                ),
              ),
            ],
          );
  }

  Future<void> deleteTopic() async {
    setState(() {
      isLoad = true;
    });
    await Provider.of<TopicListViewModel>(context, listen: false).deleteTopic(
        Provider.of<TopicListViewModel>(context, listen: false).topicId);
    callback.call();
    Navigator.of(context).pop();
    Fluttertoast.showToast(
      msg: LABEL_MODEL_DELETE_TOPIC_DELETE_SUCCESS,
      toastLength: Toast.LENGTH_LONG,
    );
  }
}
