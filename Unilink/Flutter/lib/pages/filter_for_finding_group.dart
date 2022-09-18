import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:group_radio_button/group_radio_button.dart';
import 'package:provider/provider.dart';
import 'package:unilink_flutter_app/constant/path_router.dart';
import 'package:unilink_flutter_app/models/district_model.dart';
import 'package:unilink_flutter_app/models/major.dart';
import 'package:unilink_flutter_app/models/party_model.dart';
import 'package:unilink_flutter_app/translate/vn.dart';
import 'package:unilink_flutter_app/utils/button.dart';
import 'package:unilink_flutter_app/utils/hex_color.dart';
import 'package:unilink_flutter_app/utils/spinner.dart';
import 'package:unilink_flutter_app/view_model/address_view_model.dart';
import 'package:unilink_flutter_app/view_model/group_view_model.dart';
import 'package:unilink_flutter_app/view_model/major_view_model.dart';
import 'package:unilink_flutter_app/view_model/member_view_model.dart';
import 'package:unilink_flutter_app/view_model/party_view_model.dart';
import 'package:unilink_flutter_app/view_model/skill_view_model.dart';
import 'package:unilink_flutter_app/widgets/app_bar_child_widget.dart';
import 'package:unilink_flutter_app/widgets/model_list_skill.dart';

class FilterForFindingGroup extends StatefulWidget {
  @override
  _FilterForFindingGroupState createState() => _FilterForFindingGroupState();
}

class _FilterForFindingGroupState extends State<FilterForFindingGroup> {
  TextEditingController _firstAgeController = new TextEditingController();
  TextEditingController _lastAgeController = new TextEditingController();
  onRouter(String path) => Navigator.of(context).pushNamed(path);
  String majorId = "254e4d17-2b8d-4746-97eb-e8f1ca8a6335";
  String province = "";
  String district = "";
  String groupId = "";
  bool firstLoad = false;
  final List<String> skills = ["Java ", ".Net"];
  String dropdownValueMajor = "IT";
  String dropdownValueProvince = "--Tỉnh--";
  String dropdownValueDistrict = "--Quận--";
  List<District> listDistrict = [
    District(
        name: "--Quận--",
        code: -1,
        province_code: -1,
        codename: "--Quận--",
        division_type: "")
  ];

  String dropdownValueGentle = "Nam";
  List<String> listGentle = ["Nam", "Nữ", "Khác"];

  String dropdownValueGroup = "--Nhóm--";
  List<PartyViewModel> listParty = [];
  List<String> listGroup = ['Flutter', 'C++', 'C#'];
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

  Widget _renderSkill(viewModel) {
    SkillViewModel skillViewModel = viewModel;
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
                skillViewModel.skill.name,
                style: TextStyle(color: HexColor.fromHex("#000000")),
                overflow: TextOverflow.ellipsis,
              ),
            ),
          )
        ],
      ),
    );
  }

  @override
  void initState() {
    super.initState();
  }

  Future<List<SkillViewModel>> getSkillList() async {
    return await Provider.of<SkillListViewModel>(context, listen: false)
        .skillList;
  }

  Future<List<MajorViewModel>> getMajorList() async {
    List<MajorViewModel> listMajor =
        Provider.of<MajorListViewModel>(context, listen: false).majorList;
    return listMajor;
  }

  Future<List<PartyViewModel>> getGroupList() async {
    String currentMemberId =
        Provider.of<MemberListViewModel>(context, listen: false).identifier;
    List<PartyViewModel> listGroup =
        await Provider.of<PartyListViewModel>(context, listen: false)
            .getPartyByMemberId(currentMemberId);
    Party party = new Party(id: "", name: "--Nhóm--");
    listGroup.add(PartyViewModel(party));
    return listGroup;
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
      body: SingleChildScrollView(
        child: Container(
          color: Colors.white,
          alignment: Alignment.topLeft,
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.only(right: 50, left: 50, bottom: 15),
                child: Center(
                  child: Text(
                    LABEL_ENTER_FIND_MEMBER,
                    style: TextStyle(
                        fontSize: 24,
                        color: Colors.black.withOpacity(0.75),
                        fontWeight: FontWeight.w500),
                  ),
                ),
              ),
              Padding(
                padding: EdgeInsets.only(left: 40, top: 40, right: 40),
                child: Row(children: [
                  Padding(
                    padding: EdgeInsets.only(right: 20),
                    child: Text(
                      LABEL_ENTER_FIND_GROUP_MAJOR,
                      style:
                          TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
                    ),
                  ),
                  Expanded(
                      child: Padding(
                    padding: EdgeInsets.only(top: 0),
                    child: Spinner.spinnerWithFuture(getMajorList(), (data) {
                      return DropdownButton<String>(
                        value: dropdownValueMajor,
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
                        hint: Container(
                          child: Text("a"),
                        ),
                      );
                    }),
                  )),
                ]),
              ),
              Padding(
                padding: EdgeInsets.only(left: 40, top: 20, right: 40),
                child: Row(
                  children: [
                    Padding(
                      padding: EdgeInsets.only(right: 40, top: 10),
                      child: Text(
                        LABEL_GENDER_TYPE,
                        style: TextStyle(
                            fontWeight: FontWeight.bold, fontSize: 18),
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.only(top: 10),
                      child: Container(
                        padding: EdgeInsets.only(top: 0),
                        child: DropdownButton<String>(
                          value: dropdownValueGentle,
                          iconSize: 0,
                          elevation: 16,
                          style: const TextStyle(color: Colors.black),
                          underline: Container(
                            height: 2,
                            color: Colors.grey,
                          ),
                          onChanged: (String newValue) {
                            setState(() {
                              dropdownValueGentle = newValue;
                            });
                          },
                          items: listGentle
                              .map<DropdownMenuItem<String>>((String value) {
                            return DropdownMenuItem<String>(
                              value: value,
                              child: Text(value),
                            );
                          }).toList(),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              Padding(
                padding: EdgeInsets.only(left: 40, top: 20, right: 40),
                child: Row(
                  children: [
                    Padding(
                      padding: EdgeInsets.only(right: 40, top: 10),
                      child: Text(
                        LABEL_AGE,
                        style: TextStyle(
                            fontWeight: FontWeight.bold, fontSize: 18),
                      ),
                    ),
                    Expanded(
                      child: Padding(
                        padding: EdgeInsets.only(top: 0, right: 10, left: 20),
                        child: TextField(
                          controller: _firstAgeController,
                          textInputAction: TextInputAction.go,
                        ),
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.only(top: 10),
                      child: Text(
                        '-',
                        style: TextStyle(
                            fontWeight: FontWeight.bold, fontSize: 18),
                      ),
                    ),
                    Expanded(
                      child: Padding(
                        padding: EdgeInsets.only(top: 0, left: 10, right: 20),
                        child: TextField(
                          controller: _lastAgeController,
                          textInputAction: TextInputAction.go,
                        ),
                      ),
                    )
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
                padding: EdgeInsets.only(top: 50, right: 40),
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
                padding: EdgeInsets.only(left: 40, top: 40, right: 40),
                child: Row(
                  children: [
                    Padding(
                      padding: EdgeInsets.only(right: 40),
                      child: Text(
                        LABEL_ENTER_FIND_MEMBER_CHOOSE_GROUP,
                        style: TextStyle(
                            fontWeight: FontWeight.bold, fontSize: 18),
                      ),
                    ),
                    Expanded(
                        child: Padding(
                      padding: EdgeInsets.only(top: 0),
                      child: Spinner.spinnerWithFuture(getGroupList(), (data) {
                        return DropdownButton<String>(
                          value: dropdownValueGroup,
                          iconSize: 0,
                          elevation: 16,
                          style: const TextStyle(color: Colors.black),
                          underline: Container(
                            height: 2,
                            color: Colors.grey,
                          ),
                          onChanged: (String newValue) {
                            setState(() {
                              dropdownValueGroup = newValue;
                            });
                          },
                          items: data.map<DropdownMenuItem<String>>(
                              (PartyViewModel value) {
                            return DropdownMenuItem<String>(
                              value: value.party.name,
                              child: Text(value.party.name),
                              onTap: () {
                                setState(() {
                                  groupId = value.party.id;
                                });
                              },
                            );
                          }).toList(),
                        );
                      }),
                    )),
                  ],
                ),
              ),
              Padding(
                  padding: EdgeInsets.only(top: 40, bottom: 20),
                  child: Container(
                    alignment: Alignment.center,
                    height: 44,
                    width: 302,
                    child: ElevatedButton(
                        onPressed: () {
                          List<String> skillList = [];
                          chooseMap.forEach((key, value) {
                            skillList.add(value.skill.id);
                          });
                          if (groupId == null ||
                              groupId.isEmpty ||
                              groupId == "") {
                            Fluttertoast.showToast(
                              msg: TOAST_INPUT_NOT_FINISH,
                              toastLength: Toast.LENGTH_LONG,
                            );
                          } else {
                            if (province != null ||
                                district != null ||
                                province.isNotEmpty ||
                                district.isNotEmpty) {
                              province = province + "-" + district;
                            }
                            Provider.of<MemberListViewModel>(context,
                                    listen: false)
                                .setFilterMember(
                                    majorId,
                                    dropdownValueGentle,
                                    _firstAgeController.text,
                                    _lastAgeController.text,
                                    skillList,
                                    province);
                            Provider.of<MemberListViewModel>(context,
                                    listen: false)
                                .partyId = groupId;
                            Navigator.of(context).pushNamed(MEMBER_CARD_ROUTE);
                            Fluttertoast.showToast(
                              msg: TOAST_FIND_MEMBERS,
                              toastLength: Toast.LENGTH_LONG,
                            );
                          }
                        },
                        style: getStyleElevatedButton(
                            width: 302,
                            height: 44,
                            type: ButtonType.SUCCESS,
                            elevation: 2.0),
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
      appBar: PreferredSize(
          preferredSize: const Size(double.infinity, kToolbarHeight),
          child: AppBarChildWidget(
            path: MAIN_ROUTE,
            indexScreen: 0,
          )),
    );
  }
}
