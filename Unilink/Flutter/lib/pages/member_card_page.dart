import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:provider/provider.dart';
import 'package:unilink_flutter_app/constant/path_router.dart';
import 'package:unilink_flutter_app/models/member_model.dart';
import 'package:unilink_flutter_app/utils/asset_icon.dart';
import 'package:unilink_flutter_app/utils/color.dart';
import 'package:unilink_flutter_app/view_model/member_view_model.dart';
import 'package:unilink_flutter_app/view_model/party_view_model.dart';
import 'package:unilink_flutter_app/view_model/swipe_card_view_model.dart';
import 'package:unilink_flutter_app/widgets/app_bar_child_widget.dart';

class ShowPage extends StatefulWidget {
  @override
  _ShowPageState createState() => _ShowPageState();
}

enum SwipingDirection { None, Right, Left }

class SwipeMember {
  String majorId;
}

class _ShowPageState extends State<ShowPage> {
  List<MemberViewModel> listMember = <MemberViewModel>[];
  // final List<User> users = dumyUser.toList();
  SwipingDirection swipingDirection = SwipingDirection.None;
  String partyId = "";
  bool isLoad = false;
  Future<void> getPartiesByMemberId() async {
    setState(() {
      isLoad = true;
    });
    partyId = Provider.of<MemberListViewModel>(context, listen: false).partyId;
    var members =
        Provider.of<MemberListViewModel>(context, listen: false).filterMemberVM;
    if (members.address == null || members.address.isEmpty) {
      members.address = "-";
    }
    var data = await Provider.of<MemberListViewModel>(context, listen: false)
        .filterMember(members.majorId, members.gender, members.startAge,
            members.endAge, members.skillList, members.address);
    if (data != null) {
      if (data.length > 5) {
        listMember = data.getRange(0, 4);
      } else {
        listMember = data;
      }
    }
    setState(() {
      isLoad = false;
    });
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getPartiesByMemberId();
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
          : Padding(
              padding: EdgeInsets.all(8.0),
              child: Column(
                children: [
                  listMember.isEmpty
                      ? Center(
                          child: Text(
                          "No more users",
                          style: TextStyle(fontSize: 20),
                        ))
                      : Stack(
                          children: listMember.map(_buildUser).toList(),
                        ),
                ],
              ),
            ),
    );
  }

  Widget _buildUser(MemberViewModel user) {
    final userIndex = listMember.indexOf(user);
    final isUserInfocus = userIndex == (listMember.length - 1);
    return Listener(
      onPointerMove: (pointerEvent) {
        final provider = Provider.of<FeedbackPosition>(context, listen: false);
        provider.updatePosition(pointerEvent.localDelta.dx);
      },
      onPointerCancel: (_) {
        final provider = Provider.of<FeedbackPosition>(context, listen: false);
        swipingDirection = provider.swipingDirection;
        provider.resetPosition();
      },
      onPointerUp: (_) {
        final provider = Provider.of<FeedbackPosition>(context, listen: false);
        swipingDirection = provider.swipingDirection;

        provider.resetPosition();
      },
      child: Draggable(
        child: UserCardWidget(
          user: user,
          isUserInFocus: isUserInfocus,
        ),
        feedback: Material(
          type: MaterialType.transparency,
          child: UserCardWidget(
            user: user,
            isUserInFocus: isUserInfocus,
          ),
        ),
        childWhenDragging: Container(),
        onDragEnd: (details) => onDragEnd(details, user),
      ),
    );
  }

  void onDragEnd(DraggableDetails details, MemberViewModel user) async {
    final minimumDrag = 100;
    if (details.offset.dx > minimumDrag) {
      user.isSwipedOff = true;
    } else if (details.offset.dx < -minimumDrag) {
      user.isLiked = true;
    }
    if (swipingDirection != SwipingDirection.None) {
      if (swipingDirection == SwipingDirection.Right) {
        if (await Provider.of<PartyListViewModel>(context, listen: false)
            .invitationMember(partyId, user.member.id)) {
          Fluttertoast.showToast(
              msg: "Invitation success", toastLength: Toast.LENGTH_SHORT);
        } else {
          Fluttertoast.showToast(
              msg: "Invitation already", toastLength: Toast.LENGTH_SHORT);
        }
      }
      setState(() {
        listMember.remove(user);
        swipingDirection = SwipingDirection.None;
      });
    }
  }

  Widget buildAppBar() => AppBar(
      centerTitle: true,
      backgroundColor: Colors.transparent,
      elevation: 0,
      actions: [
        Icon(Icons.chat, color: Colors.grey),
        SizedBox(width: 16),
      ],
      leading: Icon(Icons.person, color: Colors.grey),
      title: Text(
          "Temp") //FaIcon(FontAwesomeIcons.fire, color: Colors.deepOrange),
      );
}

class SwipeListCard extends StatefulWidget {
  const SwipeListCard({Key key}) : super(key: key);

  @override
  _SwipeListCardState createState() => _SwipeListCardState();
}

class _SwipeListCardState extends State<SwipeListCard> {
  @override
  Widget build(BuildContext context) {
    return Container();
  }
}

// final List<User> dumyUser = [
//   User(
//       name: "Lê Minh Tuấn",
//       designation: "Java developer",
//       mutualFriends: 3,
//       age: 21,
//       bio: "Anh tuy ốm nhưng đủ ấm để được em ôm !",
//       imgUrl: "avatar-tuan.jpg",
//       location: "Quảng Bình"),
//   User(
//       name: "Phạm Càn Long",
//       designation: "Java developer",
//       mutualFriends: 2,
//       age: 21,
//       bio:
//           "Đối với anh, đồ ăn là giấc mơ là hi vọng. Nhưng ăn ngon thì chỉ có thể là em !",
//       imgUrl: "avatar-long.jpg",
//       location: "Bình Định"),
//   User(
//       name: "Nguyễn Quốc Vinh",
//       designation: "Java developer",
//       mutualFriends: 4,
//       bio: "Người ta nói anh lạnh lùng. Vì đời không cho anh có được em !",
//       age: 21,
//       imgUrl: "avatar-vinh.jpg",
//       location: "Tx. Ninh Hòa"),
// ];

// class User {
//   String name;
//   String designation;
//   int mutualFriends;
//   String bio;
//   int age;
//   String imgUrl;
//   String location;
//   bool isLiked;
//   bool isSwipedOff;
//   User(
//       {this.name,
//       this.designation,
//       this.mutualFriends,
//       this.bio,
//       this.age,
//       this.imgUrl,
//       this.location,
//       this.isLiked = false,
//       this.isSwipedOff = false});
// }

class UserCardWidget extends StatelessWidget {
  final MemberViewModel user;
  final bool isUserInFocus;
  UserCardWidget({Key key, @required this.user, @required this.isUserInFocus})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<FeedbackPosition>(context);
    final swipingDirection = provider.swipingDirection;
    final size = MediaQuery.of(context).size;
    return Container(
      height: size.height * 0.84,
      width: size.width * 0.95,
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10.0),
          image: DecorationImage(
              image: (user.member.avatar != null || user.member.avatar != "")
                  ? NetworkImage(user.member.avatar)
                  : AssetImage(getPathOfIcon(user.member.avatar)),
              fit: BoxFit.cover)),
      child: Container(
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10.0),
            boxShadow: [BoxShadow(color: Colors.black12, spreadRadius: 0.5)],
            gradient: LinearGradient(
                begin: Alignment.center,
                end: Alignment.bottomCenter,
                colors: [Colors.black12, Colors.black87],
                stops: [0.4, 1])),
        child: Stack(
          children: [
            Positioned(
              right: 10,
              left: 10,
              bottom: 10,
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.end,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  _buidUserInfo(user: user, context: context),
                  InkWell(
                    onTap: () {
                      Navigator.of(context).pushNamed(OTHER_PROFILE_ROUTE);
                    },
                    child: Padding(
                      padding: EdgeInsets.only(bottom: 16.0, left: 8.0),
                      child: Icon(Icons.info, color: Colors.white),
                    ),
                  )
                ],
              ),
            ),
            if (isUserInFocus) buildLikeBadge(swipingDirection)
          ],
        ),
      ),
    );
  }

  Widget buildLikeBadge(SwipingDirection swipingDirection) {
    final isSwipingRight = swipingDirection == SwipingDirection.Right;
    final color = isSwipingRight ? Success : Error;
    final angle = isSwipingRight ? -0.5 : 0.5;
    if (swipingDirection == SwipingDirection.None) {
      return Container();
    } else {
      return Positioned(
        top: 20,
        right: isSwipingRight ? null : 20,
        left: isSwipingRight ? 20 : null,
        child: Transform.rotate(
          angle: angle,
          child: Container(
            padding: EdgeInsets.all(8.0),
            decoration:
                BoxDecoration(border: Border.all(color: color, width: 2)),
            child: Text(
              isSwipingRight ? "INVITE" : "NOPE",
              style: TextStyle(
                color: color,
                fontSize: 25,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ),
      );
    }
  }

  Widget _buidUserInfo({@required MemberViewModel user, BuildContext context}) {
    return Padding(
      padding: EdgeInsets.all(8.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            "${user.fullName}",
            style: TextStyle(
                color: Secondary, fontWeight: FontWeight.bold, fontSize: 25),
          ),
          SizedBox(
            height: 8,
          ),
          Text(
            "${user.member.dob.day}/${user.member.dob.month}/${user.member.dob.year}",
            style: TextStyle(
                color: Secondary, fontWeight: FontWeight.bold, fontSize: 25),
          ),
          SizedBox(
            height: 8,
          ),
          Text(
            user.member.description,
            style: TextStyle(color: Success, fontSize: 20),
          ),
          SizedBox(
            height: 6,
          ),
          Container(
            width: MediaQuery.of(context).size.width * 0.78,
            child: Text(
              user.member.description,
              style: TextStyle(color: Secondary, fontSize: 20),
              softWrap: true,
            ),
          ),
          SizedBox(
            height: 6,
          ),
        ],
      ),
    );
  }
}

class GroupInviteSelection extends StatefulWidget {
  const GroupInviteSelection({Key key}) : super(key: key);

  @override
  _GroupSelectionState createState() => _GroupSelectionState();
}

class _GroupSelectionState extends State<GroupInviteSelection> {
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.only(left: 20, right: 20, top: 60, bottom: 100),
      child: Container(
        padding: EdgeInsets.only(top: 10, bottom: 30),
        decoration: BoxDecoration(boxShadow: [
          BoxShadow(
              offset: Offset.fromDirection(0),
              color: Colors.white,
              blurRadius: 0.5,
              spreadRadius: 0.5),
          BoxShadow(
              color: Colors.white,
              offset: Offset.fromDirection(1),
              blurRadius: 0.5,
              spreadRadius: 0.5)
        ], color: Secondary, borderRadius: BorderRadius.circular(10)),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                height: 80,
              ),
              Center(
                child: Text("Mời thành viên mới",
                    style: TextStyle(
                        fontFamily: "Arial",
                        color: Colors.black,
                        decoration: TextDecoration.none,
                        fontSize: 25,
                        fontWeight: FontWeight.bold)),
              ),
              SizedBox(
                height: 10,
              ),
              Padding(
                padding: const EdgeInsets.only(left: 8.0),
                child: Text("Số lượng (3)",
                    style: TextStyle(
                        fontFamily: "Arial",
                        color: Colors.black,
                        decoration: TextDecoration.none,
                        fontSize: 15,
                        fontWeight: FontWeight.bold)),
              ),
              SizedBox(
                height: 15,
              ),
              Padding(
                padding: const EdgeInsets.all(10.0),
                child: Container(
                  decoration: BoxDecoration(boxShadow: [
                    BoxShadow(
                      color: Default.withOpacity(0.3),
                      spreadRadius: 2,
                      blurRadius: 2,
                      offset: Offset(0, 3), // changes position of shadow
                    ),
                  ], color: Secondary, borderRadius: BorderRadius.circular(10)),
                  height: 70,
                  padding: EdgeInsets.only(left: 30, right: 15),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text("Nhóm học HCI",
                          style: TextStyle(
                              fontFamily: "Arial",
                              color: Colors.black,
                              decoration: TextDecoration.none,
                              fontSize: 15,
                              fontWeight: FontWeight.w500)),
                      Icon(Icons.check_box)
                    ],
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(10.0),
                child: Container(
                  decoration: BoxDecoration(boxShadow: [
                    BoxShadow(
                      color: Default.withOpacity(0.3),
                      spreadRadius: 2,
                      blurRadius: 2,
                      offset: Offset(0, 3), // changes position of shadow
                    ),
                  ], color: Secondary, borderRadius: BorderRadius.circular(10)),
                  height: 70,
                  padding: EdgeInsets.only(left: 30, right: 15),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text("Nhóm học Mobile",
                          style: TextStyle(
                              fontFamily: "Arial",
                              color: Colors.black,
                              decoration: TextDecoration.none,
                              fontSize: 15,
                              fontWeight: FontWeight.w500)),
                      Icon(Icons.check_box_outline_blank)
                    ],
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(10.0),
                child: Container(
                  decoration: BoxDecoration(boxShadow: [
                    BoxShadow(
                      color: Default.withOpacity(0.3),
                      spreadRadius: 2,
                      blurRadius: 2,
                      offset: Offset(0, 3), // changes position of shadow
                    ),
                  ], color: Secondary, borderRadius: BorderRadius.circular(10)),
                  height: 70,
                  padding: EdgeInsets.only(left: 30, right: 15),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text("Nhóm học C#",
                          style: TextStyle(
                              fontFamily: "Arial",
                              color: Colors.black,
                              decoration: TextDecoration.none,
                              fontSize: 15,
                              fontWeight: FontWeight.w500)),
                      Icon(Icons.check_box)
                    ],
                  ),
                ),
              ),
              SizedBox(
                height: 15,
              )
            ],
          ),
        ),
      ),
    );
  }
}
