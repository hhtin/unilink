import 'package:flutter/foundation.dart';
import 'package:unilink_flutter_app/models/topic_model.dart';
import 'package:unilink_flutter_app/repositories/Impl/TopicRepository.dart';

class TopicListViewModel extends ChangeNotifier {
  final TopicRepository _topicsRepository = TopicRepository();
  String topicName, description, topicId = "";
  List<TopicViewModel> topicList = [];
  Future<void> getAll() async {
    try {
      List<Topic> topics = await _topicsRepository.getAll();
      topicList.clear();
      topics.forEach((element) => topicList.add(TopicViewModel(element)));
      notifyListeners();
    } catch (e) {
      debugPrint(e.toString());
    }
  }

  Future<List<TopicViewModel>> getTopicByParty(String partyId, String pageSize,
      String curPage, String sortBy, String sortType) async {
    try {
      List<Topic> topics = await _topicsRepository.getTopicByParty(
          partyId, pageSize, curPage, sortBy, sortType);
      topicList.clear();
      topics.forEach((element) => topicList.add(TopicViewModel(element)));
      notifyListeners();
      return topicList;
    } catch (e) {
      debugPrint(e.toString());
    }
  }

  Future<dynamic> createTopic(
      String title, String description, String partyId) async {
    try {
      if (title == null || title.isEmpty) {
        title = "";
      }
      if (description == null || description.isEmpty) {
        description = "";
      } else {
        // content = content.split("⟨")[1];
        // content = content.substring(0, content.lastIndexOf("⟩"));
      }

      var data =
          await _topicsRepository.createTopic(title, description, partyId);

      notifyListeners();
    } catch (e) {
      debugPrint(e.toString());
    }
  }

  Future<dynamic> updateTopic(
      String title, String description, String topicId) async {
    try {
      if (title == null || title.isEmpty) {
        title = "";
      }
      if (description == null || description.isEmpty) {
        description = "";
      } else {
        // content = content.split("⟨")[1];
        // content = content.substring(0, content.lastIndexOf("⟩"));
      }
      var data =
          await _topicsRepository.updateTopic(title, description, topicId);
      notifyListeners();
    } catch (e) {
      debugPrint(e.toString());
    }
  }

  Future<dynamic> deleteTopic(String topicId) async {
    try {
      var data = await _topicsRepository.deleteTopic(topicId);
      notifyListeners();
    } catch (e) {
      throw Exception(e.toString());
    }
  }
}

class TopicViewModel {
  final Topic topic;
  TopicViewModel(this.topic);
}
