import 'package:flutter/cupertino.dart';
import 'package:image_picker/image_picker.dart';
import 'package:unilink_flutter_app/models/create_message_image_model.dart';
import 'package:unilink_flutter_app/models/message.dart';
import 'package:unilink_flutter_app/repositories/Impl/MessageRepository.dart';

class MessageViewModel extends ChangeNotifier {
  final MessageRepository _messageRepository = MessageRepository();
  List<Message> messagOfGroup = [];

  Future<void> getGroupMessage(String groupId, int page) async {
    try {
      List<Message> listMessageRes =
          await _messageRepository.getGroupMessage(groupId, page);
      messagOfGroup.addAll(listMessageRes);
      messagOfGroup.sort((a, b) => a.time.compareTo(b.time));
      notifyListeners();
    } on Exception catch (e) {
      debugPrint(e.toString());
    }
  }

  void addMessageToMessageOfGroup(Message message) {
    messagOfGroup.add(message);
    notifyListeners();
  }

  Future<String> sendImage(CreateMessageImage createMessageImage) {
    return _messageRepository.sendImage(createMessageImage);
  }
}
