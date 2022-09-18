import 'package:flutter/material.dart';
import 'package:unilink_flutter_app/utils/color.dart' as color;

enum ButtonType {
  DEFAULT,
  SECONDARY,
  INFO,
  SUCCESS,
  WARNING,
  ERROR,
  PRIMARY,
  PRIMARY_COLOR
}

extension ButtonTypeExt on ButtonType {
  static Color getColor(ButtonType type) {
    switch (type) {
      case ButtonType.SECONDARY:
        return color.Secondary;
      case ButtonType.INFO:
        return color.Info;
      case ButtonType.SUCCESS:
        return color.Success;
      case ButtonType.WARNING:
        return color.Warning;
      case ButtonType.ERROR:
        return color.Error;
      case ButtonType.PRIMARY:
        return color.Primary;
      case ButtonType.PRIMARY_COLOR:
        return color.PrimaryColor;
      default:
        return color.Default;
    }
  }
}

extension ButtonTypePressExt on ButtonType {
  static Color getColorOnPress(ButtonType type) {
    switch (type) {
      case ButtonType.SECONDARY:
        return color.Secondary_On_Press;
      case ButtonType.INFO:
        return color.Info_On_Press;
      case ButtonType.SUCCESS:
        return color.Success_On_Press;
      case ButtonType.WARNING:
        return color.Warning_On_Press;
      case ButtonType.ERROR:
        return color.Error_On_Press;
      case ButtonType.PRIMARY:
        return color.Primary_On_Press;
      default:
        return color.Default_On_Press;
    }
  }
}

ButtonStyle getStyleElevatedButton({
  double width = 200,
  double height = 40,
  double radius = 20,
  double elevation = 0.0,
  ButtonType type = ButtonType.PRIMARY_COLOR,
}) {
  return ButtonStyle(
      foregroundColor: MaterialStateProperty.all<Color>(
          type == ButtonType.SECONDARY ? Colors.black : Colors.white),
      elevation: MaterialStateProperty.all<double>(elevation),
      backgroundColor:
          MaterialStateProperty.resolveWith<Color>((Set<MaterialState> states) {
        if (states.contains(MaterialState.pressed)) {
          return ButtonTypePressExt.getColorOnPress(type);
        } else {
          return ButtonTypeExt.getColor(type);
        }
      }),
      padding: MaterialStateProperty.resolveWith((states) => EdgeInsets.zero),
      shape:
          MaterialStateProperty.resolveWith((states) => RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(radius),
              )),
      fixedSize: MaterialStateProperty.all<Size>(Size(width, height)));
}
