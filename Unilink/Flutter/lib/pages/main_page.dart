import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:unilink_flutter_app/pages/chat_page.dart';
import 'package:unilink_flutter_app/pages/groups_page.dart';
import 'package:unilink_flutter_app/pages/home_page.dart';
import 'package:unilink_flutter_app/pages/profile_page.dart';
import 'package:unilink_flutter_app/service/common_service.dart';
import 'package:unilink_flutter_app/utils/color.dart';
import 'package:unilink_flutter_app/view_model/major_view_model.dart';
import 'package:unilink_flutter_app/view_model/member_view_model.dart';
import 'package:unilink_flutter_app/view_model/skill_view_model.dart';
import 'package:unilink_flutter_app/view_model/university_view_model.dart';

// ignore: must_be_immutable
class MainPage extends StatefulWidget {
  int currentIndex = 0;
  @override
  _MainPageState createState() => _MainPageState();

  void setCurrentIndex(int currentIndex) {
    this.currentIndex = currentIndex;
  }
}

class _MainPageState extends State<MainPage> {
  final screens = [HomePage(), GroupsPage(), ChatPage(), ProfilePage()];
  @override
  void initState() {
    super.initState();
    loadInitBase();
  }

  Future<void> loadInitBase() {
    print("Load Init Base !!!");
    Provider.of<UniversityListViewModel>(context, listen: false).getAll();
    // .then(
    //     (value) => print(
    //         Provider.of<UniversityListViewModel>(context, listen: false)
    //             .universityList));
    Provider.of<MajorListViewModel>(context, listen: false).getAll();
    // .then(
    //     (value) => print(
    //         Provider.of<MajorListViewModel>(context, listen: false).majorList));
    Provider.of<SkillListViewModel>(context, listen: false).getAll();
    // .then(
    //     (value) => print(
    //         Provider.of<SkillListViewModel>(context, listen: false).skillList));
    Provider.of<MemberListViewModel>(context, listen: false)
        .getIdentifier()
        .then((value) => print(value));
  }

  Widget _createBottomNavigationBar() {
    return Container(
      child: BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        backgroundColor: Colors.white,
        selectedItemColor: PrimaryColor,
        unselectedItemColor: Colors.black.withOpacity(.60),
        selectedFontSize: 14,
        elevation: 0,
        unselectedFontSize: 12,
        onTap: (index) => setState(() => widget.currentIndex = index),
        currentIndex: widget.currentIndex,
        items: [
          BottomNavigationBarItem(
            label: 'Trang chủ',
            icon: Icon(
              Icons.home,
            ),
          ),
          BottomNavigationBarItem(
            label: 'Hội nhóm',
            icon: Icon(
              Icons.group,
            ),
          ),
          BottomNavigationBarItem(
            label: 'Tin nhắn',
            icon: Icon(
              Icons.message,
            ),
          ),
          BottomNavigationBarItem(
            label: 'Tài khoản',
            icon: Icon(
              Icons.account_circle,
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Builder(
          builder: (context) => screens[widget.currentIndex],
        ),
        bottomNavigationBar: _createBottomNavigationBar());
  }
}
