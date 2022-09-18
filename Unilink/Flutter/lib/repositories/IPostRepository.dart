import 'package:unilink_flutter_app/models/post_model.dart';
import 'package:unilink_flutter_app/repositories/GenericRepository.dart';

abstract class IPostRepository extends GenericRepository<Post> {
  Future<dynamic> getInfoPost(String id);

  Future<dynamic> searchPost(String topic, String searchText, String pageSize,
      String curPage, String sortBy, String sortType);

  Future<dynamic> createPost(
      String title, String content, String topicId, String createBy);

  Future<dynamic> updatePost(String topicId, String title, String content);

  Future<dynamic> removePost(String postId);
}
