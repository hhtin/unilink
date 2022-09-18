import 'package:flutter/cupertino.dart';

extension HexColor on Color {
  /// String is in the format "aabbcc" or "ffaabbcc" with an optional leading "#".
  static Color fromHex(String hexString) {
    final buffer = StringBuffer();
    if (hexString.length == 6 || hexString.length == 7) buffer.write('ff');
    buffer.write(hexString.replaceFirst('#', ''));
    return Color(int.parse(buffer.toString(), radix: 16));
  }

  static LinearGradient fromHexLinear(String startHex, String endHex,
      FractionalOffset begin, FractionalOffset end) {
    final startColor = HexColor.fromHex(startHex);
    final endColor = HexColor.fromHex(endHex);
    return LinearGradient(
        begin: begin,
        end: end,
        tileMode: TileMode.clamp,
        colors: <Color>[startColor, endColor]);
  }

  /// Prefixes a hash sign if [leadingHashSign] is set to `true` (default is `true`).
  String toHex({bool leadingHashSign = true}) => '${leadingHashSign ? '#' : ''}'
      '${alpha.toRadixString(16).padLeft(2, '0')}'
      '${red.toRadixString(16).padLeft(2, '0')}'
      '${green.toRadixString(16).padLeft(2, '0')}'
      '${blue.toRadixString(16).padLeft(2, '0')}';
}
