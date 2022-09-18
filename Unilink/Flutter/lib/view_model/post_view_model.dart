import 'package:flutter/foundation.dart';
import 'package:unilink_flutter_app/models/member_model.dart';
import 'package:unilink_flutter_app/models/post_model.dart';
import 'package:unilink_flutter_app/repositories/Impl/MemberRepository.dart';
import 'package:unilink_flutter_app/repositories/Impl/PostRepository.dart';
import 'package:unilink_flutter_app/view_model/member_view_model.dart';

class PostListViewModel extends ChangeNotifier {
  final PostRepository _postRepository = PostRepository();
  final MemberRepository _memberRepository = MemberRepository();
  PostViewModel postInfo;
  List<PostViewModel> postList = [];
  String updateId = "";
  String topicId = "";
  String postName, description = "";

  Future<dynamic> setUpdateId(String updateId) {
    this.updateId = updateId;
  }

  Future<dynamic> setTopicId(String topicId) {
    this.topicId = topicId;
  }

  Future<List<PostViewModel>> searchPost(String searchText, String pageSize,
      String curPage, String sortBy, String sortType) async {
    try {
      List<Post> posts = await _postRepository.searchPost(
          topicId, searchText, pageSize, curPage, sortBy, sortType);
      postList.clear();
      posts.forEach((element) => postList.add(PostViewModel(element)));
      for (int i = 0; i < postList.length; i++) {
        var data =
            await _memberRepository.getInfoMember(postList[i].post.createBy);
        Member member = Member.jsonFrom(data);
        postList[i].member = member;
        if (postList[i].member.avatar == null ||
            postList[i].member.avatar.isEmpty) {
          postList[i].member.avatar = "assets/icons/avatar-vinh.jpg";
        }
      }
      notifyListeners();
      return postList;
    } catch (e) {
      debugPrint(e.toString());
    }
  }

  Future<dynamic> getPostInfo(String id) async {
    try {
      var data = await _postRepository.getInfoPost(id);
      Post post = Post.jsonFrom(data);
      postInfo = new PostViewModel(post);
      notifyListeners();
    } catch (e) {
      debugPrint(e.toString());
    }
  }

  Future<dynamic> createPost(String title, String content) async {
    try {
      if (title == null || title.isEmpty) {
        title = "";
      }
      if (content == null || content.isEmpty) {
        content = "";
      } else {
        content = content.split("⟨")[1];
        content = content.substring(0, content.lastIndexOf("⟩"));
      }
      String createBy = "";
      MemberListViewModel memberListViewModel = MemberListViewModel();
      createBy = await memberListViewModel.getIdentifier();
      var data =
          await _postRepository.createPost(title, content, topicId, createBy);

      notifyListeners();
    } catch (e) {
      debugPrint(e.toString());
    }
  }

  Future<dynamic> updatePost(String title, String content) async {
    try {
      if (title == null || title.isEmpty) {
        title = "";
      }
      if (content == null || content.isEmpty) {
        content = "";
      } else {
        content = content.split("⟨")[1];
        content = content.substring(0, content.lastIndexOf("⟩"));
      }
      var data = await _postRepository.updatePost(title, content, updateId);
      notifyListeners();
    } catch (e) {
      debugPrint(e.toString());
    }
  }

  Future<dynamic> removePost(String postId) async {
    try {
      await _postRepository.removePost(postId);
      notifyListeners();
    } catch (e) {
      debugPrint(e.toString());
    }
  }
}

class PostViewModel {
  Post post;
  Member member;
  PostViewModel(this.post);
}
