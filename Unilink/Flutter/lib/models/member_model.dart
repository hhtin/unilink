class Member {
  String id;
  String phone;
  String email;
  String firstName;
  String lastName;
  DateTime dob;
  int gender;
  String address;
  String description;
  String avatar;
  bool isOnline;
  String roleId;
  String universityId;
  bool status;

  Member({
    this.id,
    this.phone = "",
    this.email,
    this.firstName = "",
    this.lastName = "",
    this.dob,
    this.gender,
    this.address,
    this.description = "",
    this.avatar,
    this.isOnline,
    this.roleId,
    this.universityId,
    this.status,
  });

  factory Member.jsonFrom(Map<String, dynamic> json) {
    return Member(
        id: json["id"],
        phone: json["phone"],
        email: json["email"],
        firstName: json["firstName"],
        lastName: json["lastName"],
        dob: DateTime.tryParse(json["dob"]),
        gender: json["gender"],
        address: json["address"],
        description: json["description"],
        avatar: json["avatar"],
        isOnline: json["isOnline"] as bool,
        roleId: json["roleId"],
        status: json["status"] as bool,
        universityId: json["universityId"]);
  }

  Map<String, dynamic> toMap(Member member) {
    Map<String, dynamic> map = Map();
    map["id"] = member.id;
    map["phone"] = member.phone;
    map["email"] = member.email;
    map["firstName"] = member.firstName;
    map["lastName"] = member.lastName;
    map["dob"] = member.dob.toLocal();
    map["gender"] = member.gender;
    map["address"] = member.address;
    map["description"] = member.description;
    map["avatar"] = member.avatar;
    map["isOnline"] = member.isOnline;
    map["roleId"] = member.roleId;
    map["status"] = member.status;
    map["universityId"] = member.universityId;
    return map;
  }

  Map<String, dynamic> toUpdateMap(Member member) {
    Map<String, dynamic> map = Map();
    map["id"] = member.id;
    map["phone"] = member.phone;
    map["email"] = member.email;
    map["firstName"] = member.firstName;
    map["lastName"] = member.lastName;
    map["dob"] = member.dob.toLocal().toString();
    map["gender"] = member.gender.toString();
    map["address"] = member.address;
    map["description"] = member.description;
    return map;
  }

  Map<String, dynamic> toInsertMap(Member member) {
    Map<String, dynamic> map = Map();
    map["phone"] = "0123456789";
    map["email"] = member.email;
    map["firstName"] = member.firstName;
    map["lastName"] = member.lastName;
    map["dob"] = member.dob.toLocal().toString();
    map["gender"] = member.gender;
    map["address"] = member.address;
    map["description"] = "Tăng trình độ bằng việc học nhóm";
    map["roleId"] = "38a28d0c-4ba0-490f-88af-681eda644932";
    map["universityId"] = member.universityId;
    return map;
  }
}
