import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:unilink_flutter_app/utils/color.dart';

BoxDecoration getBoxDecoration() {
  return BoxDecoration(
    borderRadius: BorderRadius.circular(10),
    color: Colors.white,
    boxShadow: [
      BoxShadow(
        color: PrimaryColor.withOpacity(0.2),
        spreadRadius: 2,
        blurRadius: 7,
        offset: Offset(0, 3), // changes position of shadow
      ),
    ],
  );
}
