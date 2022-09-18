import 'package:unilink_flutter_app/apis/common.dart';
import 'package:unilink_flutter_app/models/major.dart';
import 'package:unilink_flutter_app/service/common_service.dart';

class MajorService {
  Future<List<Major>> getAll() async {
    try {
      Map<String, String> queryString = {
        "isActive": "true",
        "isGetAll": "false",
      };
      var url = Uri.https(SERVER, GET_ALL_MAJOR, queryString);
      final data = await CommonService.get(url);
      List<Major> list = [];
      if (data != null) {
        (data as List).forEach((element) => list.add(Major.jsonFrom(element)));
      }
      return list;
    } catch (e) {
      throw Exception(e.toString());
    }
  }
}
