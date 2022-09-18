import 'dart:ffi';
import 'dart:typed_data';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinbox/flutter_spinbox.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';
import 'package:unilink_flutter_app/constant/path_router.dart';
import 'package:unilink_flutter_app/models/district_model.dart';
import 'package:unilink_flutter_app/models/party_create_model.dart';
import 'package:unilink_flutter_app/models/party_model.dart';
import 'package:unilink_flutter_app/models/skill.dart';
import 'package:unilink_flutter_app/translate/vn.dart';
import 'package:unilink_flutter_app/utils/button.dart';
import 'package:unilink_flutter_app/utils/color.dart';
import 'package:unilink_flutter_app/utils/hex_color.dart';
import 'package:unilink_flutter_app/utils/image.dart';
import 'package:unilink_flutter_app/utils/spinner.dart';
import 'package:unilink_flutter_app/view_model/address_view_model.dart';
import 'package:unilink_flutter_app/view_model/major_view_model.dart';
import 'package:unilink_flutter_app/view_model/member_view_model.dart';
import 'package:unilink_flutter_app/view_model/party_view_model.dart';
import 'package:unilink_flutter_app/view_model/skill_view_model.dart';
import 'package:unilink_flutter_app/widgets/app_bar_child_widget.dart';
import 'package:unilink_flutter_app/widgets/modal_image_picker.dart';
import 'package:unilink_flutter_app/widgets/model_list_skill.dart';
import 'package:unilink_flutter_app/widgets/page_title_widget.dart';

class GroupEditPage extends StatefulWidget {
  @override
  _GroupEditPageState createState() => _GroupEditPageState();
}

class _GroupEditPageState extends State<GroupEditPage> {
  List<MajorSkillViewModel> majorList = [];
  Map<String, SkillViewModel> currentSkillList = Map();
  Map<String, MajorSkillViewModel> currentMajorList = Map();
  Map<String, SkillViewModel> selectedSkills = Map();
  MajorSkillViewModel selectedMajor;
  PartyCreate partyUpdate = new PartyCreate(maximum: 2);
  String dropdownValueProvince = "--Tỉnh--";
  String dropdownValueDistrict = "--Quận--";
  String currentMajor = "";
  bool isLoading = false;
  Uint8List avatar;
  List<District> listDistrict = [
    District(
        name: "--Quận--",
        code: -1,
        province_code: -1,
        codename: "--Quận--",
        division_type: "")
  ];
  List<ProvinceViewModel> listProvince = [];
  void loadImg() {
    if (Provider.of<MemberListViewModel>(context, listen: false).avatarUpdate !=
        null) {
      setState(() {
        Provider.of<MemberListViewModel>(context, listen: false)
            .avatarUpdate
            .readAsBytes()
            .then((value) {
          setState(() {
            avatar = value;
          });
        });
      });
    } else {
      setState(() {
        avatar = null;
      });
    }
  }

  onRouter(String path) => Navigator.of(context).pushNamed(path);
  Widget _renderSkill(viewModel) {
    SkillViewModel skillViewModel = viewModel;
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
                overflow: TextOverflow.ellipsis,
              ),
            ),
          )
        ],
      ),
    );
  }

  Future<void> getMajorList() async {
    setState(() {
      isLoading = true;
    });

    PartyViewModel currentParty =
        Provider.of<PartyListViewModel>(context, listen: false).currentParty;

    if (currentParty.party.image != null && currentParty.party.image != "") {
      avatar = await convertNetworkToUInt8List(currentParty.party.image);
    }
    currentMajorList = new Map();
    await Provider.of<MajorListViewModel>(context, listen: false)
        .getAllMajorWithSkill();
    var majorListTemp =
        await Provider.of<MajorListViewModel>(context, listen: false)
            .majorSkillList;
    majorListTemp.forEach((e) => {
          currentMajorList.putIfAbsent(e.major.id, () => e),
          if (e.major.id == currentParty.party.major.id)
            {
              selectedMajor = e,
            }
        });
    selectedMajor.major.skills.forEach((element) {
      currentSkillList.putIfAbsent(
          element.id, () => new SkillViewModel(element));
    });
    List<ProvinceViewModel> listProvinceTemp =
        await Provider.of<AddressViewModel>(context, listen: false)
            .getAllProvince();
    listProvinceTemp.forEach((element) {
      if (element.province.name ==
          currentParty.party.address.split("-").first) {
        listDistrict = element.province.districts;
      }
    });
    currentParty.party.skills.forEach((element) {
      selectedSkills.putIfAbsent(element.id, () => new SkillViewModel(element));
    });
    Provider.of<MemberListViewModel>(context, listen: false).avatarUpdate =
        null;
    setState(() {
      listProvince = listProvinceTemp;
      majorList = majorListTemp;
      partyUpdate.name = currentParty.party.name;
      partyUpdate.maximum = currentParty.party.maximum;
      partyUpdate.majorId = currentParty.party.major.id;
      partyUpdate.image = partyUpdate.address = currentParty.party.address;
      partyUpdate.description = currentParty.party.description;
      partyUpdate.id = currentParty.party.id;
      dropdownValueProvince = currentParty.party.address.split("-").first;
      dropdownValueDistrict = currentParty.party.address.split("-").last;
      isLoading = false;
    });
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

  void addSkill(
      Map<String, bool> eventList, Map<String, SkillViewModel> changedList) {
    eventList.forEach((key, value) {
      if (selectedSkills.containsKey(key)) {
        if (value == false) {
          selectedSkills.remove(key);
        }
      } else if (value) {
        selectedSkills[key] = changedList[key];
      }
    });
    setState(() {});
  }

  onUpdateParty() async {
    if (partyUpdate.name == null || partyUpdate.name == "") {
      Fluttertoast.showToast(
          msg: "Xin hãy nhập tên nhóm ", toastLength: Toast.LENGTH_SHORT);
      return;
    }
    if (selectedSkills.values.toList() == null ||
        selectedSkills.values.toList().length == 0) {
      Fluttertoast.showToast(
          msg: "Xin hãy chọn kỹ năng", toastLength: Toast.LENGTH_SHORT);
      return;
    }
    if (dropdownValueProvince == "--Tỉnh--") {
      Fluttertoast.showToast(
          msg: "Xin hãy chọn tỉnh thành", toastLength: Toast.LENGTH_SHORT);
      return;
    }
    if (dropdownValueDistrict == "--Quận--") {
      Fluttertoast.showToast(
          msg: "Xin hãy chọn quận huyện", toastLength: Toast.LENGTH_SHORT);
      return;
    }
    if (partyUpdate.description == null || partyUpdate.description == "") {
      Fluttertoast.showToast(
          msg: "Xin hãy nhập mô tả về nhóm ", toastLength: Toast.LENGTH_SHORT);
      return;
    }
    partyUpdate.skill = [];
    selectedSkills.values.toList().forEach((element) {
      partyUpdate.skill.add(element.skill.id);
    });
    partyUpdate.address = dropdownValueProvince + "-" + dropdownValueDistrict;
    XFile avatarParty =
        Provider.of<MemberListViewModel>(context, listen: false).avatarUpdate;
    await Provider.of<PartyListViewModel>(context, listen: false)
        .updateParty(partyUpdate, avatarParty);
    PartyViewModel pRes =
        await Provider.of<PartyListViewModel>(context, listen: false)
            .getPartyById(partyUpdate.id);
    Provider.of<PartyListViewModel>(context, listen: false)
        .setCurrenParty(pRes);
    partyUpdate = new PartyCreate(maximum: 2);

    Fluttertoast.showToast(
        msg: "Cập nhật nhóm thành công", toastLength: Toast.LENGTH_SHORT);

    Navigator.of(context).pop();
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getMajorList();
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
      body: isLoading
          ? Center(
              child: Container(
                color: Colors.white,
                child: CircularProgressIndicator(),
              ),
            )
          : SingleChildScrollView(
              child: Container(
              child: Center(
                child: Container(
                  color: Colors.white,
                  alignment: Alignment.center,
                  child: Column(
                    children: [
                      PageTitleWidget(title: "Cập nhật nhóm"),
                      Padding(
                          padding: EdgeInsets.only(bottom: 10.0),
                          child: Container(
                              width: 100,
                              height: 100,
                              child: Spinner.spinnerWithFuture(
                                  Future.delayed(Duration(seconds: 2)), (data) {
                                return CircleAvatar(
                                  radius: 50.0,
                                  backgroundImage: (avatar != null)
                                      ? MemoryImage(avatar)
                                      : AssetImage("assets/icons/group-4.png"),
                                );
                              }))),
                      Padding(
                          padding: EdgeInsets.only(bottom: 10.0),
                          child: InkWell(
                            child: Text(
                              "Thay hình đại diện",
                              style: TextStyle(
                                  decoration: TextDecoration.underline),
                            ),
                            onTap: () {
                              showDialog(
                                  context: context,
                                  builder: (context) {
                                    return ModelImagePicker(
                                      callback: loadImg,
                                    );
                                  });
                            },
                          )),
                      Padding(
                        padding: EdgeInsets.only(left: 40, top: 40, right: 40),
                        child: Row(
                          children: [
                            Padding(
                              padding: EdgeInsets.only(right: 20),
                              child: Text(
                                "Tên nhóm",
                                style: TextStyle(
                                    fontWeight: FontWeight.bold, fontSize: 18),
                              ),
                            ),
                            Expanded(
                              child: Padding(
                                  padding: EdgeInsets.only(top: 10),
                                  child: TextField(
                                    controller: TextEditingController(
                                        text: partyUpdate.name),
                                    onChanged: (e) => partyUpdate.name = e,
                                    decoration: InputDecoration(
                                        focusedBorder: OutlineInputBorder(
                                          borderSide: BorderSide(
                                              width: 3, color: PrimaryColor),
                                          borderRadius:
                                              BorderRadius.circular(5),
                                        ),
                                        enabledBorder: new OutlineInputBorder(
                                            borderRadius:
                                                BorderRadius.circular(5),
                                            borderSide: new BorderSide(
                                                width: 3,
                                                color: PrimaryColor))),
                                  )),
                            )
                          ],
                        ),
                      ),

                      Padding(
                        padding: EdgeInsets.only(left: 40, top: 40, right: 40),
                        child: Row(
                          children: [
                            Padding(
                              padding: EdgeInsets.only(right: 20),
                              child: Text(
                                "Ngành học",
                                style: TextStyle(
                                    fontWeight: FontWeight.bold, fontSize: 18),
                              ),
                            ),
                            Expanded(
                              child: Padding(
                                padding: EdgeInsets.only(top: 0),
                                child: DropdownButtonFormField<String>(
                                  decoration: InputDecoration(
                                      enabledBorder: OutlineInputBorder(
                                        borderSide: BorderSide(
                                            width: 3, color: PrimaryColor),
                                        borderRadius: const BorderRadius.all(
                                          const Radius.circular(5),
                                        ),
                                      ),
                                      filled: true,
                                      fillColor: Colors.white),
                                  value: partyUpdate.majorId,
                                  iconSize: 0,
                                  elevation: 16,
                                  style: const TextStyle(color: Colors.black),
                                  onChanged: (String newValue) {
                                    Map<String, SkillViewModel> mapTempSkill =
                                        new Map();
                                    currentMajorList[newValue]
                                        .major
                                        .skills
                                        .forEach((e) =>
                                            mapTempSkill.putIfAbsent(e.id,
                                                () => new SkillViewModel(e)));
                                    partyUpdate.majorId = newValue;
                                    PartyViewModel partyTemp =
                                        Provider.of<PartyListViewModel>(context,
                                                listen: false)
                                            .currentParty;
                                    Map<String, SkillViewModel>
                                        mapSelectedkillTemp = new Map();
                                    if (partyUpdate.majorId ==
                                        partyTemp.party.major.id) {
                                      partyTemp.party.skills.forEach((element) {
                                        mapSelectedkillTemp.putIfAbsent(
                                            element.id,
                                            () => new SkillViewModel(element));
                                      });
                                    } else {
                                      selectedSkills = new Map();
                                    }
                                    setState(() {
                                      selectedMajor =
                                          currentMajorList[newValue];
                                      currentSkillList = mapTempSkill;
                                      selectedSkills = mapSelectedkillTemp;
                                    });
                                  },
                                  items: majorList
                                      .map<DropdownMenuItem<String>>(
                                          (MajorSkillViewModel value) {
                                    return DropdownMenuItem<String>(
                                      value: value.major.id,
                                      child: Text(value.major.name),
                                    );
                                  }).toList(),
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
                                "Kỹ năng",
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
                                        child: Row(
                                          children: List.generate(
                                              selectedSkills.values
                                                  .toList()
                                                  .length,
                                              (index) => _renderSkill(
                                                  selectedSkills.values
                                                      .toList()[index])),
                                        ))
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
                              child: Ink(
                                child: IconButton(
                                  color: Colors.white,
                                  iconSize: 20,
                                  splashRadius: 20,
                                  disabledColor: Colors.grey,
                                  tooltip: "",
                                  icon:
                                      Image.asset('assets/icons/flus-icon.png'),
                                  onPressed: () {
                                    showDialog(
                                        context: context,
                                        builder: (context) {
                                          return ModelListSkill(
                                              callback: (eventList,
                                                      chooseSkill) =>
                                                  {
                                                    addSkill(
                                                        eventList, chooseSkill)
                                                  },
                                              skills: currentSkillList.values
                                                  .toList(),
                                              currentList: selectedSkills);
                                        });
                                  },
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
                              padding: EdgeInsets.only(right: 150),
                              child: Text(
                                "Số lượng thành viên",
                                style: TextStyle(
                                    fontWeight: FontWeight.bold, fontSize: 18),
                              ),
                            ),
                            Padding(
                              padding: EdgeInsets.only(top: 0),
                              child: Padding(
                                padding: EdgeInsets.only(
                                    left: 40, top: 10, right: 10),
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
                                                min: Provider.of<
                                                            PartyListViewModel>(
                                                        context,
                                                        listen: false)
                                                    .currentParty
                                                    .party
                                                    .currentMember
                                                    .toDouble(),
                                                max: 10,
                                                value: Provider.of<
                                                            PartyListViewModel>(
                                                        context,
                                                        listen: false)
                                                    .currentParty
                                                    .party
                                                    .currentMember
                                                    .toDouble(),
                                                onChanged: (value) =>
                                                    partyUpdate.maximum =
                                                        value.toInt())))
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
                                    padding:
                                        EdgeInsets.only(top: 10, right: 20),
                                    child: Text(
                                      LABEL_ENTER_FIND_GROUP_CITY,
                                      style: TextStyle(
                                          fontWeight: FontWeight.normal,
                                          fontSize: 15),
                                    ),
                                  ),
                                  Expanded(
                                    child: Padding(
                                        padding: EdgeInsets.only(top: 0),
                                        child: DropdownButton<String>(
                                          value: dropdownValueProvince,
                                          iconSize: 0,
                                          elevation: 16,
                                          style: const TextStyle(
                                              color: Colors.black),
                                          underline: Container(
                                            height: 2,
                                            color: Colors.grey,
                                          ),
                                          onChanged: (String newValue) {
                                            setState(() {
                                              dropdownValueProvince = newValue;
                                              dropdownValueDistrict =
                                                  "--Quận--";
                                            });
                                          },
                                          items: listProvince
                                              .map<DropdownMenuItem<String>>(
                                                  (ProvinceViewModel value) {
                                            return DropdownMenuItem<String>(
                                              value: value.province.name,
                                              child: Text(value.province.name),
                                              onTap: () {
                                                setState(() {
                                                  if (value.province.code > 0) {
                                                    listDistrict = value
                                                        .province.districts;
                                                  } else {
                                                    listDistrict =
                                                        initListDistrict();
                                                  }
                                                });
                                              },
                                            );
                                          }).toList(),
                                        )),
                                  ),
                                ],
                              ),
                            ),
                            Padding(
                              padding: EdgeInsets.only(left: 40, top: 10),
                              child: Row(
                                children: [
                                  Padding(
                                    padding:
                                        EdgeInsets.only(top: 10, right: 40),
                                    child: Text(
                                      LABEL_ENTER_FIND_GROUP_DISTRICT,
                                      style: TextStyle(
                                          fontWeight: FontWeight.normal,
                                          fontSize: 15),
                                    ),
                                  ),
                                  Expanded(
                                    child: Padding(
                                      padding: EdgeInsets.only(top: 0),
                                      child: DropdownButton<String>(
                                        value: dropdownValueDistrict,
                                        iconSize: 0,
                                        elevation: 16,
                                        style: const TextStyle(
                                            color: Colors.black),
                                        underline: Container(
                                          height: 2,
                                          color: Colors.grey,
                                        ),
                                        onChanged: (String newValue) {
                                          setState(() {
                                            dropdownValueDistrict = newValue;
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
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.only(left: 40, top: 50, right: 40),
                        child: Column(
                          children: [
                            Row(
                              children: [
                                Text(
                                  "Mô tả",
                                  style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 18),
                                ),
                              ],
                            ),
                            Padding(
                                padding: EdgeInsets.only(top: 10),
                                child: TextField(
                                  controller: TextEditingController(
                                      text: partyUpdate.description),
                                  onChanged: ((e) =>
                                      {partyUpdate.description = e}),
                                  maxLines: 3,
                                  decoration: InputDecoration(
                                      focusedBorder: OutlineInputBorder(
                                        borderSide: BorderSide(
                                            width: 3, color: PrimaryColor),
                                        borderRadius: BorderRadius.circular(15),
                                      ),
                                      border: new OutlineInputBorder(
                                          borderSide: new BorderSide(
                                              color: PrimaryColor))),
                                )),
                          ],
                        ),
                      ),
                      // Padding(
                      //   padding: EdgeInsets.only(left: 40, top: 50, right: 40),
                      //   child: Column(
                      //     children: [
                      //       Row(
                      //         children: [
                      //           Text(
                      //             "Câu hỏi",
                      //             style: TextStyle(
                      //                 fontWeight: FontWeight.bold, fontSize: 18),
                      //           ),
                      //         ],
                      //       ),
                      //       Padding(
                      //           padding: EdgeInsets.only(top: 10),
                      //           child: TextField(
                      //             maxLines: 3,
                      //             decoration: InputDecoration(
                      //                 focusedBorder: OutlineInputBorder(
                      //                   borderSide:
                      //                       BorderSide(width: 3, color: PrimaryColor),
                      //                   borderRadius: BorderRadius.circular(15),
                      //                 ),
                      //                 border: new OutlineInputBorder(
                      //                     borderSide:
                      //                         new BorderSide(color: PrimaryColor))),
                      //           )),
                      //     ],
                      //   ),
                      // ),
                      Padding(
                          padding: EdgeInsets.only(top: 40, bottom: 20),
                          child: Container(
                            alignment: Alignment.center,
                            height: 44,
                            width: 302,
                            child: ElevatedButton(
                                onPressed: () async {
                                  await onUpdateParty();
                                },
                                style: getStyleElevatedButton(
                                    width: 302, height: 44),
                                child: Text(
                                  "Cập nhật nhóm",
                                  style: TextStyle(
                                      fontSize: 17,
                                      fontWeight: FontWeight.bold),
                                )),
                          ))
                    ],
                  ),
                ),
              ),
            )),
    );
  }
}
