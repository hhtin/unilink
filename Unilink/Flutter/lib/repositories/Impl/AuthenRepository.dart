import 'dart:convert';

import 'package:unilink_flutter_app/repositories/IAuthenRepository.dart';
import 'package:unilink_flutter_app/service/auth_service.dart';

class AuthenRepository implements IAuthenRepository {
  AuthenService authenService = new AuthenService();
  @override
  Future<void> loginByEmail(String email, String deviceToken) async {
    try {
      await authenService.loginByEmail(email, deviceToken);
    } catch (e) {
      throw Exception(e);
    }
  }
}
