class University {
  String id;
  String name;
  String sortName;
  bool status;
  University({this.id, this.name, this.sortName, this.status});
  factory University.jsonFrom(Map<String, dynamic> json) {
    return University(
        id: json["id"],
        name: json["name"],
        sortName: json["sortName"],
        status: json["status"] == "true");
  }
}
