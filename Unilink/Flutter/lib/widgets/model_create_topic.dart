import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:provider/provider.dart';
import 'package:unilink_flutter_app/constant/path_router.dart';
import 'package:unilink_flutter_app/translate/vn.dart';
import 'package:unilink_flutter_app/utils/button.dart';
import 'package:unilink_flutter_app/view_model/party_view_model.dart';
import 'package:unilink_flutter_app/view_model/topic_view_model.dart';

// ignore: must_be_immutable
class ModelCreateTopic extends StatefulWidget {
  Function callback;
  ModelCreateTopic({Key key, this.callback}) : super(key: key);

  @override
  _ModelCreateTopicState createState() => _ModelCreateTopicState();
}

class _ModelCreateTopicState extends State<ModelCreateTopic> {
  TextEditingController topicName = TextEditingController();
  TextEditingController description = TextEditingController();
  Function callback;
  bool isLoad = false;
  final _formKey = GlobalKey<FormState>();
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
                    Navigator.of(context, rootNavigator: true).pop();
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
                      Text(LABEL_MODEL_CREATE_TOPIC_TITLE,
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
                            creatTopic();
                          }
                        },
                        child: Text(LABEL_MODEL_CREATE_TOPIC_BUTTON),
                        style: getStyleElevatedButton(),
                      )
                    ],
                  ),
                ),
              ),
            ],
          );
  }

  Future<void> creatTopic() async {
    setState(() {
      isLoad = true;
    });
    await Provider.of<TopicListViewModel>(context, listen: false).createTopic(
        topicName.text,
        description.text,
        Provider.of<PartyListViewModel>(context, listen: false)
            .currentParty
            .party
            .id);
    callback.call();
    Navigator.of(context).pop();
    Fluttertoast.showToast(
      msg: TOAST_CREATE_TOPIC,
      toastLength: Toast.LENGTH_LONG,
    );
  }
}
