class District {
  String name;
  int code;
  String division_type;
  String codename;
  int province_code;

  District({
    this.name,
    this.code,
    this.division_type,
    this.codename,
    this.province_code,
  });

  factory District.jsonFrom(Map<String, dynamic> json) {
    return District(
        name: json["name"],
        code: json["code"],
        division_type: json["division_type"],
        codename: json["codename"],
        province_code: json["province_code"]);
  }

  Map<String, dynamic> toMap(District district) {
    Map<String, dynamic> map = Map();
    map["name"] = district.name;
    map["code"] = district.code;
    map["division_type"] = district.division_type;
    map["codename"] = district.codename;
    map["province_code"] = district.province_code;
    return map;
  }

  Map<String, dynamic> toInsertMap(District district) {
    Map<String, dynamic> map = Map();
    map["name"] = district.name;
    map["code"] = district.code;
    map["division_type"] = district.division_type;
    map["codename"] = district.codename;
    map["province_code"] = district.province_code;
    return map;
  }
}
