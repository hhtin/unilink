import 'dart:typed_data';

import 'package:dotted_border/dotted_border.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';
import 'package:unilink_flutter_app/translate/vn.dart';
import 'package:unilink_flutter_app/utils/button.dart';
import 'package:unilink_flutter_app/view_model/member_view_model.dart';

class ModelImagePicker extends StatefulWidget {
  final Function callback;

  ModelImagePicker({Key key, this.callback}) : super(key: key);

  @override
  _ModelImagePickerState createState() => _ModelImagePickerState();
}

class _ModelImagePickerState extends State<ModelImagePicker> {
  Function callback;
  ImagePicker _picker = ImagePicker();
  XFile image;
  Uint8List currentImage;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    callback = widget.callback;
  }

  @override
  Widget build(BuildContext context) {
    return SimpleDialog(children: [
      Container(
        margin: EdgeInsets.only(left: 250, top: 10),
        width: 20,
        height: 20,
        decoration: BoxDecoration(
          image: DecorationImage(image: AssetImage("assets/icons/x-icon.png")),
        ),
        child: InkWell(
          onTap: () {
            Navigator.of(context, rootNavigator: true).pop();
          },
        ),
      ),
      Center(
        child: Text(
          "Chọn hình đại diện",
          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 24),
        ),
      ),
      Container(
          height: 450.0, // Change as per your requirement
          width: 450.0,
          margin: EdgeInsets.all(10),
          child: Column(children: [
            Container(
                child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                Padding(
                  padding: EdgeInsets.only(top: 0),
                  child: Column(
                    children: [
                      Center(
                          child: currentImage != null
                              ? InkWell(
                                  child: Container(
                                    decoration: BoxDecoration(
                                      shape: BoxShape.circle,
                                      color: Colors.black26,
                                    ),
                                    child: Icon(
                                      Icons.close,
                                    ),
                                  ),
                                  onTap: () {
                                    setState(() {
                                      currentImage = null;
                                    });
                                  },
                                )
                              : null),
                      Padding(
                          padding: EdgeInsets.only(top: 0),
                          child: SizedBox(
                            width: 170,
                            height: 170,
                            child: MaterialButton(
                              onPressed: () {
                                pickImgFromGallery();
                              },
                              padding: EdgeInsets.all(8.0),
                              elevation: 8.0,
                              child: currentImage != null
                                  ? Container(
                                      child: DottedBorder(
                                          color: Colors.black,
                                          strokeWidth: 1,
                                          child: Image.memory(currentImage)),
                                    )
                                  : Container(
                                      decoration: BoxDecoration(
                                        image: DecorationImage(
                                            image: AssetImage(
                                                'assets/icons/flus.png')),
                                      ),
                                      child: DottedBorder(
                                          color: Colors.black,
                                          strokeWidth: 1,
                                          child: Container()),
                                    ),
                            ),
                          )),
                      Padding(
                        padding: EdgeInsets.all(10),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            InkWell(
                              onTap: () {
                                pickImgFromCamera();
                              },
                              child: Icon(
                                Icons.camera_alt,
                                size: 35,
                              ),
                            ),
                            InkWell(
                                onTap: () {
                                  pickImgFromGallery();
                                },
                                child: Icon(
                                  Icons.image_outlined,
                                  size: 35,
                                ))
                          ],
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(
                            top: 25, right: 50, left: 60, bottom: 20),
                        child: Container(
                          child: Text(
                            LABEL_NOTIFY_INPUT_IMAGE,
                            style: TextStyle(
                                fontSize: 15,
                                color: Colors.black.withOpacity(0.75),
                                fontWeight: FontWeight.w500),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                Container(
                  margin: EdgeInsets.symmetric(horizontal: 20),
                  child: Container(
                    padding: EdgeInsets.all(10),
                    child: Container(
                      margin: EdgeInsets.only(bottom: 20),
                      child: ElevatedButton(
                        child: Container(
                          child: Text(
                            "Lưu",
                            style: TextStyle(fontSize: 20),
                          ),
                        ),
                        onPressed: () {
                          Provider.of<MemberListViewModel>(context,
                                  listen: false)
                              .avatarUpdate = this.image;
                          callback.call();
                          Navigator.of(context).pop();
                        },
                        style: getStyleElevatedButton(
                          width: 90,
                          height: 50,
                        ),
                      ),
                    ),
                  ),
                )
              ],
            ))
          ]))
    ]);
  }

  Future<void> pickImgFromGallery() async {
    XFile image = await _picker.pickImage(source: ImageSource.gallery);
    if (image != null) {
      Uint8List bytes = await image.readAsBytes();
      setState(() {
        currentImage = bytes;
        this.image = image;
      });
    }
  }

  Future<void> pickImgFromCamera() async {
    XFile image = await _picker.pickImage(source: ImageSource.camera);
    if (image != null) {
      Uint8List bytes = await image.readAsBytes();
      setState(() {
        currentImage = bytes;
        this.image = image;
      });
    }
  }
}
