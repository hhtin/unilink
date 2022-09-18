import 'package:unilink_flutter_app/models/topic_model.dart';
import 'package:unilink_flutter_app/repositories/GenericRepository.dart';

abstract class ITopicRepository extends GenericRepository<Topic> {
  Future<dynamic> getTopicByParty(String partyId, String pageSize,
      String curPage, String sortBy, String sortType);
  Future<dynamic> createTopic(String title, String description, String partyId);
  Future<dynamic> updateTopic(String title, String description, String topicId);
  Future<dynamic> deleteTopic(String topicId);
}
