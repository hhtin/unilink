import 'package:flutter/foundation.dart';
import 'package:unilink_flutter_app/models/group.dart';

class GroupViewModel extends ChangeNotifier {
  String currentGroupId = null;
  final List<Group> groupNearYou = [
    new Group(
        "Unilink", "Java, Spring boot, Spring MVC", "4/5", "Cách 8km", false),
    new Group("Long Vân", "C# Dotnet", "4/5", "Cách 1km", true),
    new Group("Phong Vũ", "Flutter", "2/5", "Cách 2km", false),
    new Group("HCI FPT", "HCI", "2/5", "Cách 5km", true),
    new Group("SWD FPT", "Flutter C#", "2/5", "Cách 6km", true),
    new Group("PRM FPT", "Flutter C#", "2/5", "Cách 6km", false),
  ];
  final List<String> members = [
    'assets/icons/avatar-long.jpg',
    'assets/icons/avatar-tuan.jpg',
    'assets/icons/avatar-tin.jpg',
  ];
}
