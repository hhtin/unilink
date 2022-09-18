import 'dart:convert';

import 'package:unilink_flutter_app/apis/common.dart';
import 'package:unilink_flutter_app/models/skill.dart';

import 'package:http/http.dart' as http;
import 'package:unilink_flutter_app/service/common_service.dart';

class SkillService {
  Future<List<Skill>> getAll() async {
    try {
      Map<String, String> queryString = {
        "isActive": "true",
        "isGetAll": "false",
      };
      var url = Uri.https(SERVER, GET_ALL_SKILL, queryString);
      final data = await CommonService.get(url);
      List<Skill> list = [];
      if (data != null) {
        (data as List).forEach((element) => list.add(Skill.jsonFrom(element)));
      }
      return list;
    } catch (e) {
      throw Exception(e.toString());
    }
  }
}
