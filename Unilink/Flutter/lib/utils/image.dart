import 'dart:typed_data';

import 'package:flutter/services.dart';

Future<Uint8List> convertNetworkToUInt8List(String url) async {
  try {
    ByteData bytes = await NetworkAssetBundle(Uri.parse(url)).load(url);
    Uint8List tmpavatar = bytes.buffer.asUint8List();
    return tmpavatar;
  } catch (e) {
    print(e);
  }
}
