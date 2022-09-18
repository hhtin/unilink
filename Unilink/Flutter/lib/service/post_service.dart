import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:unilink_flutter_app/apis/common.dart';
import 'package:unilink_flutter_app/models/post_model.dart';

import 'package:http/http.dart' as http;
import 'package:unilink_flutter_app/service/common_service.dart';

class PostService {
  Future<List<Post>> searchPost(String topic, String searchText,
      String pageSize, String curPage, String sortBy, String sortType) async {
    try {
      Map<String, dynamic> queryString = {
        "topic": topic,
        "searchText": searchText,
        "pageSize": pageSize,
        "curPage": curPage,
        "sortBy": sortBy,
        "sortType": sortType,
      };
      var url = Uri.https(SERVER, POST, queryString);
      final data = await CommonService.get(url);

      List<Post> list = [];
      if (data["data"] != null) {
        (data["data"] as List)
            .forEach((element) => list.add(Post.jsonFrom(element)));
      }
      return list;
    } catch (e) {
      throw Exception(e.toString());
    }
  }

  Future<dynamic> getInfoPost(String id) async {
    try {
      var url = Uri.https(SERVER, POST + "/$id");
      final data = await CommonService.get(url);
      return data;
    } catch (e) {
      throw Exception(e.toString());
    }
  }

  Future<dynamic> createPost(
      String title, String content, String topicId, String createBy) async {
    try {
      var url = Uri.https(SERVER, POST);
      var insertObj = jsonEncode({
        "title": title,
        "content": content,
        "topicId": topicId,
        "createBy": createBy
      });
      final data = await CommonService.post(url, insertObj);
      return data;
    } catch (e) {
      throw Exception(e.toString());
    }
  }

  Future<dynamic> updatePost(
      String title, String content, String topicId) async {
    try {
      var url = Uri.https(SERVER, POST);
      var updateObj = jsonEncode({
        "id": topicId,
        "title": title,
        "content": content,
      });
      final data = await CommonService.put(url, updateObj);
      return data;
    } catch (e) {
      throw Exception(e.toString());
    }
  }

  Future<dynamic> removePost(String postId) async {
    try {
      var url = Uri.https(SERVER, POST + "/$postId");
      final data = await CommonService.delete(url);
      return data;
    } catch (e) {
      throw Exception(e.toString());
    }
  }
}
