import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/painting.dart';
import 'package:flutter_datetime_picker/flutter_datetime_picker.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:provider/provider.dart';
import 'package:unilink_flutter_app/constant/path_router.dart';
import 'package:unilink_flutter_app/models/district_model.dart';
import 'package:unilink_flutter_app/translate/vn.dart';
import 'package:unilink_flutter_app/utils/asset_icon.dart';
import 'package:unilink_flutter_app/utils/button.dart';
import 'package:unilink_flutter_app/utils/date_picker.dart';
import 'package:unilink_flutter_app/utils/hex_color.dart';
import 'package:unilink_flutter_app/utils/spinner.dart';
import 'package:unilink_flutter_app/view_model/address_view_model.dart';
import 'package:unilink_flutter_app/view_model/member_view_model.dart';
import 'package:unilink_flutter_app/widgets/app_bar_child_widget.dart';

class RegisterForm extends StatelessWidget {
  String _label;
  String _notification;
  TextEditingController _textController = TextEditingController();
  bool _isText;
  Function _callback;
  RegisterForm(
      {String label,
      String notification,
      bool isText,
      Function callback,
      String currentText = ""}) {
    _label = label;
    _notification = notification;
    _isText = isText;
    _callback = callback;
    _textController.text = currentText;
  }
  // ignore: use_key_in_widget_constructors
  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(_label,
            style: TextStyle(
                fontSize: 24,
                color: Colors.black.withOpacity(0.75),
                fontWeight: FontWeight.w500)),
        Container(
          margin: const EdgeInsets.only(bottom: 14),
          child: _isText
              ? TextField(
                  controller: _textController,
                  onChanged: (value) {
                    _callback(value);
                  },
                )
              : DateOfBirth(callback: _callback),
        ),
        Text(
          _notification,
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.w300),
        )
      ]
          .map((element) => Padding(
                padding: const EdgeInsets.only(bottom: 4),
                child: element,
              ))
          .toList(),
    );
  }
}

//  use_key_in_widget_constructors
class RegisterByPhone5Page extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _RegisterByPhone5PageState();
  }
}

//
class _RegisterByPhone5PageState extends State<RegisterByPhone5Page> {
  onRouter(String path) => Navigator.of(context).pushNamed(path);
  String name = "";
  DateTime dob;
  String dropdownValueProvince = "--Tỉnh--";
  String dropdownValueDistrict = "--Quận--";
  bool isShowProvince = false;
  bool isShowDistrict = false;
  bool isShowAdress = false;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    initProvince();
  }

  List<District> listDistrict = [
    District(
        name: "--Quận--",
        code: -1,
        province_code: -1,
        codename: "--Quận--",
        division_type: "")
  ];
  TextEditingController _textAddressController = TextEditingController();
  String address = "";
  Future<List<ProvinceViewModel>> getProvince() async {
    return await Provider.of<AddressViewModel>(context, listen: false)
        .getAllProvince();
  }

  List<ProvinceViewModel> listProvinces = [];
  Future<void> initProvince() async {
    listProvinces = await getProvince();
    setState(() {
      isShowProvince = true;
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

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
          appBar: PreferredSize(
              preferredSize: const Size(double.infinity, kToolbarHeight),
              child: AppBarChildWidget(
                path: REGISTER_BY_PHONE_INPUT_SCHOOL_MAJOR_ROUTE,
              )),
          resizeToAvoidBottomInset: false,
          body: SingleChildScrollView(
            child: Column(
              children: <Widget>[
                Container(
                  margin: const EdgeInsets.only(left: 30, right: 30, top: 15),
                  child: Column(
                    // crossAxisAlignment: CrossAxisAlignment.stretch,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      RegisterForm(
                        label: LABEL_ENTER_NAME,
                        notification: LABEL_ENTER_INFO,
                        isText: true,
                        callback: callbackForGetName,
                        currentText: name,
                      ),
                      RegisterForm(
                        label: LABEL_ENTER_BIRTH_DAY,
                        notification: LABEL_ENTER_BIRTH_DAY_INFO,
                        isText: false,
                        callback: callbackForGetDate,
                      ),
                      Text(LABEL_ENTER_ADDRESS,
                          style: TextStyle(
                              fontSize: 24,
                              color: Colors.black.withOpacity(0.75),
                              fontWeight: FontWeight.w500)),
                      isShowProvince == false
                          ? Center(
                              child: CircularProgressIndicator(),
                            )
                          : Padding(
                              padding: EdgeInsets.only(top: 0),
                              child: DropdownButton<String>(
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
                                    dropdownValueDistrict = "--Quận--";
                                  });
                                },
                                items: listProvinces
                                    .map<DropdownMenuItem<String>>(
                                        (ProvinceViewModel value) {
                                  return DropdownMenuItem<String>(
                                    value: value.province.name,
                                    child: Text(value.province.name),
                                    onTap: () {
                                      setState(() {
                                        if (value.province.code > 0) {
                                          isShowDistrict = true;
                                          listDistrict =
                                              value.province.districts;
                                        } else {
                                          isShowDistrict = false;
                                          isShowAdress = false;
                                          listDistrict = initListDistrict();
                                        }
                                      });
                                    },
                                  );
                                }).toList(),
                              ),
                            ),
                      isShowDistrict == false
                          ? null
                          : Padding(
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
                                    if (newValue == "--Quận--") {
                                      dropdownValueDistrict = newValue;
                                      isShowAdress = false;
                                    } else {
                                      dropdownValueDistrict = newValue;
                                      isShowAdress = true;
                                    }
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
                      isShowAdress == false
                          ? null
                          : Column(
                              children: [
                                Row(
                                  children: [
                                    Text(
                                      "Tên đường: ",
                                      style: TextStyle(),
                                    ),
                                    Container(
                                        padding: EdgeInsets.only(left: 10),
                                        width:
                                            MediaQuery.of(context).size.width *
                                                0.6,
                                        margin:
                                            const EdgeInsets.only(bottom: 14),
                                        child: TextField(
                                          controller: _textAddressController,
                                          onChanged: (value) {
                                            setState(() {
                                              address = value;
                                            });
                                          },
                                        )),
                                  ],
                                ),
                                Text(
                                  LABEL_ENTER_INFO,
                                  style: TextStyle(
                                      fontSize: 18,
                                      fontWeight: FontWeight.w300),
                                )
                              ],
                            ),
                      Center(
                        child: ElevatedButton(
                            onPressed: () {
                              if (name.isEmpty) {
                                Fluttertoast.showToast(
                                    msg: "Hãy nhập tên của bạn");
                                return;
                              }
                              if (dob == null) {
                                Fluttertoast.showToast(
                                    msg: "Hãy chọn ngày sinh của bạn");
                                return;
                              }
                              if (isShowAdress == false) {
                                print(_textAddressController.text + " Yes");
                                Fluttertoast.showToast(
                                    msg: "Hãy nhập hoàn tất address của bạn");
                                return;
                              }
                              List<String> name_temp = name.trim().split(" ");
                              Provider.of<MemberListViewModel>(context,
                                      listen: false)
                                  .insertMember
                                  .member
                                  .firstName = name_temp[0];
                              if (name_temp.length >= 2) {
                                name_temp.removeAt(0);
                                Provider.of<MemberListViewModel>(context,
                                        listen: false)
                                    .insertMember
                                    .member
                                    .lastName = name_temp.join(" ");
                              } else {
                                Provider.of<MemberListViewModel>(context,
                                        listen: false)
                                    .insertMember
                                    .member
                                    .lastName = "temp";
                              }
                              Provider.of<MemberListViewModel>(context,
                                      listen: false)
                                  .insertMember
                                  .member
                                  .dob = this.dob;
                              String address_temp = dropdownValueProvince +
                                          "-" +
                                          dropdownValueDistrict +
                                          this.address ==
                                      ""
                                  ? ""
                                  : "-${this.address}";

                              Provider.of<MemberListViewModel>(context,
                                      listen: false)
                                  .insertMember
                                  .member
                                  .address = address_temp;
                              onRouter(REGISTER_BY_PHONE_INPUT_GENDER_ROUTE);
                            },
                            style:
                                getStyleElevatedButton(width: 302, height: 44),
                            child: Text(
                              LABEL_BUTTON_NEXT,
                              style: TextStyle(
                                  fontSize: 17, fontWeight: FontWeight.bold),
                            )),
                      ),
                    ]
                        .map((element) => Padding(
                              padding: const EdgeInsets.only(
                                bottom: 20,
                              ),
                              child: element,
                            ))
                        .toList(),
                  ),
                ),
              ],
            ),
          )),
    );
  }

  void callbackForGetDate(DateTime picker) {
    dob = picker;
  }

  void callbackForGetName(String _name) {
    name = _name;
  }
}
