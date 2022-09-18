import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/foundation.dart';

class FireBaseInit extends ChangeNotifier {
  String token;
  Future<void> init() async {
    await Firebase.initializeApp();
    token = await FirebaseMessaging.instance.getToken();
  }
}
