import 'package:flutter/foundation.dart';
import 'package:unilink_flutter_app/models/notify.dart';

class NotifyViewModel extends ChangeNotifier {
  List<Notify> notis = [
    new Notify(
        "1",
        "Group PRM",
        "Bạn đã được chấp nhận tham gia vào nhóm Group PRM",
        false,
        "8:30 12/10/2021"),
    new Notify(
        "2",
        "Group HCI",
        "Bạn đã được chấp nhận tham gia vào nhóm Group HCI",
        false,
        "11:20 13/10/2021"),
    new Notify(
        "3",
        "Photoshop Learner",
        "Bạn đã được chấp nhận tham gia vào nhóm Photoshop Learner",
        true,
        "11:21 6/10/2021"),
    new Notify(
        "4",
        "Docker của Long",
        "Bạn đã được chấp nhận tham gia vào nhóm Docker của Long",
        true,
        "18:20 7/10/2021"),
    new Notify(
        "5",
        "Group Mongo",
        "Bạn đã được chấp nhận tham gia vào nhóm Group Mongo",
        false,
        "8:17 28/4/2021"),
    new Notify(
        "5",
        "Group Tester",
        "Bạn đã được chấp nhận tham gia vào nhóm Group Tester",
        false,
        "6:12 21/3/2021"),
    new Notify(
        "5",
        "Group NodeJS",
        "Bạn đã được chấp nhận tham gia vào nhóm Group NodeJS",
        false,
        "5:14 1/5/2021"),
    new Notify(
        "5",
        "Group Docker",
        "Bạn đã được chấp nhận tham gia vào nhóm Group Docker",
        false,
        "7:21 13/9/2021"),
    new Notify(
        "5",
        "Group SpringBoot",
        "Bạn đã được chấp nhận tham gia vào nhóm Group SpringBoot",
        false,
        "14:27 17/8/2021"),
    new Notify(
        "5",
        "Group HCI",
        "Bạn đã được chấp nhận tham gia vào nhóm Group HCI",
        false,
        "16:29 14/10/2021"),
  ];
}
