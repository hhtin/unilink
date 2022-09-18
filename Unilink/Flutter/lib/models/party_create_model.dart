class PartyCreate {
  String name;
  String id;
  String description;
  String image;
  int maximum;
  String majorId;
  bool isApprovedPost;
  String address;
  List<String> skill;
  PartyCreate({
    this.name,
    this.description,
    this.image,
    this.maximum,
    this.majorId,
    this.isApprovedPost,
    this.id,
  });
  Map<String, dynamic> toInsertMap(PartyCreate party) {
    Map<String, dynamic> map = Map();
    map["Name"] = party.name;
    map["Description"] = party.description;
    map["Image"] = party.image;
    map["Maximum"] = party.maximum;
    map["MajorId"] = party.majorId;
    map["IsApprovedPost"] = party.isApprovedPost;
    map["Skills"] = party.skill;
    map["Address"] = party.address;
    map["Id"] = party.id;
    return map;
  }
}
