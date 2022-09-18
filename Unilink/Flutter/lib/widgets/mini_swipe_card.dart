import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:unilink_flutter_app/constant/path_router.dart';
import 'package:unilink_flutter_app/pages/member_card_page.dart';
import 'package:unilink_flutter_app/utils/asset_icon.dart';
import 'package:unilink_flutter_app/view_model/swipe_card_view_model.dart';

class MiniSwipeCard extends StatefulWidget {
  const MiniSwipeCard({Key key}) : super(key: key);

  @override
  _MiniSwipeCardState createState() => _MiniSwipeCardState();
}

class _MiniSwipeCardState extends State<MiniSwipeCard> {
  List<Member> members = mock_member;
  // ignore: non_constant_identifier_names
  int selected_index = -1;
  SwipingDirection swipingDirection = SwipingDirection.None;
  @override
  Widget build(BuildContext context) {
    return Container(
        height: members.length != 0 ? 250 : 20,
        child: members.length != 0
            ? ListView.builder(
                scrollDirection: Axis.horizontal,
                itemCount: members.length,
                itemBuilder: (BuildContext context, int index) {
                  return _buildUser(members[index]);
                },
              )
            : Text("No more members"));
  }

  Widget _buildUser(Member member) {
    final userIndex = members.indexOf(member);
    final isUserInfocus = userIndex == selected_index;
    final size = MediaQuery.of(context).size;
    return Listener(
      onPointerMove: (pointerEvent) {
        final provider = Provider.of<FeedbackPosition>(context, listen: false);
        //print("Pointer Listener: ${pointerEvent.localDelta.dx}");
        setState(() {
          selected_index = userIndex;
        });
        provider.updatePosition(pointerEvent.localDelta.dx);
      },
      onPointerCancel: (_) {
        final provider = Provider.of<FeedbackPosition>(context, listen: false);
        swipingDirection = provider.swipingDirection;
        setState(() {
          selected_index = -1;
        });
        provider.resetPosition();
      },
      onPointerUp: (_) {
        final provider = Provider.of<FeedbackPosition>(context, listen: false);
        swipingDirection = provider.swipingDirection;
        setState(() {
          selected_index = -1;
        });
        provider.resetPosition();
      },
      child: Draggable(
        child: UserCard(
          member: member,
          isUserInFocus: isUserInfocus,
        ),
        feedback: Material(
          type: MaterialType.transparency,
          child: UserCard(
            member: member,
            isUserInFocus: isUserInfocus,
          ),
        ),
        childWhenDragging: Container(
          width: size.width * 0.5,
          height: size.height * 0.35,
        ),
        onDragEnd: (details) => onDragEnd(details, member),
      ),
    );
  }

  void onDragEnd(DraggableDetails details, Member member) {
    final minimumDrag = 100;
    //print("Drag Position: ${details.offset.dx}");
    if (details.offset.dx > minimumDrag) {
      member.isSwipedOff = true;
    } else if (details.offset.dx < -minimumDrag) {
      member.isLiked = true;
    }
    if (swipingDirection != SwipingDirection.None) {
      setState(() {
        selected_index = -1;
        members.remove(member);
        swipingDirection = SwipingDirection.None;
      });
    }
  }
}

// ignore: non_constant_identifier_names
final mock_member = [
  Member(
      name: "Nguyễn Quốc Vinh",
      age: 21,
      imgUrl: "avatar-vinh.jpg",
      skill: "C#, Java, Japanese"),
  Member(
      name: "Lê Minh Tuấn",
      age: 31,
      imgUrl: "avatar-tuan.jpg",
      skill: "English, Docker, Java"),
  Member(
      name: "Phạm Càn Long", age: 41, imgUrl: "avatar-long.jpg", skill: "Java"),
];

class Member {
  String name;
  String skill;
  int age;
  String imgUrl;
  bool isLiked;
  bool isSwipedOff;
  Member(
      {this.name,
      this.age,
      this.imgUrl,
      this.skill,
      this.isLiked = false,
      this.isSwipedOff = false});
}

class UserCard extends StatelessWidget {
  final Member member;
  final bool isUserInFocus;
  const UserCard({Key key, @required this.member, @required this.isUserInFocus})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<FeedbackPosition>(context);
    final swipingDirection = provider.swipingDirection;
    final size = MediaQuery.of(context).size;
    return Padding(
      padding: const EdgeInsets.all(15.0),
      child: Container(
        height: size.height * 0.35,
        width: size.width * 0.50,
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10.0),
            image: DecorationImage(
                image: AssetImage(getPathOfIcon(member.imgUrl)),
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
                    _buidUserInfo(member: member, context: context),
                    Padding(
                      padding: EdgeInsets.only(bottom: 16.0, left: 8.0),
                      child: InkWell(
                        child: Icon(Icons.info, color: Colors.white),
                        onTap: (() {
                          Navigator.of(context).pushNamed(OTHER_PROFILE_ROUTE);
                        }),
                      ),
                    )
                  ],
                ),
              ),
              if (isUserInFocus) buildLikeBadge(swipingDirection)
            ],
          ),
        ),
      ),
    );
  }

  Widget buildLikeBadge(SwipingDirection swipingDirection) {
    final isSwipingRight = swipingDirection == SwipingDirection.Right;
    final color = isSwipingRight ? Colors.green : Colors.pink;
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
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ),
      );
    }
  }

  Widget _buidUserInfo({@required Member member, BuildContext context}) {
    return Padding(
      padding: EdgeInsets.all(8.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            "${member.name}",
            style: TextStyle(
                color: Colors.white, fontWeight: FontWeight.bold, fontSize: 16),
          ),
          SizedBox(
            height: 4,
          ),
          Text(
            "${member.age} Tuổi",
            style: TextStyle(color: Colors.white, fontSize: 16),
          ),
          SizedBox(
            height: 4,
          ),
          Container(
            width: MediaQuery.of(context).size.width * 0.3,
            child: Text(
              member.skill,
              overflow: TextOverflow.ellipsis,
              style: TextStyle(color: Colors.white, fontSize: 15),
            ),
          ),
        ],
      ),
    );
  }
}
