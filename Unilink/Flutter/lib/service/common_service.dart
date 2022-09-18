import 'dart:collection';
import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:http/http.dart' as http;
import 'package:localstorage/localstorage.dart';
import 'package:unilink_flutter_app/models/member_model.dart';

class CommonService {
  static final LocalStorage storage = new LocalStorage('unilink_app');
  static const String HEADER_TOKEN = "X-Unilink-Token";
  static HashMap<String, String> headers = new HashMap();
  static Future<dynamic> get(Uri url) async {
    try {
      if (url.path.contains("auth")) {
        headers["Accept"] = "application/json";
        headers["content-type"] = "application/json";
        final response =
            await http.get(url, headers: {"Accept": "application/json"});
        if (response.statusCode == 200) {
          final body = jsonDecode(response.body);
          return body["data"];
        } else {
          throw Exception(response.body);
        }
      } else {
        final response = await http.get(url, headers: headers);
        if (response.statusCode == 200) {
          final body = jsonDecode(response.body);
          return body["data"];
        } else {
          throw Exception(response.body);
        }
      }
    } catch (e) {
      throw Exception(e.toString());
    }
  }

  static Future<void> setHeader() async {
    var token = await storage.getItem("token");
    headers[HEADER_TOKEN] = token.toString();
  }

  static dynamic post(Uri url, Object body) async {
    final response = await http.post(url, headers: headers, body: body);
    if (response.statusCode == 201 || response.statusCode == 200) {
      final body = jsonDecode(response.body);
      return body["data"];
    } else {
      throw Exception("Unable to perform request");
    }
  }

  static dynamic put(Uri url, Object body) async {
    final response = await http.put(url, body: body, headers: headers);
    if (response.statusCode == 200) {
      final body = jsonDecode(response.body);
      return body["data"];
    } else {
      throw Exception("Unable to perform request");
    }
  }

  static dynamic delete(Uri url) async {
    final response = await http.delete(url, headers: headers);
    if (response.statusCode == 200) {
      final body = jsonDecode(response.body);
      return body["data"];
    } else {
      throw Exception("Unable to perform request");
    }
  }

  static dynamic putFormData(Map<String, dynamic> body, String url) async {
    Dio dio = Dio();
    dio.options.headers = headers;
    FormData formData = new FormData.fromMap(body);
    final response = await dio.put(url, data: formData);
    if (response.statusCode == 200) {
      return response.data["data"];
    } else {
      throw Exception("Unable to perform request");
    }
  }

  static dynamic postFormData(Map<String, dynamic> body, String url,
      {Map<String, dynamic> queryParams}) async {
    Dio dio = Dio();
    FormData formData = new FormData.fromMap(body);
    dio.options.headers.addEntries([
      MapEntry("Content-Type", "multipart/form-data, application/json"),
    ]);
    dio.options.queryParameters = queryParams;
    final response = await dio.post(url, data: formData);
    if (response.statusCode == 201) {
      return response;
    } else {
      throw Exception("Unable to perform request ${response.statusCode}");
    }
  }

  static dynamic postFormDataToken(Map<String, dynamic> body, String url,
      {Map<String, dynamic> queryParams}) async {
    var token = await storage.getItem("token");
    Dio dio = Dio();
    FormData formData = new FormData.fromMap(body);
    dio.options.headers.addEntries([
      MapEntry("Content-Type", "multipart/form-data, application/json"),
      MapEntry(HEADER_TOKEN, token)
    ]);
    dio.options.queryParameters = queryParams;
    final response = await dio.post(url, data: formData);
    if (response.statusCode == 201) {
      return response;
    } else {
      throw Exception("Unable to perform request ${response.statusCode}");
    }
  }

  static dynamic putFormDataToken(Map<String, dynamic> body, String url,
      {Map<String, dynamic> queryParams}) async {
    var token = await storage.getItem("token");
    Dio dio = Dio();
    FormData formData = new FormData.fromMap(body);
    dio.options.headers.addEntries([
      MapEntry("Content-Type", "multipart/form-data, application/json"),
      MapEntry(HEADER_TOKEN, token)
    ]);
    dio.options.queryParameters = queryParams;
    final response = await dio.put(url, data: formData);
    if (response.statusCode == 201 || response.statusCode == 200) {
      return response;
    } else {
      throw Exception("Unable to perform request ${response.statusCode}");
    }
  }

  static dynamic postToServerNode(Uri url, Object body) async {
    final response = await http.post(url, headers: headers, body: body);
    if (response.statusCode == 201 || response.statusCode == 200) {
      final body = jsonDecode(response.body);
      return body["result"];
    } else {
      throw Exception("Unable to perform request");
    }
  }

  static dynamic getToServerNode(Uri url) async {
    final response = await http.get(url);
    if (response.statusCode == 201 || response.statusCode == 200) {
      final body = jsonDecode(response.body);
      return body;
    } else {
      throw Exception("Unable to perform request");
    }
  }

  static Future<dynamic> getNotData(Uri url) async {
    try {
      final response = await http.get(url, headers: headers);
      if (response.statusCode != 200) {
        throw Exception(response.body);
      }
    } catch (e) {
      throw Exception(e.toString());
    }
  }
}
