import 'package:unilink_flutter_app/models/major.dart';

class Skill {
  String id;
  String name;
  List<dynamic> majorId;
  String description;
  bool status;
  Skill({this.id, this.name, this.description, this.majorId, this.status});
  factory Skill.jsonFrom(Map<String, dynamic> json) {
    return Skill(
        id: json["id"],
        name: json["name"],
        description: json["description"],
        majorId: json["majors"],
        status: json["status"] == "true");
  }
}
