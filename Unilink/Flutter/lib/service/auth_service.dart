import 'package:localstorage/localstorage.dart';
import 'package:unilink_flutter_app/apis/authen_api.dart';
import 'package:unilink_flutter_app/apis/common.dart';
import 'package:unilink_flutter_app/service/common_service.dart';

class AuthenService {
  final LocalStorage storage = new LocalStorage('unilink_app');
  Future<void> loginByEmail(String email, String deviceToken) async {
    try {
      Map<String, String> queryParams = {"deviceToken": deviceToken};
      var url = Uri.https(SERVER, AUTH_EMAIL + "/" + email, queryParams);
      final res = await CommonService.get(url);
      var token = res["token"];
      await storage.deleteItem("token");
      await storage.setItem("token", token);
      await CommonService.setHeader();
    } catch (e) {
      throw new Exception(e.toString());
    }
  }
}
