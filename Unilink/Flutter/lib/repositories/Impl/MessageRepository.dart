import 'package:unilink_flutter_app/models/create_message_image_model.dart';
import 'package:unilink_flutter_app/models/message.dart';
import 'package:unilink_flutter_app/service/message_service.dart';

class MessageRepository {
  final MessageService _messageService = MessageService();
  Future<List<Message>> getGroupMessage(String groupId, int page) async {
    try {
      return await _messageService.getGroupMessage(groupId, page);
    } on Exception catch (e) {
      throw Exception(e.toString());
    }
  }

  Future<Message> createPeerMessage(String senderId, String receiverId,
      String senderName, String content) async {
    try {
      return await _messageService.createMessage(
          senderId, receiverId, senderName, content);
    } on Exception catch (e) {
      throw Exception(e.toString());
    }
  }

  Future<String> sendImage(CreateMessageImage createMessageImage) async {
    try {
      return await _messageService.sendImage(createMessageImage);
    } on Exception catch (e) {
      throw Exception(e.toString());
    }
  }
}
