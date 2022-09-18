import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:provider/provider.dart';
import 'package:unilink_flutter_app/constant/path_router.dart';
import 'package:unilink_flutter_app/models/member_model.dart';
import 'package:unilink_flutter_app/translate/vn.dart';
import 'package:unilink_flutter_app/utils/button.dart';
import 'package:unilink_flutter_app/utils/color.dart';
import 'package:unilink_flutter_app/view_model/major_view_model.dart';
import 'package:unilink_flutter_app/view_model/member_view_model.dart';
import 'package:unilink_flutter_app/view_model/skill_view_model.dart';
import 'package:unilink_flutter_app/view_model/university_view_model.dart';
import 'package:unilink_flutter_app/widgets/app_bar_child_widget.dart';

class RegisterByPhoneInputSchoolMajorPage extends StatefulWidget {
  @override
  _RegisterByPhoneInputSchoolMajorState createState() =>
      _RegisterByPhoneInputSchoolMajorState();
}

class _RegisterByPhoneInputSchoolMajorState
    extends State<RegisterByPhoneInputSchoolMajorPage> {
  UniversityViewModel dropdownValueSchool;

  List<UniversityViewModel> listSchool;

  MajorViewModel dropdownValueMajor;
  List<MajorViewModel> chooseMajorList = [];
  List<MajorViewModel> listMajor;
  bool isLoad = true;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    loadInitBase();
  }

  Future<void> loadInitBase() async {
    Provider.of<UniversityListViewModel>(context, listen: false).getAll().then(
        (value) => listSchool =
            Provider.of<UniversityListViewModel>(context, listen: false)
                .universityList);
    Provider.of<MajorListViewModel>(context, listen: false).getAll().then(
        (value) => listMajor =
            Provider.of<MajorListViewModel>(context, listen: false).majorList);
    while (true) {
      if (listMajor != null && listSchool != null) {
        setState(() {
          isLoad = false;
        });
        break;
      } else {
        await Future.delayed(Duration(seconds: 1));
      }
    }
  }

  onRouter(String path) => Navigator.of(context).pushNamed(path);
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
          preferredSize: const Size(double.infinity, kToolbarHeight),
          child: AppBarChildWidget(
            path: REGISTER_BY_PHONE_INPUT_GENDER_ROUTE,
          )),
      body: isLoad
          ? Center(
              child: CircularProgressIndicator(),
            )
          : SingleChildScrollView(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  Container(
                    padding: EdgeInsets.only(right: 130),
                    child: Center(
                      child: Text(LABEL_ENTER_SCHOOL,
                          textAlign: TextAlign.center,
                          style: TextStyle(
                              fontSize: 24,
                              color: Colors.black.withOpacity(0.75),
                              fontWeight: FontWeight.w500)),
                    ),
                  ),
                  Container(
                    child: Column(
                      children: [
                        Row(
                          children: [
                            Padding(padding: EdgeInsets.only(left: 60)),
                            Expanded(
                              child: Padding(
                                  padding: EdgeInsets.only(top: 0),
                                  child: SingleChildScrollView(
                                    scrollDirection: Axis.horizontal,
                                    child: DropdownButton<UniversityViewModel>(
                                      menuMaxHeight: 200,
                                      hint: Text("Select University"),
                                      value: dropdownValueSchool,
                                      iconSize: 0,
                                      elevation: 16,
                                      style: const TextStyle(
                                        color: Colors.black,
                                      ),
                                      underline: Container(
                                        height: 2,
                                        color: Colors.grey,
                                      ),
                                      onChanged:
                                          (UniversityViewModel newValue) {
                                        setState(() {
                                          dropdownValueSchool = newValue;
                                        });
                                      },
                                      items: listSchool.map<
                                              DropdownMenuItem<
                                                  UniversityViewModel>>(
                                          (UniversityViewModel value) {
                                        return DropdownMenuItem<
                                            UniversityViewModel>(
                                          value: value,
                                          child: Text(value.university.name,
                                              style: TextStyle(
                                                  fontWeight: FontWeight.w400)),
                                        );
                                      }).toList(),
                                    ),
                                  )),
                            ),
                            Padding(
                              padding: EdgeInsets.only(right: 60),
                              child: SizedBox(
                                height: 30,
                                width: 30,
                                child: Ink(
                                  child: IconButton(
                                    color: Colors.white,
                                    iconSize: 20,
                                    splashRadius: 20,
                                    disabledColor: Colors.grey,
                                    tooltip: "",
                                    icon: Image.asset(
                                        'assets/icons/flus-icon.png'),
                                    onPressed: () {},
                                  ),
                                  decoration: ShapeDecoration(
                                      color: PrimaryColor,
                                      shape: CircleBorder()),
                                ),
                              ),
                            )
                          ],
                        ),
                        Padding(
                          padding: const EdgeInsets.only(
                              top: 15, right: 50, left: 50, bottom: 40),
                          child: Container(
                            margin: EdgeInsets.only(top: 20),
                            child: Text(
                              LABEL_NOTIFY_INPUT_SCHOOL,
                              style: TextStyle(
                                  fontSize: 15,
                                  color: Colors.black.withOpacity(0.75),
                                  fontWeight: FontWeight.w500),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  Container(
                    child: Column(
                      children: [
                        Padding(
                          padding: EdgeInsets.only(right: 70, bottom: 29),
                          child: Center(
                            child: Text(LABEL_ENTER_MAJOR,
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                    fontSize: 24,
                                    color: Colors.black.withOpacity(0.75),
                                    fontWeight: FontWeight.w500)),
                          ),
                        ),
                        Row(
                          children: [
                            Padding(padding: EdgeInsets.only(left: 60)),
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
                                    style: const TextStyle(color: Colors.black),
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
                                    items: listMajor
                                        .map<DropdownMenuItem<MajorViewModel>>(
                                            (MajorViewModel value) {
                                      return DropdownMenuItem(
                                        value: value,
                                        child: Text(
                                          value.major.name,
                                          style: TextStyle(
                                              fontWeight: FontWeight.w400),
                                        ),
                                      );
                                    }).toList(),
                                  ),
                                ),
                              ),
                            ),
                            Padding(
                              padding: EdgeInsets.only(right: 60),
                              child: SizedBox(
                                height: 30,
                                width: 30,
                                child: Ink(
                                  child: IconButton(
                                    color: Colors.white,
                                    iconSize: 20,
                                    splashRadius: 20,
                                    disabledColor: Colors.grey,
                                    tooltip: "",
                                    icon: Image.asset(
                                        'assets/icons/flus-icon.png'),
                                    onPressed: () {},
                                  ),
                                  decoration: ShapeDecoration(
                                      color: PrimaryColor,
                                      shape: CircleBorder()),
                                ),
                              ),
                            )
                          ],
                        ),
                        Padding(
                          padding: const EdgeInsets.only(left: 60, right: 60),
                          child: Container(
                            height: 80,
                            child: ListView.builder(
                              scrollDirection: Axis.vertical,
                              itemCount: chooseMajorList?.length,
                              itemBuilder: (context, index) {
                                var size = MediaQuery.of(context).size;
                                return Padding(
                                    padding: const EdgeInsets.only(top: 10),
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        Container(
                                          width: size.width * 0.6,
                                          padding: EdgeInsets.all(2),
                                          decoration: BoxDecoration(
                                              shape: BoxShape.rectangle,
                                              boxShadow: [
                                                BoxShadow(
                                                  color:
                                                      Default.withOpacity(0.3),
                                                  spreadRadius: 2,
                                                  blurRadius: 2,
                                                  offset: Offset(0,
                                                      3), // changes position of shadow
                                                ),
                                              ],
                                              color: Secondary,
                                              borderRadius:
                                                  BorderRadius.circular(10)),
                                          child: Text(
                                            chooseMajorList[index].major.name,
                                            overflow: TextOverflow.ellipsis,
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
                        Padding(
                          padding: const EdgeInsets.only(
                              right: 50, left: 50, top: 15, bottom: 40),
                          child: Container(
                            margin: EdgeInsets.only(top: 20),
                            child: Text(
                              LABEL_NOTIFY_INPUT_MAJOR,
                              style: TextStyle(
                                  fontSize: 15,
                                  color: Colors.black.withOpacity(0.75),
                                  fontWeight: FontWeight.w500),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  Container(
                    margin: EdgeInsets.only(bottom: 40),
                    alignment: Alignment.center,
                    height: 44,
                    width: 302,
                    child: ElevatedButton(
                        onPressed: () {
                          if (chooseMajorList.length > 0 &&
                              dropdownValueSchool != null) {
                            Provider.of<MemberListViewModel>(context,
                                        listen: false)
                                    .insertMember
                                    .member
                                    .universityId =
                                dropdownValueSchool.university.id;
                            Provider.of<MemberListViewModel>(context,
                                        listen: false)
                                    .insertMember
                                    .majors =
                                chooseMajorList.map((e) => e.major).toList();
                            onRouter(REGISTER_BY_PHONE_INPUT_SKILL_ROUTE);
                            return;
                          }
                          Fluttertoast.showToast(
                              msg: "Select both University and Major");
                        },
                        style: getStyleElevatedButton(width: 302, height: 44),
                        child: Text(
                          LABEL_BUTTON_NEXT,
                          style: TextStyle(
                              fontSize: 17, fontWeight: FontWeight.bold),
                        )),
                  )
                ],
              ),
            ),
    );
  }

  void deleteMajor(int index) {
    setState(() {
      dropdownValueMajor = null;
      chooseMajorList.removeAt(index);
    });
  }
}
