import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:unilink_flutter_app/utils/color.dart';

enum SprinnerType { CIRCULAR, PROGRESS }

extension SpinnerTypeExp on SprinnerType {
  static Widget getSpinnerType(type) {
    switch (type) {
      case SprinnerType.CIRCULAR:
        return CircularProgressIndicator();
      case SprinnerType.PROGRESS:
        return LinearProgressIndicator();
      default:
        return CircularProgressIndicator();
    }
  }
}

class Spinner {
  static FutureBuilder spinnerWithFuture(
      Future<dynamic> asyncMethod, Function(dynamic data) callback,
      {Function(dynamic error) error,
      SprinnerType type = SprinnerType.CIRCULAR,
      Widget customWidget}) {
    return FutureBuilder(
        initialData: 0,
        future: asyncMethod,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.done) {
            if (snapshot.hasError) {
              return error != null
                  ? error(snapshot.error)
                  : throw new Exception(snapshot.error.toString());
            }
            return callback(snapshot.data);
          } else {
            return customWidget != null
                ? customWidget
                : Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [SpinnerTypeExp.getSpinnerType(type)],
                  );
          }
        });
  }

  static void blockUiWithSpinnerScreen(BuildContext context,
      {bool isReplace = false, int seconds = 0}) {
    if (isReplace) {
      Navigator.of(context)
          .pushReplacement(MaterialPageRoute(builder: (_) => SpinnerScreen()));
    }
    Navigator.of(context)
        .push(MaterialPageRoute(builder: (_) => SpinnerScreen()));
    if (seconds != 0) {
      Future.delayed(Duration(seconds: seconds))
          .then((value) => Navigator.of(context).pop());
    }
  }
}

class SpinnerScreen extends StatelessWidget {
  const SpinnerScreen({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Primary,
      body: Center(
        child: SpinKitRotatingCircle(
          color: Secondary,
          size: 70.0,
        ),
      ),
    );
  }
}
