import 'package:unilink_flutter_app/models/topic_model.dart';
import 'package:unilink_flutter_app/repositories/ITopicRepository.dart';
import 'package:unilink_flutter_app/service/topic_service.dart';

class TopicRepository implements ITopicRepository {
  TopicService service = TopicService();
  @override
  Future<List<Topic>> getAll() {
    return service.getAll();
  }

  Future<List<Topic>> getTopicByParty(String partyId, String pageSize,
      String curPage, String sortBy, String sortType) async {
    try {
      return service.getTopicByParty(
          partyId, pageSize, curPage, sortBy, sortType);
    } catch (e) {
      throw Exception(e.toString());
    }
  }

  @override
  Future createTopic(String title, String description, String partyId) async {
    try {
      return await service.createTopic(title, description, partyId);
    } catch (e) {
      throw Exception(e.toString());
    }
  }

  @override
  Future updateTopic(String title, String description, String topicId) async {
    try {
      return await service.updateTopic(title, description, topicId);
    } catch (e) {
      throw Exception(e.toString());
    }
  }

  @override
  Future deleteTopic(String topicId) async {
    try {
      return await service.deleteTopic(topicId);
    } catch (e) {
      throw Exception(e.toString());
    }
  }
}
