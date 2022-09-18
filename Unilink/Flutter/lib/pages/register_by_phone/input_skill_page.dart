import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:provider/provider.dart';
import 'package:unilink_flutter_app/constant/path_router.dart';
import 'package:unilink_flutter_app/models/major.dart';
import 'package:unilink_flutter_app/models/skill.dart';
import 'package:unilink_flutter_app/translate/vn.dart';
import 'package:unilink_flutter_app/utils/button.dart';
import 'package:unilink_flutter_app/utils/color.dart';
import 'package:unilink_flutter_app/utils/hex_color.dart';
import 'package:unilink_flutter_app/view_model/major_view_model.dart';
import 'package:unilink_flutter_app/view_model/member_view_model.dart';
import 'package:unilink_flutter_app/view_model/skill_view_model.dart';
import 'package:unilink_flutter_app/widgets/app_bar_child_widget.dart';
import 'package:unilink_flutter_app/widgets/model_list_skill.dart';

class RegisterByPhoneInputSkillPage extends StatefulWidget {
  @override
  _RegisterByPhoneInputSkillState createState() =>
      _RegisterByPhoneInputSkillState();
}

class _RegisterByPhoneInputSkillState
    extends State<RegisterByPhoneInputSkillPage> {
  bool isLoad = true;
  Map<String, SkillViewModel> chooseList = Map();
  List<SkillViewModel> skillList = [];
  List<Major> majorList = [];
  Map<String, List<SkillViewModel>> mapList = Map();
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    List<Major> currentMajor =
        Provider.of<MemberListViewModel>(context, listen: false)
            .insertMember
            .majors;
    majorList = List.from(currentMajor);
    majorList
        .add(Major(id: "0", name: "Khác", description: "Khác", status: true));
    loadInitBase();
  }

  // void convertFollowMajor() {
  //   List<Major> majors = Provider.of<MemberListViewModel>(context, listen: false).insertMember.majors;
  //   List<SkillViewModel> skillList = Provider.of<SkillListViewModel>(context, listen: false).skillList;
  //   skillList.forEach((element) {
  //     String majorId = element.skill.
  //   })
  //   majors.forEach((element) {
  //     List<SkillViewModel> skill = skillList.re
  //   });
  // }
  Future<void> loadInitBase() async {
    Provider.of<SkillListViewModel>(context, listen: false)
        .getAll()
        .then((value) {
      majorList.forEach((element) {
        mapList.addEntries([MapEntry(element.id, [])]);
      });

      List<SkillViewModel> skills =
          Provider.of<SkillListViewModel>(context, listen: false).skillList;
      skills.forEach((element) {
        String majorId = element.skill.majorId.isNotEmpty
            ? element.skill.majorId[0]["id"]
            : "";
        if (mapList.containsKey(majorId)) {
          List<SkillViewModel> skill = mapList[majorId];
          skill.add(element);
          mapList[majorId] = skill;
        } else {
          List<SkillViewModel> skill = mapList["0"];
          skill.add(element);
          mapList["0"] = skill;
        }
      });
      // mapList.forEach((key, value) {
      //   print("Key: ${key}");
      //   print("Value: ${value}");
      // });
      setState(() {
        skillList = skills;
        isLoad = false;
      });
    });
  }

  onRouter(String path) => Navigator.of(context).pushNamed(path);
  Widget _renderSkill(SkillViewModel skill) {
    return Padding(
      padding: const EdgeInsets.only(top: 10.0),
      child: Row(
        key: UniqueKey(),
        children: [
          Padding(
            padding: const EdgeInsets.only(left: 10.0),
            child: ElevatedButton(
              onPressed: () {},
              style: ElevatedButton.styleFrom(
                primary: Colors.white,
                side: BorderSide(
                  width: 0,
                  color: HexColor.fromHex("#d4d4d4"),
                ),
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20.0)),
              ),
              child: Text(
                skill.skill.name,
                style: TextStyle(color: HexColor.fromHex("#000000")),
              ),
            ),
          )
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
          preferredSize: const Size(double.infinity, kToolbarHeight),
          child: AppBarChildWidget(
            path: REGISTER_BY_PHONE_INPUT_SCHOOL_MAJOR_ROUTE,
          )),
      body: isLoad
          ? Center(
              child: CircularProgressIndicator(),
            )
          : SingleChildScrollView(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Padding(
                    padding: EdgeInsets.only(right: 130),
                    child: Center(
                      child: Text(LABEL_ENTER_SKILL,
                          textAlign: TextAlign.center,
                          style: TextStyle(
                              fontSize: 24,
                              color: Colors.black.withOpacity(0.75),
                              fontWeight: FontWeight.w500)),
                    ),
                  ),
                  Column(
                    children: majorList.map((e) {
                      String id = e.id;
                      String name = e.name;
                      return Column(children: [
                        Padding(
                          padding: const EdgeInsets.only(
                              top: 20, left: 60, bottom: 10),
                          child: Row(
                            children: [
                              Text(
                                "* $name:",
                                overflow: TextOverflow.ellipsis,
                                style: TextStyle(
                                    fontWeight: FontWeight.w600, fontSize: 16),
                              )
                            ],
                          ),
                        ),
                        SizedBox(
                          height: 50,
                          width: 50,
                          child: Ink(
                            child: IconButton(
                              color: Colors.white,
                              iconSize: 20,
                              splashRadius: 20,
                              disabledColor: Colors.grey,
                              tooltip: "",
                              icon: Image.asset('assets/icons/flus-icon.png'),
                              onPressed: () {
                                showDialog(
                                    context: context,
                                    builder: (context) {
                                      return ModelListSkill(
                                        skills: mapList[id],
                                        currentList: chooseList,
                                        callback: addSkill,
                                      );
                                    });
                              },
                            ),
                            decoration: ShapeDecoration(
                                color: PrimaryColor, shape: CircleBorder()),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(
                              right: 70, left: 70, top: 15),
                          child: Center(
                            child: TextField(
                              enabled: false,
                              textInputAction: TextInputAction.go,
                              decoration: const InputDecoration(
                                  hintText: LABEL_HINT_SKILL_TEXT),
                            ),
                          ),
                        ),
                        Padding(
                          padding: EdgeInsets.only(left: 45, top: 5, right: 45),
                          child: Container(
                            height: 50,
                            child: ListView(
                              scrollDirection: Axis.horizontal,
                              children: <Widget>[
                                Container(
                                    padding: EdgeInsets.only(right: 0),
                                    child: Row(
                                        children:
                                            convertToMiniSkill(mapList[id]))),
                              ],
                            ),
                          ),
                        ),
                      ]);
                    }).toList(),
                  ),
                  Padding(
                      padding: EdgeInsets.only(top: 19),
                      child: Container(
                        alignment: Alignment.center,
                        height: 44,
                        width: 302,
                        child: ElevatedButton(
                            onPressed: () {
                              if (chooseList.isNotEmpty) {
                                Provider.of<MemberListViewModel>(context,
                                            listen: false)
                                        .insertMember
                                        .skills =
                                    chooseList.values
                                        .map((e) => e.skill)
                                        .toList();
                                // MemberViewModel member =
                                //     Provider.of<MemberListViewModel>(context,
                                //             listen: false)
                                //         .insertMember;
                                // print(member.majors.map((e) => e.id).toList());
                                // print(member.skills.map((e) => e.id).toList());
                                onRouter(REGISTER_BY_PHONE_INPUT_IMAGE_ROUTE);
                                return;
                              }
                              Fluttertoast.showToast(
                                  msg: "Select at least one skill");
                            },
                            style:
                                getStyleElevatedButton(width: 302, height: 44),
                            child: Text(
                              LABEL_BUTTON_NEXT,
                              style: TextStyle(
                                  fontSize: 17, fontWeight: FontWeight.bold),
                            )),
                      ))
                ],
              ),
            ),
    );
  }

  void addSkill(
      Map<String, bool> eventList, Map<String, SkillViewModel> changedList) {
    eventList.forEach((key, value) {
      if (chooseList.containsKey(key)) {
        if (value == false) {
          chooseList.remove(key);
        }
      } else if (value) {
        chooseList[key] = changedList[key];
      }
    });
    setState(() {});
  }

  List<Widget> convertToMiniSkill(List<SkillViewModel> skills) {
    List<Widget> returnList = [];
    skills.forEach((element) {
      String id = element.skill.id;
      if (chooseList.containsKey(id)) {
        returnList.add(_renderSkill(chooseList[id]));
      }
    });
    return returnList;
  }
}
