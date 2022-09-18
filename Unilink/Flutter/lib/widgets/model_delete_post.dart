import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:http/http.dart';
import 'package:provider/provider.dart';
import 'package:unilink_flutter_app/translate/vn.dart';
import 'package:unilink_flutter_app/utils/button.dart';
import 'package:unilink_flutter_app/view_model/post_view_model.dart';

class ModelDeletePost extends StatefulWidget {
  Function callback;
  ModelDeletePost({Key key, this.callback}) : super(key: key);

  @override
  _ModelDeletePostState createState() => _ModelDeletePostState();
}

class _ModelDeletePostState extends State<ModelDeletePost> {
  bool isLoad = false;
  Function callback;
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
                alignment: Alignment.center,
                width: 400,
                padding:
                    EdgeInsets.only(top: 10, bottom: 20, left: 20, right: 20),
                child: Column(
                  children: [
                    Text(LABEL_MODEL_DELETE_POST_DELETE,
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
                            print(Provider.of<PostListViewModel>(context,
                                    listen: false)
                                .topicId);
                            deletePost();
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

  Future<void> deletePost() async {
    setState(() {
      isLoad = true;
    });
    await Provider.of<PostListViewModel>(context, listen: false).removePost(
        Provider.of<PostListViewModel>(context, listen: false).updateId);
    callback.call();
    Navigator.of(context).pop();
    Fluttertoast.showToast(
      msg: LABEL_MODEL_DELETE_POST_DELETE_SUCCESS,
      toastLength: Toast.LENGTH_LONG,
    );
  }
}
