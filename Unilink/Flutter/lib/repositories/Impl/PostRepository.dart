import 'dart:convert';
import 'dart:io';

import 'package:unilink_flutter_app/apis/common.dart';
import 'package:unilink_flutter_app/models/post_model.dart';
import 'package:unilink_flutter_app/repositories/IPostRepository.dart';
import 'package:http/http.dart' as http;
import 'package:unilink_flutter_app/service/post_service.dart';

class PostRepository implements IPostRepository {
  PostService _postService = new PostService();
  Future<List<Post>> searchPost(String topic, String searchText,
      String pageSize, String curPage, String sortBy, String sortType) async {
    try {
      return _postService.searchPost(
          topic, searchText, pageSize, curPage, sortBy, sortType);
    } catch (e) {
      throw Exception(e.toString());
    }
  }

  @override
  Future<dynamic> getInfoPost(String id) async {
    try {
      return await _postService.getInfoPost(id);
    } catch (e) {
      throw Exception(e.toString());
    }
  }

  @override
  Future<List<Post>> getAll() {}

  @override
  Future createPost(
      String title, String content, String topicId, String createBy) async {
    try {
      return await _postService.createPost(title, content, topicId, createBy);
    } catch (e) {
      throw Exception(e.toString());
    }
  }

  @override
  Future updatePost(String title, String content, String topicId) async {
    try {
      return await _postService.updatePost(title, content, topicId);
    } catch (e) {
      throw Exception(e.toString());
    }
  }

  @override
  Future removePost(String postId) async {
    try {
      return await _postService.removePost(postId);
    } catch (e) {
      throw Exception(e.toString());
    }
  }
}
