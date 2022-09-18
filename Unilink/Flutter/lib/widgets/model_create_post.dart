import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';
import 'package:unilink_flutter_app/constant/path_router.dart';
import 'package:unilink_flutter_app/translate/vn.dart';
import 'package:unilink_flutter_app/utils/button.dart';
import 'package:unilink_flutter_app/view_model/member_view_model.dart';
import 'package:unilink_flutter_app/view_model/post_view_model.dart';
import 'package:zefyrka/zefyrka.dart';

// ignore: must_be_immutable
class ModelCreatePost extends StatefulWidget {
  Function callback;
  ModelCreatePost({Key key, this.callback}) : super(key: key);

  @override
  _ModelCreatePostState createState() => _ModelCreatePostState();
}

class _ModelCreatePostState extends State<ModelCreatePost> {
  Function callback;
  ZefyrController _controller = ZefyrController();
  TextEditingController _titleController = TextEditingController();
  // ignore: unused_field
  final ImagePicker _picker = ImagePicker();
  bool isLoad = false;
  // Pick an image

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
                padding: EdgeInsets.only(left: 20, right: 20),
                child: Column(
                  children: [
                    Text(LABEL_MODEL_CREATE_POST_TITLE,
                        style: TextStyle(
                            fontWeight: FontWeight.bold, fontSize: 20)),
                    Container(
                        margin: EdgeInsets.only(top: 20, bottom: 5),
                        child: Column(
                          children: [
                            Container(
                              padding: EdgeInsets.only(top: 15),
                              child: Text(
                                LABEL_MODEL_CREATE_POST_INPUT_TITLE,
                                style: TextStyle(
                                    fontWeight: FontWeight.bold, fontSize: 17),
                              ),
                            ),
                            TextField(
                                controller: _titleController,
                                decoration: InputDecoration(
                                    hintText:
                                        LABEL_MODEL_CREATE_POST_HINT_INPUT_TITLE)),
                          ],
                        )),
                  ],
                ),
              ),
              Center(
                child: Container(
                  margin: EdgeInsets.only(bottom: 10),
                  padding: EdgeInsets.only(top: 15),
                  child: Text(
                    "Nội dung",
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 17),
                  ),
                ),
              ),
              Container(
                  padding: EdgeInsets.only(left: 20, right: 20),
                  child: Column(
                    children: [
                      Divider(
                          height: 1, thickness: 1, color: Colors.grey.shade200),
                      ZefyrToolbar.basic(controller: _controller),
                    ],
                  )),
              Container(
                padding: EdgeInsets.all(20),
                height: 200,
                child: ZefyrEditor(
                  controller: _controller,
                  autofocus: true,
                ),
              ),
              Container(
                padding: EdgeInsets.all(20),
                child: ElevatedButton(
                  onPressed: () async {
                    createPost();
                  },
                  child: Text(LABEL_MODEL_CREATE_POST_BUTTON),
                  style: getStyleElevatedButton(),
                ),
              )
            ],
          );
  }

  Future<void> createPost() async {
    setState(() {
      isLoad = true;
    });
    await Provider.of<PostListViewModel>(context, listen: false)
        .createPost(_titleController.text, _controller.document.toString());
    await Provider.of<PostListViewModel>(context, listen: false)
        .searchPost("", "0", "0", "CreateDate", "dsc");
    callback.call();
    Navigator.of(context).pop();
    Fluttertoast.showToast(
      msg: TOAST_CREATE_POST,
      toastLength: Toast.LENGTH_LONG,
    );
  }
}
