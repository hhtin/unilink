class Post {
  String id;
  String title;
  String content;
  DateTime createDate;
  DateTime updateDate;
  String topicId;
  String createBy;
  int status;
  Post({
    this.id,
    this.title,
    this.content,
    this.createDate,
    this.updateDate,
    this.topicId,
    this.createBy,
    this.status,
  });
  factory Post.jsonFrom(Map<String, dynamic> json) {
    return Post(
      id: json["id"],
      title: json["title"],
      content: json["content"],
      createDate: DateTime.tryParse(json["createDate"]),
      updateDate: DateTime.tryParse(json["updateDate"]),
      topicId: json["topicId"],
      createBy: json["createBy"],
      status: json["status"],
    );
  }

  Map<String, dynamic> toMap(Post post) {
    Map<String, dynamic> map = Map();
    map["id"] = post.id;
    map["title"] = post.title;
    map["content"] = post.content;
    map["createDate"] = post.createDate.toLocal();
    map["updateDate"] = post.updateDate.toLocal();
    map["topicId"] = post.topicId;
    map["createBy"] = post.createBy;
    map["status"] = post.status;
    return map;
  }

  Map<String, dynamic> toInsertMap(Post post) {
    Map<String, dynamic> map = Map();
    map["title"] = post.title;
    map["content"] = post.content;
    map["topicId"] = post.topicId;
    map["createBy"] = post.createBy;
    return map;
  }
}
