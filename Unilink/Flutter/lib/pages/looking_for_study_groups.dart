import 'package:flutter/material.dart';
import 'package:flutter_spinbox/flutter_spinbox.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:provider/provider.dart';
import 'package:unilink_flutter_app/constant/path_router.dart';
import 'package:unilink_flutter_app/models/district_model.dart';
import 'package:unilink_flutter_app/models/party_model.dart';
import 'package:unilink_flutter_app/translate/vn.dart';
import 'package:unilink_flutter_app/utils/button.dart';
import 'package:unilink_flutter_app/utils/color.dart';
import 'package:unilink_flutter_app/utils/hex_color.dart';
import 'package:unilink_flutter_app/utils/spinner.dart';
import 'package:unilink_flutter_app/view_model/address_view_model.dart';
import 'package:unilink_flutter_app/view_model/group_view_model.dart';
import 'package:unilink_flutter_app/view_model/major_view_model.dart';
import 'package:unilink_flutter_app/view_model/party_view_model.dart';
import 'package:unilink_flutter_app/view_model/skill_view_model.dart';
import 'package:unilink_flutter_app/widgets/app_bar_child_widget.dart';
import 'package:unilink_flutter_app/widgets/model_list_skill.dart';
import 'package:unilink_flutter_app/widgets/page_title_widget.dart';

class LookingForStudyGroup extends StatefulWidget {
  @override
  _LookingForStudyGroupState createState() => _LookingForStudyGroupState();
}

class _LookingForStudyGroupState extends State<LookingForStudyGroup> {
  List<String> skills = ["Java ", ".Net", "C++"];
  String dropdownValueMajor = "";
  List<String> listMajor = [
    "Software Engineer",
    "English Language",
    "Japanese Language"
  ];
  String dropdownValueProvince = "--Tỉnh--";
  String dropdownValueDistrict = "--Quận--";
  // List<String> listProvince = [
  //   "Hồ Chí Minh",
  //   "Hà Nội",
  //   "Cao Bằng",
  //   "Lạng Sơn",
  //   "Sóc Trăng",
  //   "Nha Trang",
  //   "Quảng Bình",
  //   "Bình Định"
  // ];
  Map<String, SkillViewModel> chooseMap = Map();
  List<SkillViewModel> chooseList = [];
  void addSkill(
      Map<String, bool> eventList, Map<String, SkillViewModel> changedList) {
    eventList.forEach((key, value) {
      if (chooseMap.containsKey(key)) {
        if (value == false) {
          chooseMap.remove(key);
        }
      } else if (value) {
        chooseMap[key] = changedList[key];
      }
    });
    setState(() {
      chooseList.clear();
      chooseMap.forEach((key, value) {
        chooseList.add(value);
      });
    });
  }

  String majorId = "";
  int maximum = 1;
  String province = "";
  String district = "";

  List<District> listDistrict = [
    District(
        name: "--Quận--",
        code: -1,
        province_code: -1,
        codename: "--Quận--",
        division_type: "")
  ];

  onRouter(String path) => Navigator.of(context).pushNamed(path);

  Widget _renderSkill(viewmodel) {
    SkillViewModel skillViewModel = viewmodel;
    return Padding(
      padding: const EdgeInsets.only(top: 0),
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
                skillViewModel.skill.name,
                style: TextStyle(color: HexColor.fromHex("#000000")),
              ),
            ),
          )
        ],
      ),
    );
  }

  Future<List<MajorViewModel>> getMajorList() async {
    return await Provider.of<MajorListViewModel>(context, listen: false)
        .majorList;
  }

  Future<List<SkillViewModel>> getSkillList() async {
    return await Provider.of<SkillListViewModel>(context, listen: false)
        .skillList;
  }

  Future<List<ProvinceViewModel>> getProvince() async {
    return await Provider.of<AddressViewModel>(context, listen: false)
        .getAllProvince();
  }

  List<District> initListDistrict() {
    List<District> initList = [];
    initList.add(District(
        name: "--Quận--",
        code: -1,
        province_code: -1,
        codename: "--Quận--",
        division_type: ""));
    return initList;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
          preferredSize: const Size(double.infinity, kToolbarHeight),
          child: AppBarChildWidget(
            indexScreen: 0,
            path: MAIN_ROUTE,
          )),
      body: SingleChildScrollView(
        child: Container(
          color: Colors.white,
          alignment: Alignment.center,
          child: Column(
            children: [
              PageTitleWidget(title: LABEL_ENTER_FIND_GROUP),
              Padding(
                padding: EdgeInsets.only(left: 40, top: 40, right: 40),
                child: Row(
                  children: [
                    Padding(
                      padding: EdgeInsets.only(right: 20),
                      child: Text(
                        LABEL_ENTER_FIND_GROUP_MAJOR,
                        style: TextStyle(
                            fontWeight: FontWeight.bold, fontSize: 18),
                      ),
                    ),
                    Expanded(
                        child: Padding(
                      padding: EdgeInsets.only(top: 0),
                      child: Spinner.spinnerWithFuture(getMajorList(), (data) {
                        List<MajorViewModel> listMajor = data;
                        majorId =
                            majorId.isEmpty ? listMajor[0].major.id : majorId;
                        return DropdownButton<String>(
                          value: dropdownValueMajor = dropdownValueMajor.isEmpty
                              ? listMajor[0].major.name
                              : dropdownValueMajor,
                          iconSize: 0,
                          elevation: 16,
                          style: const TextStyle(color: Colors.black),
                          underline: Container(
                            height: 2,
                            color: Colors.grey,
                          ),
                          onChanged: (String newValue) {
                            setState(() {
                              dropdownValueMajor = newValue;
                            });
                          },
                          items: data.map<DropdownMenuItem<String>>(
                              (MajorViewModel value) {
                            return DropdownMenuItem<String>(
                              value: value.major.name,
                              child: Text(value.major.name),
                              onTap: () {
                                setState(() {
                                  majorId = value.major.id;
                                });
                              },
                            );
                          }).toList(),
                        );
                      }),
                    ))
                  ],
                ),
              ),
              Padding(
                padding: EdgeInsets.only(left: 40, top: 30, right: 40),
                child: Row(
                  children: [
                    Padding(
                      padding: EdgeInsets.only(right: 40, top: 10),
                      child: Text(
                        LABEL_ENTER_FIND_GROUP_SKILL,
                        style: TextStyle(
                            fontWeight: FontWeight.bold, fontSize: 18),
                      ),
                    ),
                    Expanded(
                      child: Container(
                        height: 50,
                        child: ListView(
                          scrollDirection: Axis.horizontal,
                          children: <Widget>[
                            Container(
                              padding: EdgeInsets.only(right: 0),
                              child: Spinner.spinnerWithFuture(getSkillList(),
                                  (data) {
                                return Row(
                                  children: List.generate(
                                      chooseList.length,
                                      (index) =>
                                          _renderSkill(chooseList[index])),
                                );
                              }),
                            )
                          ],
                        ),
                      ),
                    ),
                    Container(
                      margin: EdgeInsets.only(left: 10),
                      height: 40,
                      width: 40,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        border: Border.all(),
                      ),
                      child: Spinner.spinnerWithFuture(getSkillList(), (data) {
                        return Ink(
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
                                      skills: data,
                                      currentList: chooseMap,
                                      callback: addSkill,
                                    );
                                  });
                            },
                          ),
                        );
                      }),
                    )
                  ],
                ),
              ),
              Padding(
                padding: EdgeInsets.only(top: 50, right: 40, left: 20),
                child: Column(
                  children: [
                    Padding(
                      padding: EdgeInsets.only(right: 150),
                      child: Text(
                        LABEL_ENTER_FIND_GROUP_NUM_MEMBER,
                        style: TextStyle(
                            fontWeight: FontWeight.bold, fontSize: 18),
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.only(top: 0),
                      child: Padding(
                        padding: EdgeInsets.only(left: 40, top: 10, right: 10),
                        child: Row(
                          children: [
                            Padding(
                              padding: EdgeInsets.only(right: 20),
                              child: Text(
                                LABEL_ENTER_FIND_GROUP_NUM_MEMBER_INPUT,
                                style: TextStyle(
                                    fontWeight: FontWeight.normal,
                                    fontSize: 18),
                              ),
                            ),
                            Expanded(
                                child: Padding(
                                    padding: EdgeInsets.only(right: 0),
                                    child: SpinBox(
                                      min: 1,
                                      max: 10,
                                      value: 1,
                                      onChanged: (value) =>
                                          maximum = value.toInt(),
                                    )))
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              Padding(
                padding: EdgeInsets.only(top: 50, right: 40, left: 20),
                child: Column(
                  children: [
                    Padding(
                      padding: EdgeInsets.only(right: 240),
                      child: Text(
                        LABEL_ENTER_FIND_GROUP_AREA,
                        style: TextStyle(
                            fontWeight: FontWeight.bold, fontSize: 18),
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.only(left: 40, top: 10),
                      child: Row(
                        children: [
                          Padding(
                            padding: EdgeInsets.only(top: 10, right: 20),
                            child: Text(
                              LABEL_ENTER_FIND_GROUP_CITY,
                              style: TextStyle(
                                  fontWeight: FontWeight.normal, fontSize: 15),
                            ),
                          ),
                          Expanded(
                            child: Padding(
                              padding: EdgeInsets.only(top: 0),
                              child: Spinner.spinnerWithFuture(getProvince(),
                                  (data) {
                                return DropdownButton<String>(
                                  value: dropdownValueProvince,
                                  iconSize: 0,
                                  elevation: 16,
                                  style: const TextStyle(color: Colors.black),
                                  underline: Container(
                                    height: 2,
                                    color: Colors.grey,
                                  ),
                                  onChanged: (String newValue) {
                                    setState(() {
                                      dropdownValueProvince = newValue;
                                      province = newValue;
                                      dropdownValueDistrict = "--Quận--";
                                    });
                                  },
                                  items: data.map<DropdownMenuItem<String>>(
                                      (ProvinceViewModel value) {
                                    return DropdownMenuItem<String>(
                                      value: value.province.name,
                                      child: Text(value.province.name),
                                      onTap: () {
                                        setState(() {
                                          if (value.province.code > 0) {
                                            listDistrict =
                                                value.province.districts;
                                            province = value.province.name;
                                          } else {
                                            listDistrict = initListDistrict();
                                          }
                                        });
                                      },
                                    );
                                  }).toList(),
                                );
                              }),
                            ),
                          )
                        ],
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.only(left: 40, top: 10),
                      child: Row(
                        children: [
                          Padding(
                            padding: EdgeInsets.only(top: 10, right: 40),
                            child: Text(
                              LABEL_ENTER_FIND_GROUP_DISTRICT,
                              style: TextStyle(
                                  fontWeight: FontWeight.normal, fontSize: 15),
                            ),
                          ),
                          Expanded(
                            child: Padding(
                                padding: EdgeInsets.only(top: 0),
                                child: DropdownButton<String>(
                                  value: dropdownValueDistrict,
                                  iconSize: 0,
                                  elevation: 16,
                                  style: const TextStyle(color: Colors.black),
                                  underline: Container(
                                    height: 2,
                                    color: Colors.grey,
                                  ),
                                  onChanged: (String newValue) {
                                    setState(() {
                                      dropdownValueDistrict = newValue;
                                      district = newValue;
                                    });
                                  },
                                  items: listDistrict
                                      .map<DropdownMenuItem<String>>(
                                          (District value) {
                                    return DropdownMenuItem<String>(
                                      value: value.name,
                                      child: Text(value.name),
                                    );
                                  }).toList(),
                                )),
                          )
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              Padding(
                  padding: EdgeInsets.only(top: 40),
                  child: Container(
                    alignment: Alignment.center,
                    height: 44,
                    width: 302,
                    child: ElevatedButton(
                        onPressed: () async {
                          List<String> skillList = [];
                          chooseMap.forEach((key, value) {
                            skillList.add(value.skill.id);
                          });
                          String address = province + "-" + district;
                          if (address.contains("--Tỉnh--")) {
                            address = "-";
                          } else if (address.contains("--Quận--")) {
                            address = province;
                          }

                          await Provider.of<PartyListViewModel>(context,
                                  listen: false)
                              .findParties(
                                  majorId, skillList, maximum, address, true);
                          Navigator.of(context)
                              .pushNamed(SUITABLE_GROUPS_ROUTE);
                          // Fluttertoast.showToast(
                          //   msg: TOAST_FIND_GROUP,
                          //   toastLength: Toast.LENGTH_LONG,
                          // );
                        },
                        style: getStyleElevatedButton(width: 302, height: 44),
                        child: Text(
                          LABEL_BUTTON_FIND,
                          style: TextStyle(
                              fontSize: 17, fontWeight: FontWeight.bold),
                        )),
                  ))
            ],
          ),
        ),
      ),
    );
  }
}
