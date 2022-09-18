import 'dart:convert';
import 'dart:ffi';
import 'dart:io';
import 'dart:typed_data';

import 'package:dotted_border/dotted_border.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:provider/provider.dart';
import 'package:unilink_flutter_app/constant/path_router.dart';
import 'package:unilink_flutter_app/pages/register_by_phone/start_join_page.dart';
import 'package:unilink_flutter_app/translate/vn.dart';
import 'package:unilink_flutter_app/utils/button.dart';
import 'package:unilink_flutter_app/view_model/firebase_init.dart';
import 'package:unilink_flutter_app/view_model/member_view_model.dart';
import 'package:unilink_flutter_app/widgets/app_bar_child_widget.dart';
import 'package:image_picker/image_picker.dart';
import 'package:http/http.dart' as http;

class RegisterByPhoneInputImagePage extends StatefulWidget {
  @override
  _RegisterByPhoneInputImageState createState() =>
      _RegisterByPhoneInputImageState();
}

class _RegisterByPhoneInputImageState
    extends State<RegisterByPhoneInputImagePage> {
  bool isLoad = false;
  ImagePicker _picker = ImagePicker();
  XFile image;
  Uint8List currentImage;
  onRouter(String path) => Navigator.of(context)
      .pushNamedAndRemoveUntil(path, (Route<dynamic> route) => false);
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
          preferredSize: const Size(double.infinity, kToolbarHeight),
          child: AppBarChildWidget(
            path: REGISTER_BY_PHONE_INPUT_SKILL_ROUTE,
          )),
      body: isLoad
          ? Center(
              child: CircularProgressIndicator(),
            )
          : Container(
              color: Colors.white,
              child: Container(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    Padding(
                      padding: EdgeInsets.only(right: 190, bottom: 29),
                      child: Center(
                        child: Text(LABEL_ENTER_IMAGE,
                            textAlign: TextAlign.center,
                            style: TextStyle(
                                fontSize: 24,
                                color: Colors.black.withOpacity(0.75),
                                fontWeight: FontWeight.w500)),
                      ),
                    ),
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
                                width: 250,
                                height: 250,
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
                                              child:
                                                  Image.memory(currentImage)),
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
                    Padding(
                        padding: EdgeInsets.only(top: 20),
                        child: Container(
                          margin: EdgeInsets.only(bottom: 30),
                          alignment: Alignment.center,
                          height: 44,
                          width: 302,
                          child: ElevatedButton(
                              onPressed: () {
                                if (currentImage != null) {
                                  setState(() {
                                    isLoad = true;
                                  });
                                  register();
                                  return;
                                }
                                Fluttertoast.showToast(msg: "Select image");
                              },
                              style: getStyleElevatedButton(
                                  width: 302, height: 44),
                              child: Text(
                                LABEL_BUTTON_NEXT,
                                style: TextStyle(
                                    fontSize: 17, fontWeight: FontWeight.bold),
                              )),
                        ))
                  ],
                ),
              ),
            ),
    );
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

  Future<void> register() async {
    Provider.of<MemberListViewModel>(context, listen: false)
        .insertMember
        .image = this.image;
    String deviceToken =
        Provider.of<FireBaseInit>(context, listen: false).token;
    bool isCreate =
        await Provider.of<MemberListViewModel>(context, listen: false)
            .registerAccount(deviceToken);
    setState(() {
      isLoad = false;
    });
    if (isCreate) {
      Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(
          builder: (BuildContext context) => StartJoinApp(),
        ),
        (route) => false,
      );
      Fluttertoast.showToast(
        msg: TOAST_REGISTER_ACCOUNT,
        toastLength: Toast.LENGTH_LONG,
      );
    } else {
      Fluttertoast.showToast(
        msg: "Có lỗi xảy ra, thử lại",
        toastLength: Toast.LENGTH_LONG,
      );
    }
  }
}
