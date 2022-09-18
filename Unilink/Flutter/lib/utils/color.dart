// ignore_for_file: non_constant_identifier_names

import 'package:flutter/material.dart';
import 'package:unilink_flutter_app/utils/hex_color.dart';

final PrimaryColor = HexColor.fromHex("#88ba97");

final PrimaryGradientColorVertical = HexColor.fromHexLinear("8EDC9D", "E6ED92",
    FractionalOffset.topCenter, FractionalOffset.bottomCenter);

final PrimaryGradientColorHorizontal = HexColor.fromHexLinear("8EDC9D",
    "E6ED92", FractionalOffset.centerLeft, FractionalOffset.centerRight);

final PrimaryLightColor = Color(0xFFF1E6FF);

final Primary = HexColor.fromHex("#5e72e4");
final Secondary = HexColor.fromHex("#f7fafc");
final Info = HexColor.fromHex("#11cdef");
final Success = HexColor.fromHex("#2dce89");
final Warning = HexColor.fromHex("#fb6340");
final Error = HexColor.fromHex("#f5365c");
final Default = HexColor.fromHex("#172b4d");

final Primary_On_Press = HexColor.fromHex("#324cdd");
final Secondary_On_Press = HexColor.fromHex("#919ca6");
final Info_On_Press = HexColor.fromHex("#0da5c0");
final Success_On_Press = HexColor.fromHex("#24a46d");
final Warning_On_Press = HexColor.fromHex("#fa3a0e");
final Error_On_Press = HexColor.fromHex("#ec0c38");
final Default_On_Press = HexColor.fromHex("#24a46d");

//Color status
final OnlineColor = HexColor.fromHex("#64DC51");
final OfflineColor = HexColor.fromHex("#000000");
final Unseen = HexColor.fromHex("#0094ff");
final Seen = HexColor.fromHex("#ededed");
