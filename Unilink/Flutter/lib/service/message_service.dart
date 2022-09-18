import 'dart:convert';
import 'dart:io';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:unilink_flutter_app/apis/common.dart';
import 'package:unilink_flutter_app/models/create_message_image_model.dart';
import 'package:unilink_flutter_app/models/message.dart';
import 'package:unilink_flutter_app/service/common_service.dart';

class MessageService {
  Future<List<Message>> getGroupMessage(String groupId, int page) async {
    try {
      Map<String, String> queryParams = {
        'receiverId': groupId,
        "page": page.toString()
      };
      var uri = Uri.http("$HOST_MESSAGE", GET_MESSAGE_URL, queryParams);
      var response = await http.get(uri,
          headers: {HttpHeaders.contentTypeHeader: 'application/json'});
      if (response.statusCode == 200) {
        var decodedResponse = jsonDecode(response.body);
        var message = decodedResponse["message"];
        var receiver = decodedResponse["receiver"];
        List<Message> messageList = [];
        if (message != null) {
          (message as List)
              .forEach((element) => messageList.add(Message.jsonFrom(element)));
        }
        return messageList;
      }
      throw Exception();
    } on Exception catch (e) {
      throw Exception(e.toString());
    }
  }

  Future<Message> createMessage(String senderId, String receiverId,
      String senderName, String content) async {
    try {
      var data = {
        'senderId': senderId,
        'senderName': senderName,
        'receiverId': receiverId,
        'content': content
      };
      var bodyJson = jsonEncode(data);
      var uri = Uri.http("$HOST_MESSAGE", CREATE_MESSAGE_URL);
      var response = await http.post(uri,
          headers: {HttpHeaders.contentTypeHeader: 'application/json'},
          body: bodyJson);
      if (response.statusCode == 201) {
        var decodedResponse = jsonDecode(response.body) as Map;
        return Message.jsonFrom(decodedResponse);
      }
      throw Exception();
    } on Exception catch (e) {
      throw Exception(e.toString());
    }
  }

  Future<String> sendImage(CreateMessageImage createMessageImage) async {
    try {
      Map<String, dynamic> query = new Map();
      Map<String, dynamic> map = new Map();
      map["PartyId"] = createMessageImage.partyId;
      map["Image"] = await MultipartFile.fromFile(createMessageImage.image.path,
          filename: createMessageImage.image.name);

      final response = await CommonService.postFormDataToken(
          map, "https://unilink.tk:10040/api/v1/parties/message/image",
          queryParams: query);
      if (response.statusCode == 201) {
        final data = response.data["data"];
        return data;
      }
      throw Exception();
    } on Exception catch (e) {
      throw Exception(e.toString());
    }
  }
}
