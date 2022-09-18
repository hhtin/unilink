import 'dart:typed_data';

import 'package:dotted_border/dotted_border.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:provider/provider.dart';
import 'package:unilink_flutter_app/constant/path_router.dart';
import 'package:unilink_flutter_app/models/major.dart';
import 'package:unilink_flutter_app/models/member_model.dart';
import 'package:unilink_flutter_app/models/skill.dart';
import 'package:unilink_flutter_app/service/member_service.dart';
import 'package:unilink_flutter_app/translate/vn.dart';
import 'package:unilink_flutter_app/utils/asset_icon.dart';
import 'package:unilink_flutter_app/utils/button.dart';
import 'package:unilink_flutter_app/utils/color.dart';
import 'package:flutter_datetime_picker/flutter_datetime_picker.dart';
import 'package:unilink_flutter_app/utils/hex_color.dart';
import 'package:unilink_flutter_app/utils/spinner.dart';
import 'package:unilink_flutter_app/view_model/major_view_model.dart';
import 'package:unilink_flutter_app/view_model/member_view_model.dart';
import 'package:unilink_flutter_app/view_model/skill_view_model.dart';
import 'package:unilink_flutter_app/view_model/university_view_model.dart';
import 'package:unilink_flutter_app/widgets/app_bar_child_widget.dart';
import 'package:unilink_flutter_app/widgets/modal_image_picker.dart';
import 'package:unilink_flutter_app/widgets/model_list_skill.dart';
import 'package:flutter/services.dart' show rootBundle;

class EditProfilePage extends StatefulWidget {
  @override
  _EditProfilePageState createState() => _EditProfilePageState();
}

class _EditProfilePageState extends State<EditProfilePage> {
  String dropdownValueSchool = "";
  String dropdownValueGentle = "";
  String nameValue = "";
  String descriptionValue = "";
  String addressValue = "";
  List<SkillViewModel> skillList = [];
  DateTime dob;
  String dropdownSchoolId = "";
  String firstNameValue = "";
  String lastNameValue = "";
  Map<String, SkillViewModel> chooseMap = Map();
  List<SkillViewModel> chooseList = [];
  List<String> listGentle = ["Nam", "Nữ", "Khác"];
  MemberViewModel member;
  int selectedGenderID;

  List<MajorViewModel> chooseMajorList = [];
  MajorViewModel dropdownValueMajor;
  List<MajorViewModel> listMajor;
  Uint8List avatar;

  final List<String> images = [
    "name-30px.png",
    "university-30px.png",
    "DOB-30px.png",
    "location-30px.png",
    "major-30px.png",
    "gender-30px.png",
    "skill-30px.png",
  ];

  List<String> convertFromMajorViewModelToObjList(
      List<MajorViewModel> modelList) {
    List<String> majorIds = [];
    for (int count = 0; count < modelList.length; count++) {
      majorIds.add(modelList[count].major.id);
    }
    return majorIds;
  }

  List<String> convertFromSkillViewModelToObjList(
      List<SkillViewModel> modelList) {
    List<String> skillIds = [];
    for (int count = 0; count < modelList.length; count++) {
      skillIds.add(modelList[count].skill.id);
    }
    return skillIds;
  }

  Future<List<UniversityViewModel>> getUniversityList() async {
    return await Provider.of<UniversityListViewModel>(context, listen: false)
        .universityList;
  }

  MemberViewModel getInforMember() {
    MemberViewModel memberViewModel =
        Provider.of<MemberListViewModel>(context, listen: false).member;
    setState(() {
      member = memberViewModel;
    });

    return memberViewModel;
  }

  UniversityViewModel getUniversityById(String id) {
    List<UniversityViewModel> unis =
        Provider.of<UniversityListViewModel>(context, listen: false)
            .universityList;
    for (int count = 0; count < unis.length; count++) {
      if (unis[count].university.id == id) {
        return unis[count];
      }
    }
  }

  void updateMember() {
    Member updatedMember = Member();
    updatedMember.address = addressValue;
    updatedMember.phone = member.member.phone;
    updatedMember.email = member.member.email;
    updatedMember.roleId = member.member.roleId;
    updatedMember.description = descriptionValue;
    updatedMember.id = member.member.id;
    updatedMember.firstName = firstNameValue;
    updatedMember.lastName = lastNameValue;
    updatedMember.dob = dob;
    if (selectedGenderID == 1) {
      updatedMember.gender = 1;
    } else if (selectedGenderID == 0) {
      updatedMember.gender = 0;
    } else {
      updatedMember.gender = 2;
    }
    updatedMember.universityId = dropdownSchoolId;
    Provider.of<MemberListViewModel>(context, listen: false).updateMember(
        updatedMember,
        convertFromMajorViewModelToObjList(chooseMajorList),
        convertFromSkillViewModelToObjList(chooseList),
        Provider.of<MemberListViewModel>(context, listen: false).avatarUpdate);
  }

  @override
  void initState() {
    super.initState();
    getInforMember();
    //dropdownValueMajor = member.majors.first.name;
    dropdownValueSchool =
        getUniversityById(member.member.universityId).university.name;
    dropdownSchoolId = member.member.universityId;
    dropdownValueGentle = "Nam";
    addressValue = member.member.address;
    nameValue = member.fullName;
    if (member.member.gender == 1) {
      dropdownValueGentle = "Nam";
    } else if (member.member.gender == 0) {
      dropdownValueGentle = "Nữ";
    } else {
      dropdownValueGentle = "Khác";
    }
    dob = member.member.dob;
    descriptionValue = member.member.description;
    firstNameValue = member.member.firstName;
    lastNameValue = member.member.lastName;
    member.skills.forEach((element) {
      chooseMap
          .addEntries([MapEntry('${element.id}', SkillViewModel(element))]);
      chooseList.add(SkillViewModel(element));
    });
    member.majors.forEach((element) {
      chooseMajorList.add(MajorViewModel(element));
    });

    listMajor =
        Provider.of<MajorListViewModel>(context, listen: false).majorList;
    skillList =
        Provider.of<SkillListViewModel>(context, listen: false).skillList;
    if (member.member.avatar != null && member.member.avatar.isNotEmpty) {
      convertNetworkToUInt8List(member.member.avatar).then((value) {
        avatar = value;
      });
    } else {
      convertAssetImgToUInt8List("assets/icons/user-1.png").then((value) {
        avatar = value;
      });
    }
  }

  Widget _renderSkill(skill) {
    SkillViewModel skillObj = skill;
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
                skillObj.skill.name,
                style: TextStyle(color: HexColor.fromHex("#000000")),
                overflow: TextOverflow.ellipsis,
              ),
            ),
          )
        ],
      ),
    );
  }

  Future<List<SkillViewModel>> getSkillList() async {
    return await Provider.of<SkillListViewModel>(context, listen: false)
        .skillList;
  }

  @override
  Widget build(BuildContext context) {
    TextEditingController firstNameControl =
        TextEditingController(text: firstNameValue);
    TextEditingController lastNameControl =
        TextEditingController(text: lastNameValue);
    TextEditingController addressControl =
        TextEditingController(text: addressValue);
    TextEditingController descriptionControl =
        TextEditingController(text: descriptionValue);

    return Scaffold(
      appBar: PreferredSize(
          preferredSize: const Size(double.infinity, kToolbarHeight),
          child: AppBarChildWidget()),
      body: Container(
          alignment: Alignment.center,
          child: SingleChildScrollView(
            child: Container(
              color: Colors.white,
              margin: EdgeInsets.only(top: 40),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Container(
                    padding: EdgeInsets.only(
                        top: 10.0, left: 40.0, right: 40.0, bottom: 20.0),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Padding(
                            padding: EdgeInsets.only(bottom: 10.0),
                            child: Container(
                                width: 100,
                                height: 100,
                                child: Spinner.spinnerWithFuture(
                                    Future.delayed(Duration(seconds: 2)),
                                    (data) {
                                  return CircleAvatar(
                                    radius: 50.0,
                                    backgroundImage: (avatar != null)
                                        ? MemoryImage(avatar)
                                        : AssetImage("assets/icons/user-1.png"),
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
                          padding:
                              const EdgeInsets.only(bottom: 20.0, top: 20.0),
                          child: Text(nameValue,
                              style: TextStyle(
                                  color: Colors.black,
                                  fontSize: 24,
                                  fontWeight: FontWeight.bold)),
                        ),
                        DottedBorder(
                          strokeWidth: 1,
                          color: Success,
                          child: Container(
                            padding: EdgeInsets.all(2.0),
                            child: Center(
                                child: Padding(
                              padding: EdgeInsets.all(20),
                              child: TextField(controller: descriptionControl),
                            )),
                          ),
                        )
                      ],
                    ),
                  ),
                  Container(
                      padding: EdgeInsets.only(
                          left: 40.0, right: 40.0, bottom: 20.0),
                      child: Column(children: [
                        Container(
                          margin: EdgeInsets.only(bottom: 20),
                          child: Row(
                            children: [
                              Image.asset(getPathOfIcon("name-30px.png")),
                              Container(
                                width: 100,
                                margin: EdgeInsets.only(left: 20),
                                child: TextField(controller: firstNameControl),
                              ),
                              Container(
                                  width: 20,
                                  margin: EdgeInsets.only(left: 20),
                                  child: Text("-")),
                              Container(
                                width: 100,
                                margin: EdgeInsets.only(left: 20),
                                child: TextField(controller: lastNameControl),
                              )
                            ],
                          ),
                        ),
                        Container(
                          margin: EdgeInsets.only(bottom: 20),
                          child: Row(
                            children: [
                              Image.asset(getPathOfIcon("university-30px.png")),
                              Container(
                                margin: EdgeInsets.only(left: 20),
                                child: Padding(
                                    padding: EdgeInsets.only(top: 0),
                                    child: Spinner.spinnerWithFuture(
                                        getUniversityList(), (data) {
                                      return DropdownButton<String>(
                                        value: dropdownValueSchool,
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
                                            dropdownValueSchool = newValue;
                                          });
                                        },
                                        items: data
                                            .map<DropdownMenuItem<String>>(
                                                (UniversityViewModel value) {
                                          return DropdownMenuItem<String>(
                                            value: value.university.name,
                                            child: Text(value.university.name),
                                            onTap: () {
                                              setState(() {
                                                dropdownSchoolId =
                                                    value.university.id;
                                              });
                                            },
                                          );
                                        }).toList(),
                                      );
                                    })),
                              )
                            ],
                          ),
                        ),
                        Container(
                          margin: EdgeInsets.only(bottom: 20),
                          child: Row(
                            children: [
                              Image.asset(getPathOfIcon("DOB-30px.png")),
                              Container(
                                width: 260,
                                margin: EdgeInsets.only(left: 20),
                                child: InkWell(
                                  onTap: () {
                                    DatePicker.showDatePicker(context,
                                        theme: DatePickerTheme(
                                            backgroundColor: Colors.white),
                                        showTitleActions: true,
                                        minTime: DateTime(1900, 3, 5),
                                        maxTime: DateTime(2020, 6, 7),
                                        onChanged: (date) {},
                                        onConfirm: (date) {
                                      setState(() {
                                        dob = DateTime(
                                            date.year, date.month, date.day);
                                      });
                                    },
                                        currentTime: DateTime.now(),
                                        locale: LocaleType.vi);
                                  },
                                  child: Text(
                                    '${dob.day}/${dob.month}/${dob.year}',
                                    style: TextStyle(fontSize: 17),
                                  ),
                                ),
                              )
                            ],
                          ),
                        ),
                        Container(
                          margin: EdgeInsets.only(bottom: 20),
                          child: Row(
                            children: [
                              Image.asset(getPathOfIcon("location-30px.png")),
                              Container(
                                width: 260,
                                margin: EdgeInsets.only(left: 20),
                                child: TextField(controller: addressControl),
                              )
                            ],
                          ),
                        ),
                        // Container(
                        //   margin: EdgeInsets.only(bottom: 20),
                        //   child: Row(
                        //     children: [
                        //       Image.asset(getPathOfIcon("major-30px.png")),
                        //       Container(
                        //         width: 260,
                        //         margin: EdgeInsets.only(left: 20),
                        //         child: Padding(
                        //           padding: EdgeInsets.only(top: 0),
                        //           child: Spinner.spinnerWithFuture(
                        //               getMajorList(), (data) {
                        //             return DropdownButton<String>(
                        //               value: dropdownValueMajor,
                        //               iconSize: 0,
                        //               elevation: 16,
                        //               style:
                        //                   const TextStyle(color: Colors.black),
                        //               underline: Container(
                        //                 height: 2,
                        //                 color: Colors.grey,
                        //               ),
                        //               onChanged: (String value) {
                        //                 setState(() {
                        //                   dropdownValueMajor = value;
                        //                 });
                        //               },
                        //               items: data.map<DropdownMenuItem<String>>(
                        //                   (MajorViewModel value) {
                        //                 return DropdownMenuItem<String>(
                        //                   value: value.major.name,
                        //                   child: Text(value.major.name),
                        //                   onTap: () {
                        //                     setState(() {
                        //                       majorList = [value.major];
                        //                     });
                        //                     loadInitBase();
                        //                   },
                        //                 );
                        //               }).toList(),
                        //             );
                        //           }),
                        //         ),
                        //       )
                        //     ],
                        //   ),
                        // ),
                        //
                        Container(
                          child: Column(
                            children: [
                              Row(
                                children: [
                                  Image.asset(getPathOfIcon("major-30px.png")),
                                  Padding(
                                      padding:
                                          EdgeInsets.only(left: 10, right: 10)),
                                  Expanded(
                                    child: Padding(
                                      padding: EdgeInsets.only(top: 0),
                                      child: SingleChildScrollView(
                                        scrollDirection: Axis.horizontal,
                                        child: DropdownButton<MajorViewModel>(
                                          menuMaxHeight: 200,
                                          hint: Text("Select Major"),
                                          value: dropdownValueMajor,
                                          iconSize: 0,
                                          elevation: 16,
                                          style: const TextStyle(
                                              color: Colors.black),
                                          underline: Container(
                                            height: 2,
                                            color: Colors.grey,
                                          ),
                                          onChanged: (MajorViewModel newValue) {
                                            if (chooseMajorList.length == 2) {
                                              Fluttertoast.showToast(
                                                  msg: "Tối đa là 2 majors");
                                              return;
                                            }
                                            setState(() {
                                              dropdownValueMajor = newValue;
                                              chooseMajorList.add(newValue);
                                            });
                                          },
                                          items: listMajor.map<
                                                  DropdownMenuItem<
                                                      MajorViewModel>>(
                                              (MajorViewModel value) {
                                            return DropdownMenuItem(
                                              value: value,
                                              child: Text(
                                                value.major.name,
                                                style: TextStyle(
                                                    fontWeight:
                                                        FontWeight.w400),
                                              ),
                                            );
                                          }).toList(),
                                        ),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                              Padding(
                                padding:
                                    const EdgeInsets.only(left: 50, right: 10),
                                child: Container(
                                  height: 80,
                                  child: ListView.builder(
                                    scrollDirection: Axis.vertical,
                                    itemCount: chooseMajorList?.length,
                                    itemBuilder: (context, index) {
                                      var size = MediaQuery.of(context).size;
                                      return Padding(
                                          padding:
                                              const EdgeInsets.only(top: 10),
                                          child: Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceBetween,
                                            children: [
                                              Container(
                                                width: size.width * 0.5,
                                                padding: EdgeInsets.all(2),
                                                decoration: BoxDecoration(
                                                    shape: BoxShape.rectangle,
                                                    boxShadow: [
                                                      BoxShadow(
                                                        color:
                                                            Default.withOpacity(
                                                                0.3),
                                                        spreadRadius: 2,
                                                        blurRadius: 2,
                                                        offset: Offset(0,
                                                            3), // changes position of shadow
                                                      ),
                                                    ],
                                                    color: Secondary,
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            10)),
                                                child: Text(
                                                  chooseMajorList[index]
                                                      .major
                                                      .name,
                                                  overflow:
                                                      TextOverflow.ellipsis,
                                                ),
                                              ),
                                              InkWell(
                                                onTap: () {
                                                  deleteMajor(index);
                                                },
                                                child: Icon(Icons.close),
                                              )
                                            ],
                                          ));
                                    },
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                        //
                        Container(
                          margin: EdgeInsets.only(bottom: 20),
                          child: Row(
                            children: [
                              Image.asset(getPathOfIcon("gender-30px.png")),
                              Container(
                                margin: EdgeInsets.only(left: 20),
                                child: Padding(
                                  padding: EdgeInsets.only(top: 0),
                                  child: DropdownButton<String>(
                                      value: dropdownValueGentle,
                                      iconSize: 0,
                                      elevation: 16,
                                      style:
                                          const TextStyle(color: Colors.black),
                                      underline: Container(
                                        height: 2,
                                        color: Colors.grey,
                                      ),
                                      onChanged: (String newValue) {
                                        setState(() {
                                          dropdownValueGentle = newValue;
                                        });
                                      },
                                      items: [
                                        DropdownMenuItem<String>(
                                          child: Text("Nam"),
                                          value: "Nam",
                                          onTap: () {
                                            setState(() {
                                              selectedGenderID = 1;
                                            });
                                          },
                                        ),
                                        DropdownMenuItem<String>(
                                          child: Text("Nữ"),
                                          value: "Nữ",
                                          onTap: () {
                                            setState(() {
                                              selectedGenderID = 0;
                                            });
                                          },
                                        ),
                                        DropdownMenuItem<String>(
                                          child: Text("Khác"),
                                          value: "Khác",
                                          onTap: () {
                                            setState(() {
                                              selectedGenderID = 2;
                                            });
                                          },
                                        )
                                      ]),
                                ),
                              )
                            ],
                          ),
                        ),
                        Container(
                          margin: EdgeInsets.only(bottom: 20),
                          child: Row(
                            children: [
                              Image.asset(getPathOfIcon("skill-30px.png")),
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
                                                chooseList.length,
                                                (index) => _renderSkill(
                                                    chooseList[index])),
                                          )),
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
                                  child: Spinner.spinnerWithFuture(
                                      getSkillList(), (data) {
                                    return IconButton(
                                      color: Colors.white,
                                      iconSize: 20,
                                      splashRadius: 20,
                                      disabledColor: Colors.grey,
                                      tooltip: "",
                                      icon: Image.asset(
                                          'assets/icons/flus-icon.png'),
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
                                    );
                                  }),
                                ),
                              )
                            ],
                          ),
                        ),
                      ])),
                  Container(
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Container(
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
                                setState(() {
                                  firstNameValue = firstNameControl.text;
                                  lastNameValue = lastNameControl.text;
                                  descriptionValue = descriptionControl.text;
                                  addressValue = addressControl.text;
                                });
                                bool check = validateUpdate();
                                if (check) {
                                  updateMember();
                                  Navigator.of(context).pop();
                                  Fluttertoast.showToast(
                                      msg: TOAST_EDIT_PROFILE,
                                      toastLength: Toast.LENGTH_LONG);
                                }
                                Fluttertoast.showToast(
                                    msg: "Vui lòng điền đầy đủ thông tin",
                                    toastLength: Toast.LENGTH_LONG);
                              },
                              style: getStyleElevatedButton(
                                width: 150,
                                height: 50,
                              ),
                            ),
                          ),
                        ),
                        Container(
                          padding: EdgeInsets.all(20),
                          child: Container(
                            margin: EdgeInsets.only(bottom: 20),
                            child: ElevatedButton(
                              child: Container(
                                child: Text(
                                  "Huỷ",
                                  style: TextStyle(fontSize: 20),
                                ),
                              ),
                              onPressed: () {
                                Navigator.of(context).pop();
                              },
                              style: getStyleElevatedButton(
                                  width: 150,
                                  height: 50,
                                  type: ButtonType.WARNING),
                            ),
                          ),
                        )
                      ],
                    ),
                  )
                ],
              ),
            ),
          )),
    );
  }

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

  void deleteMajor(int index) {
    setState(() {
      dropdownValueMajor = null;
      chooseMajorList.removeAt(index);
    });
  }

  bool validateUpdate() {
    bool check = true;
    if (firstNameValue == null || firstNameValue.isEmpty) {
      check = false;
    }
    if (lastNameValue == null || lastNameValue.isEmpty) {
      check = false;
    }
    if (addressValue == null || addressValue.isEmpty) {
      check = false;
    }
    if (descriptionValue == null || descriptionValue.isEmpty) {
      check = false;
    }
    if (dropdownSchoolId == null || dropdownSchoolId.isEmpty) {
      check = false;
    }
    if (dob == null) {
      check = false;
    }
    if (chooseMajorList == null || chooseMajorList.isEmpty) {
      check = false;
    }
    if (chooseList == null || chooseList.isEmpty) {
      check = false;
    }
    if (!check) {
      return false;
    }
    return true;
  }

  Future<Uint8List> convertNetworkToUInt8List(String url) async {
    try {
      ByteData bytes = await NetworkAssetBundle(Uri.parse(url)).load(url);
      Uint8List tmpavatar = bytes.buffer.asUint8List();
      return tmpavatar;
    } catch (e) {
      print(e);
    }
  }

  Future<Uint8List> convertAssetImgToUInt8List(String url) async {
    try {
      ByteData bytes = await rootBundle.load(url);
      Uint8List tmpavatar =
          bytes.buffer.asUint8List(bytes.offsetInBytes, bytes.lengthInBytes);
      return tmpavatar;
    } catch (e) {
      print(e);
    }
  }

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
}
