import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:provider/provider.dart';
import 'package:unilink_flutter_app/constant/path_router.dart';
import 'package:unilink_flutter_app/translate/vn.dart';
import 'package:unilink_flutter_app/utils/button.dart';
import 'package:unilink_flutter_app/view_model/topic_view_model.dart';

// ignore: must_be_immutable
class ModelEditTopic extends StatefulWidget {
  Function callback;
  ModelEditTopic({Key key, this.callback}) : super(key: key);

  @override
  _ModelEditTopicState createState() => _ModelEditTopicState();
}

class _ModelEditTopicState extends State<ModelEditTopic> {
  final _formKey = GlobalKey<FormState>();
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
    TextEditingController topicName = TextEditingController(
        text:
            Provider.of<TopicListViewModel>(context, listen: false).topicName);
    TextEditingController description = TextEditingController(
        text: Provider.of<TopicListViewModel>(context, listen: false)
            .description);
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
                child: Form(
                  key: _formKey,
                  child: Column(
                    children: [
                      Text(LABEL_MODEL_EDIT_TOPIC_TITLE,
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
                          child: Table(
                            children: [
                              TableRow(
                                children: [
                                  Container(
                                    padding: EdgeInsets.only(top: 15),
                                    child: Text(
                                      LABEL_MODEL_CREATE_TOPIC_INPUT_TITLE,
                                      style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                          fontSize: 17),
                                    ),
                                  ),
                                  TextFormField(
                                      validator: (value) {
                                        if (value == null || value.isEmpty) {
                                          return 'Please enter topic name';
                                        }
                                        return null;
                                      },
                                      controller: topicName,
                                      decoration: InputDecoration(
                                          hintText:
                                              LABEL_MODEL_CREATE_TOPIC_HINT_INPUT_TITLE)),
                                ],
                              ),
                              TableRow(
                                children: [
                                  Container(
                                    padding: EdgeInsets.only(top: 15),
                                    child: Text(
                                      LABEL_MODEL_CREATE_TOPIC_INPUT_DES,
                                      style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                          fontSize: 17),
                                    ),
                                  ),
                                  TextFormField(
                                      controller: description,
                                      decoration: InputDecoration(
                                          hintText:
                                              LABEL_MODEL_CREATE_TOPIC_HINT_INPUT_DES)),
                                ],
                              ),
                            ],
                          )),
                      ElevatedButton(
                        onPressed: () async {
                          if (_formKey.currentState.validate()) {
                            updateTopic(topicName.text, description.text);
                          }
                        },
                        child: Text(LABEL_MODEL_EDIT_TOPIC_BUTTON),
                        style: getStyleElevatedButton(),
                      )
                    ],
                  ),
                ),
              ),
            ],
          );
  }

  Future<void> updateTopic(String topicName, String description) async {
    setState(() {
      isLoad = true;
    });
    await Provider.of<TopicListViewModel>(context, listen: false).updateTopic(
        topicName,
        description,
        Provider.of<TopicListViewModel>(context, listen: false).topicId);
    callback.call();
    Navigator.of(context).pop();
    Fluttertoast.showToast(
      msg: TOAST_EDIT_TOPIC,
      toastLength: Toast.LENGTH_LONG,
    );
  }
}
