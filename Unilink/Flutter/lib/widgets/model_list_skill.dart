import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:unilink_flutter_app/models/skill.dart';
import 'package:unilink_flutter_app/translate/vn.dart';
import 'package:unilink_flutter_app/utils/button.dart';
import 'package:unilink_flutter_app/view_model/skill_view_model.dart';

class ModelListSkill extends StatefulWidget {
  final Function callback;
  final List<SkillViewModel> skills;
  final Map<String, SkillViewModel> currentList;
  ModelListSkill({Key key, this.skills, this.currentList, this.callback})
      : super(key: key);

  @override
  _ModelListSkillState createState() => _ModelListSkillState();
}

class _ModelListSkillState extends State<ModelListSkill> {
  Function callback;
  List<SkillViewModel> skills;
  Map<String, SkillViewModel> currentList = Map();
  Map<String, SkillViewModel> chooseSkill = Map();
  Map<String, bool> eventList = Map();
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    callback = widget.callback;
    skills = widget.skills;
    currentList = widget.currentList;
    convertToMap();
  }

  void convertToMap() {
    for (int i = 0; i < skills.length; i++) {
      String id = skills[i].skill.id;
      if (currentList.containsKey(id)) {
        chooseSkill[id] = skills[i];
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return SimpleDialog(
      children: [
        Container(
          margin: EdgeInsets.only(left: 250, top: 10),
          width: 20,
          height: 20,
          decoration: BoxDecoration(
            image:
                DecorationImage(image: AssetImage("assets/icons/x-icon.png")),
          ),
          child: InkWell(
            onTap: () {
              Navigator.of(context, rootNavigator: true).pop();
            },
          ),
        ),
        Center(
          child: Text(
            "Danh sách kỹ năng",
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
          ),
        ),
        Container(
            height: 300.0, // Change as per your requirement
            width: 300.0,
            margin: EdgeInsets.all(10),
            child: Column(
              children: [
                Expanded(
                    child: ListView.builder(
                        itemCount: skills.length,
                        // itemCount: skill.length,
                        itemBuilder: (context, i) {
                          final skill = skills[i].skill;
                          return Container(
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(skill.name),
                                Checkbox(
                                  checkColor: Colors.white,
                                  value: chooseSkill.containsKey(skill.id),
                                  onChanged: (bool value) {
                                    setState(() {
                                      eventList[skill.id] = value;
                                      if (value) {
                                        chooseSkill[skill.id] = skills[i];
                                      } else {
                                        chooseSkill.remove(skill.id);
                                      }
                                    });
                                  },
                                )
                              ],
                            ),
                          );
                        }))
              ],
            )),
        Container(
          margin: EdgeInsets.symmetric(horizontal: 20),
          child: Container(
            padding: EdgeInsets.all(20),
            child: Container(
              margin: EdgeInsets.only(bottom: 20),
              child: ElevatedButton(
                child: Container(
                  child: Text(
                    "Lưu",
                    style: TextStyle(fontSize: 20),
                  ),
                ),
                onPressed: () {
                  this.callback(eventList, chooseSkill);
                  Navigator.of(context).pop();
                },
                style: getStyleElevatedButton(
                  width: 90,
                  height: 50,
                ),
              ),
            ),
          ),
        )
      ],
    );
  }
}
