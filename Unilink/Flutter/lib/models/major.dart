class Major {
  String id;
  String name;
  String description;
  bool status;
  Major({this.id, this.name, this.description, this.status});
  factory Major.jsonFrom(Map<String, dynamic> json) {
    return Major(
        id: json["id"],
        name: json["name"],
        description: json["description"],
        status: json["status"] == "true");
  }
  @override
  bool operator ==(other) {
    return (other is Major) && id == other.id;
  }

  @override
  int get hashCode => id.hashCode ^ name.hashCode;
}
