import 'package:unilink_flutter_app/models/district_model.dart';

class Province {
  String name;
  int code;
  String division_type;
  String codename;
  int phone_code;
  List<District> districts;

  Province({
    this.name,
    this.code,
    this.division_type,
    this.codename,
    this.phone_code,
    this.districts,
  });

  factory Province.jsonFrom(Map<String, dynamic> json) {
    List<District> list = [
      District(
          name: "--Quận--",
          code: -1,
          division_type: "",
          codename: "--Quận--",
          province_code: -1)
    ];
    (json["districts"] as List)
        .forEach((element) => list.add(District.jsonFrom(element)));
    return Province(
      name: json["name"],
      code: json["code"],
      division_type: json["division_type"],
      codename: json["codename"],
      phone_code: json["phone_code"],
      districts: list,
    );
  }

  // Map<String, dynamic> toMap(Province province) {
  //   Map<String, dynamic> map = Map();
  //   map["name"] = province.name;
  //   map["code"] = province.code;
  //   map["division_type"] = province.division_type;
  //   map["codename"] = province.codename;
  //   map["phone_code"] = province.phone_code;
  //   return map;
  // }

  // Map<String, dynamic> toInsertMap(Province province) {
  //   Map<String, dynamic> map = Map();
  //   map["name"] = province.name;
  //   map["code"] = province.code;
  //   map["division_type"] = province.division_type;
  //   map["codename"] = province.codename;
  //   map["phone_code"] = province.phone_code;
  //   return map;
  // }
}
