import 'package:unilink_flutter_app/models/major.dart';
import 'package:unilink_flutter_app/models/skill.dart';

class Party {
  String id;
  String name;
  String description;
  String image;
  int maximum;
  DateTime createDate;
  String majorId;
  bool isApprovedPost;
  bool status;
  String address;
  int currentMember;
  List<Skill> skills;
  Major major;
  Party(
      {this.id,
      this.name,
      this.description,
      this.image,
      this.maximum,
      this.createDate,
      this.majorId,
      this.isApprovedPost,
      this.status,
      this.address,
      this.major,
      this.skills,
      this.currentMember});
  factory Party.jsonFrom(Map<String, dynamic> json) {
    Major majorTemp = Major.jsonFrom(json["major"]);
    List<Skill> skillTemps = [];
    json["skills"].forEach((e) => skillTemps.add(Skill.jsonFrom(e)));
    return Party(
        id: json["id"],
        name: json["name"],
        description: json["description"],
        image: json["image"],
        maximum: json["maximum"],
        createDate: DateTime.tryParse(json["createDate"]),
        majorId: json["majorId"],
        isApprovedPost: json["isApprovedPost"],
        status: json["status"],
        currentMember: json["currentMember"],
        major: majorTemp,
        skills: skillTemps,
        address: json["address"]);
  }
  Map<String, dynamic> toMap(Party party) {
    Map<String, dynamic> map = Map();
    map["id"] = party.id;
    map["name"] = party.name;
    map["description"] = party.description;
    map["image"] = party.image;
    map["maximum"] = party.maximum;
    map["createDate"] = party.createDate.toLocal();
    map["majorId"] = party.majorId;
    map["isApprovedPost"] = party.isApprovedPost;
    map["status"] = party.status;
    return map;
  }

  Map<String, dynamic> toInsertMap(Party party) {
    Map<String, dynamic> map = Map();
    map["name"] = party.name;
    map["description"] = party.description;
    map["image"] = party.image;
    map["maximum"] = party.maximum;
    map["majorId"] = party.majorId;
    map["isApprovedPost"] = party.isApprovedPost;
    return map;
  }
}
