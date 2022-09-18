import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:unilink_flutter_app/repositories/IAuthenRepository.dart';
import 'package:unilink_flutter_app/repositories/Impl/AuthenRepository.dart';

class AuthViewModel extends ChangeNotifier {
  IAuthenRepository authenRepository = new AuthenRepository();
  bool isLogin = true;
  bool isNotFound = false;
  void setIsLogin(bool login) {
    isLogin = login;
    notifyListeners();
  }

  Future<void> loginByEmail(String email, String deviceToken) async {
    try {
      await authenRepository.loginByEmail(email, deviceToken);
      isNotFound = false;
      notifyListeners();
    } catch (e) {
      if (e.toString().contains("Not found user with following email")) {
        isNotFound = true;
      }
      print(e.toString());
    }
  }
}
