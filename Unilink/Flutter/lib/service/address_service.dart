import 'dart:collection';
import 'dart:convert';

import 'package:unilink_flutter_app/apis/common.dart';
import 'package:unilink_flutter_app/models/district_model.dart';
import 'package:unilink_flutter_app/models/province_model.dart';
import 'package:http/http.dart' as http;

class AddressService {
  static HashMap<String, String> headers = new HashMap();

  Future<List<Province>> getAllProvince() async {
    try {
      headers["depth"] = "2";
      headers["Accept"] = "application/json";
      var url = Uri.https(SERVER_ADDRESS, GET_ALL_PROVINCE, headers);
      final response = await http.get(url, headers: headers);
      if (response.statusCode == 200) {
        final body = jsonDecode(Utf8Decoder().convert(response.bodyBytes));
        final data = body;
        List<Province> list = [];
        if (data != null) {
          (data as List)
              .forEach((element) => list.add(Province.jsonFrom(element)));
        }
        return list;
      } else {
        throw Exception(response.body);
      }
    } catch (e) {
      print(e.toString());
      throw Exception(e.toString());
    }
  }

  Future<List<District>> getDistrictByProvinceCode(String code) async {
    try {
      headers["depth"] = "2";
      var url = Uri.https(SERVER_ADDRESS, GET_PROVINCE + "/$code", headers);
      final response = await http.get(url, headers: headers);
      if (response.statusCode == 200) {
        final body = jsonDecode(response.body);
        final data = body["districts"];
        List<District> list = [];
        if (data != null) {
          (data as List)
              .forEach((element) => list.add(District.jsonFrom(element)));
        }
        return list;
      } else {
        throw Exception(response.body);
      }
    } catch (e) {
      print(e.toString());
      throw Exception(e.toString());
    }
  }
}
