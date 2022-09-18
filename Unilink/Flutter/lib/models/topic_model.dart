class Topic {
  String id;
  String title;
  String description;
  DateTime createDate;
  DateTime updateDate;
  String partyId;
  String attachedPost;
  bool status;

  Topic(
      {this.id,
      this.title,
      this.description,
      this.createDate,
      this.updateDate,
      this.partyId,
      this.attachedPost,
      this.status});

  factory Topic.jsonFrom(Map<String, dynamic> json) {
    return Topic(
        id: json["id"],
        title: json["title"],
        description: json["description"],
        createDate: DateTime.tryParse(json["createDate"]),
        updateDate: DateTime.tryParse(json["updateDate"]),
        partyId: json["partyId"],
        attachedPost: json["attachedPost"],
        status: json["status"] as bool);
  }

  Map<String, dynamic> toMap(Topic topic) {
    Map<String, dynamic> map = Map();
    map["id"] = topic.id;
    map["title"] = topic.title;
    map["description"] = topic.description;
    map["createDate"] = topic.createDate.toLocal();
    map["updateDate"] = topic.updateDate.toLocal();
    map["partyId"] = topic.partyId;
    map["attachedPost"] = topic.attachedPost;
    map["status"] = topic.status;

    return map;
  }

  Map<String, dynamic> toInsertMap(Topic topic) {
    Map<String, dynamic> map = Map();
    map["title"] = topic.title;
    map["description"] = topic.description;
    return map;
  }
}
