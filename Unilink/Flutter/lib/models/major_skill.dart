import 'package:unilink_flutter_app/models/skill.dart';

class MajorSkill {
  String id;
  String name;
  String description;
  bool status;
  List<Skill> skills;
  MajorSkill({this.id, this.name, this.description, this.status, this.skills});
  factory MajorSkill.jsonFrom(Map<String, dynamic> json) {
    List<Skill> tempSkills = [];
    (json["skills"] as List)
        .forEach((element) => tempSkills.add(Skill.jsonFrom(element)));
    return MajorSkill(
        id: json["id"],
        name: json["name"],
        description: json["description"],
        status: json["status"] == "true",
        skills: tempSkills);
  }
  @override
  bool operator ==(other) {
    return (other is MajorSkill) && id == other.id;
  }

  @override
  int get hashCode => id.hashCode ^ name.hashCode;
}
