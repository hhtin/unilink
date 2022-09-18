import 'package:unilink_flutter_app/apis/common.dart';
import 'package:unilink_flutter_app/models/major_skill.dart';
import 'package:unilink_flutter_app/service/common_service.dart';

class MajorSkillService {
  Future<List<MajorSkill>> getAll() async {
    try {
      Map<String, String> queryString = {
        "isActive": "true",
        "isGetAll": "true",
      };
      var url = Uri.https(SERVER, GET_ALL_MAJOR, queryString);
      final data = await CommonService.get(url);
      List<MajorSkill> list = [];
      if (data != null) {
        (data as List)
            .forEach((element) => list.add(MajorSkill.jsonFrom(element)));
      }
      return list;
    } catch (e) {
      throw Exception(e.toString());
    }
  }
}
