import 'dart:convert';

import 'package:unilink_flutter_app/apis/common.dart';
import 'package:unilink_flutter_app/models/topic_model.dart';
import 'package:unilink_flutter_app/service/common_service.dart';

class TopicService {
  Future<List<Topic>> getAll() async {
    try {
      Uri url = Uri.https(SERVER, GET_ALL_TOPIC);
      final data = await CommonService.get(url);
      List<Topic> list = [];
      if (data != null) {
        (data as List).forEach((element) => list.add(Topic.jsonFrom(element)));
      }
      return list;
    } catch (e) {
      throw Exception(e.toString());
    }
  }

  Future<List<Topic>> getTopicByParty(String partyId, String pageSize,
      String curPage, String sortBy, String sortType) async {
    try {
      Map<String, dynamic> queryString = {
        "partyId": partyId,
        "pageSize": pageSize,
        "curPage": curPage,
        "sortBy": sortBy,
        "sortType": sortType,
      };
      var url = Uri.https(SERVER, GET_TOPIC_BY_PARTY + "/$partyId");

      final data = await CommonService.get(url);

      List<Topic> list = [];
      if (data["data"] != null) {
        (data["data"] as List)
            .forEach((element) => list.add(Topic.jsonFrom(element)));
      }
      return list;
    } catch (e) {
      throw Exception(e.toString());
    }
  }

  Future<dynamic> createTopic(
      String title, String description, String partyId) async {
    try {
      var url = Uri.https(SERVER, GET_ALL_TOPIC);
      var insertObj = jsonEncode(
          {"title": title, "description": description, "partyId": partyId});
      final data = await CommonService.post(url, insertObj);
      return data;
    } catch (e) {
      throw Exception(e.toString());
    }
  }

  Future<dynamic> updateTopic(
      String title, String description, String topicId) async {
    try {
      var url = Uri.https(SERVER, GET_ALL_TOPIC);
      var updateObj = jsonEncode({
        "id": topicId,
        "title": title,
        "description": description,
      });
      final data = await CommonService.put(url, updateObj);
      return data;
    } catch (e) {
      throw Exception(e.toString());
    }
  }

  Future<dynamic> deleteTopic(String topicId) async {
    try {
      var url = Uri.https(SERVER, GET_ALL_TOPIC + "/$topicId");
      final data = await CommonService.delete(url);
      return data;
    } catch (e) {
      throw Exception(e.toString());
    }
  }
}
