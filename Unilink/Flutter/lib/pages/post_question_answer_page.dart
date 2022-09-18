import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:unilink_flutter_app/constant/path_router.dart';
import 'package:unilink_flutter_app/translate/vn.dart';
import 'package:unilink_flutter_app/utils/asset_icon.dart';
import 'package:unilink_flutter_app/utils/hex_color.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:unilink_flutter_app/utils/spinner.dart';
import 'package:unilink_flutter_app/view_model/member_view_model.dart';
import 'package:unilink_flutter_app/view_model/post_view_model.dart';
import 'package:unilink_flutter_app/view_model/skill_view_model.dart';
import 'package:unilink_flutter_app/widgets/model_comment.dart';
import 'package:unilink_flutter_app/widgets/model_create_post.dart';
import 'package:unilink_flutter_app/widgets/model_delete_post.dart';
import 'package:unilink_flutter_app/widgets/model_edit_post.dart';
import 'package:timeago/timeago.dart' as timeago;
import 'dart:async';

class PostQuestionAnswer extends StatefulWidget {
  @override
  _PostQuestionAnswerState createState() => _PostQuestionAnswerState();
}

class _PostQuestionAnswerState extends State<PostQuestionAnswer> {
  List<PostViewModel> listPost = <PostViewModel>[];
  showCreatePost() {
    showDialog(
        context: context,
        builder: (context) {
          return ModelCreatePost(
            callback: onRefresh,
          );
        });
  }

  showEditPost() {
    showDialog(
        context: context,
        builder: (context) {
          return ModelEditPost(callback: onRefresh);
        });
  }

  showDeletePost() {
    showDialog(
        context: context,
        builder: (context) {
          return ModelDeletePost(
            callback: onRefresh,
          );
        });
  }

  showCommentPost() {
    showDialog(
        context: context,
        builder: (context) {
          return ModelComment();
        });
  }

  void onRefresh() {
    setState(() {});
  }

  @override
  void initState() {
    super.initState();
  }

  Future<List<PostViewModel>> getPostList() async {
    return await Provider.of<PostListViewModel>(context, listen: false)
        .searchPost("", "0", "0", "CreateDate", "dsc");
  }

  Future<Null> refreshList() async {
    await Future.delayed(Duration(seconds: 2));
    List<PostViewModel> listRefresh =
        await Provider.of<PostListViewModel>(context, listen: false)
            .searchPost("", "0", "0", "CreateDate", "dsc");
    setState(() {
      listPost = listRefresh;
    });
    return null;
  }

  onRouter(String path) => Navigator.of(context).pushNamed(path);
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        shape: Border(
            bottom: BorderSide(color: HexColor.fromHex("#CFCACA"), width: 1)),
        backgroundColor: Colors.white,
        elevation: 0.0,
        leading: Container(),
        bottom: PreferredSize(
          preferredSize: Size.fromHeight(100),
          child: Column(
            children: [
              Container(
                alignment: Alignment.topLeft,
                margin: EdgeInsets.only(left: 10),
                child: Ink(
                  decoration: ShapeDecoration(
                    shape: CircleBorder(),
                  ),
                  child: IconButton(
                      onPressed: () {
                        Navigator.of(context).pop();
                      },
                      color: Colors.white,
                      iconSize: 35,
                      icon: Image.asset(getPathOfIcon("back.png"))),
                ),
              ),
              Padding(
                padding: EdgeInsets.only(right: 20, left: 20),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Padding(
                      padding: EdgeInsets.only(bottom: 10),
                      child: ElevatedButton(
                        onPressed: () {},
                        style: ButtonStyle(
                            padding:
                                MaterialStateProperty.resolveWith((states) {
                              return EdgeInsets.zero;
                            }),
                            shape: MaterialStateProperty.resolveWith((states) {
                              return RoundedRectangleBorder(
                                borderRadius: BorderRadius.only(
                                    topLeft: Radius.circular(50),
                                    bottomLeft: Radius.circular(50)),
                              );
                            }),
                            fixedSize:
                                MaterialStateProperty.all<Size>(Size(110, 90))),
                        child: Ink(
                          height: 90,
                          width: 110,
                          decoration: BoxDecoration(
                              color: HexColor.fromHex("#F9F0DB"),
                              borderRadius: BorderRadius.only(
                                  topLeft: Radius.circular(50),
                                  bottomLeft: Radius.circular(50))),
                          child: Container(
                            child: Column(children: [
                              Padding(
                                padding: const EdgeInsets.only(left: 20),
                                child: IconButton(
                                    onPressed: null,
                                    icon: Image.asset("assets/icons/post.png")),
                              ),
                              Padding(
                                padding: const EdgeInsets.only(top: 5, left: 2),
                                child: Text(LABEL_POST,
                                    style: TextStyle(
                                        color: Colors.black,
                                        fontSize: 20,
                                        shadows: [
                                          Shadow(
                                            offset: Offset(1.5, 1.5),
                                            blurRadius: 3.0,
                                            color: Color.fromARGB(0, 0, 0, 0),
                                          ),
                                        ])),
                              ),
                            ]),
                          ),
                        ),
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.only(bottom: 10),
                      child: ElevatedButton(
                        onPressed: () {
                          return showCreatePost();
                        },
                        style: ButtonStyle(
                            padding:
                                MaterialStateProperty.resolveWith((states) {
                              return EdgeInsets.zero;
                            }),
                            fixedSize:
                                MaterialStateProperty.all<Size>(Size(110, 90))),
                        child: Ink(
                          height: 90,
                          width: 110,
                          decoration: BoxDecoration(
                            color: HexColor.fromHex("#ffffff"),
                          ),
                          child: Container(
                            padding: EdgeInsets.only(bottom: 10),
                            child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Padding(
                                    padding: const EdgeInsets.only(left: 0),
                                    child: IconButton(
                                        onPressed: () {
                                          return showCreatePost();
                                        },
                                        icon: Image.asset(
                                            "assets/icons/create-new.png")),
                                  ),
                                  Padding(
                                    padding:
                                        const EdgeInsets.only(top: 5, left: 2),
                                    child: Text(LABEL_CREATE,
                                        style: TextStyle(
                                            color: Colors.black,
                                            fontSize: 20,
                                            shadows: [
                                              Shadow(
                                                offset: Offset(1.5, 1.5),
                                                blurRadius: 3.0,
                                                color:
                                                    Color.fromARGB(0, 0, 0, 0),
                                              ),
                                            ])),
                                  ),
                                ]),
                          ),
                        ),
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.only(bottom: 10),
                      child: ElevatedButton(
                        onPressed: () {},
                        style: ButtonStyle(
                            padding:
                                MaterialStateProperty.resolveWith((states) {
                              return EdgeInsets.zero;
                            }),
                            shape: MaterialStateProperty.resolveWith((states) {
                              return RoundedRectangleBorder(
                                borderRadius: BorderRadius.only(
                                    topRight: Radius.circular(50),
                                    bottomRight: Radius.circular(50)),
                              );
                            }),
                            fixedSize:
                                MaterialStateProperty.all<Size>(Size(110, 90))),
                        child: Ink(
                          height: 90,
                          width: 110,
                          decoration: BoxDecoration(
                              color: HexColor.fromHex("#CAFBCF"),
                              borderRadius: BorderRadius.only(
                                  topRight: Radius.circular(50),
                                  bottomRight: Radius.circular(50))),
                          child: Container(
                            child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Padding(
                                    padding: const EdgeInsets.only(top: 0),
                                    child: IconButton(
                                        onPressed: () {},
                                        icon: Image.asset(
                                            "assets/icons/question-answer.png")),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.only(top: 0),
                                    child: Text(LABEL_QUESTION_ANSWER,
                                        style: TextStyle(
                                            color: Colors.black,
                                            fontSize: 20,
                                            shadows: [
                                              Shadow(
                                                offset: Offset(1.5, 1.5),
                                                blurRadius: 5.0,
                                                color:
                                                    Color.fromARGB(0, 0, 0, 0),
                                              ),
                                            ])),
                                  ),
                                ]),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
      body: Center(
        child: RefreshIndicator(
          onRefresh: refreshList,
          child: Spinner.spinnerWithFuture(getPostList(), (data) {
            listPost = data;
            if (listPost.length == 0)
              return Container(
                child: StaggeredGridView.countBuilder(
                  crossAxisCount: 1,
                  itemCount: 1,
                  itemBuilder: (BuildContext context, int index) => Card(
                    margin: const EdgeInsets.all(10.0),
                    child: Container(
                      alignment: Alignment.center,
                      child: Text(
                        "List is empty",
                        style: TextStyle(fontSize: 20),
                      ),
                    ),
                  ),
                  staggeredTileBuilder: (int index) => StaggeredTile.fit(1),
                ),
              );
            return Container(
              child: StaggeredGridView.countBuilder(
                crossAxisCount: 1,
                itemCount: listPost.length,
                itemBuilder: (BuildContext context, int index) => Card(
                    margin: const EdgeInsets.all(10.0),
                    child: Container(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          Container(
                            color: HexColor.fromHex("#CAFBCF"),
                            // height: 100,
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Padding(
                                  padding: const EdgeInsets.only(
                                      left: 8.0, top: 8.0),
                                  child: Container(
                                    padding:
                                        EdgeInsets.only(right: 30, left: 10),
                                    color: HexColor.fromHex("#CAFBCF"),
                                    height: 85,
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          children: [
                                            Padding(
                                              padding:
                                                  const EdgeInsets.only(top: 5),
                                              child: Container(
                                                width: 50,
                                                height: 100,
                                                decoration: BoxDecoration(
                                                  shape: BoxShape.circle,
                                                  image: DecorationImage(
                                                    image: (listPost[index]
                                                                    .member
                                                                    .avatar !=
                                                                null ||
                                                            listPost[index] !=
                                                                "")
                                                        ? NetworkImage(
                                                            listPost[index]
                                                                .member
                                                                .avatar)
                                                        : AssetImage(
                                                            "assets/icons/user-1.png"),
                                                    // image: AssetImage(
                                                    //     "assets/icons/avatar-vinh.jpg"),
                                                  ),
                                                ),
                                              ),
                                            ),
                                            Padding(
                                              padding: const EdgeInsets.only(
                                                  top: 10, left: 20),
                                              child: Text(
                                                "${listPost[index].member.firstName} ${listPost[index].member.lastName}\n${timeago.format(listPost[index].post.createDate)}",
                                                // LABEL_20_MINUTES_AGO,
                                                style: TextStyle(
                                                    fontWeight: FontWeight.bold,
                                                    fontSize: 15),
                                              ),
                                            ),
                                          ],
                                        ),
                                        Container(
                                          child: Row(
                                            children: [
                                              Container(
                                                padding: EdgeInsets.all(5),
                                                child: InkWell(
                                                    onTap: () {
                                                      Provider.of<PostListViewModel>(
                                                              context,
                                                              listen: false)
                                                          .setUpdateId(
                                                              listPost[index]
                                                                  .post
                                                                  .id);
                                                      Provider.of<PostListViewModel>(
                                                                  context,
                                                                  listen: false)
                                                              .postName =
                                                          listPost[index]
                                                              .post
                                                              .title;
                                                      Provider.of<PostListViewModel>(
                                                                  context,
                                                                  listen: false)
                                                              .description =
                                                          listPost[index]
                                                              .post
                                                              .content;
                                                      return showEditPost();
                                                    },
                                                    child: Icon(Icons.edit)),
                                              ),
                                              Container(
                                                padding: EdgeInsets.all(5),
                                                child: InkWell(
                                                  onTap: () {
                                                    Provider.of<PostListViewModel>(
                                                            context,
                                                            listen: false)
                                                        .setUpdateId(
                                                            listPost[index]
                                                                .post
                                                                .id);
                                                    return showDeletePost();
                                                  },
                                                  child: Icon(Icons.delete),
                                                ),
                                              )
                                            ],
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.only(top: 20, left: 8.0),
                            child: Column(
                              children: <Widget>[
                                Align(
                                  alignment: Alignment.centerLeft,
                                  child: Container(
                                    child: Text(
                                      // post.title,
                                      listPost[index].post.title,
                                      style: TextStyle(
                                          fontWeight: FontWeight.bold),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.only(top: 20, left: 8.0),
                            child: Column(
                              children: <Widget>[
                                Align(
                                  alignment: Alignment.centerLeft,
                                  child: Container(
                                    width: 150,
                                    height: 150,
                                    // decoration: BoxDecoration(
                                    //   image: DecorationImage(
                                    //     image: AssetImage(
                                    //         "assets/icons/avatar-vinh.jpg"),
                                    //   ),
                                    // ),
                                    // color: Colors.red,
                                    child: Text(
                                      listPost[index].post.content,
                                      style: TextStyle(
                                          fontWeight: FontWeight.bold),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                          Container(
                            child: InkWell(
                              child: Padding(
                                padding:
                                    const EdgeInsets.only(top: 20, left: 8.0),
                                child: Column(
                                  children: <Widget>[
                                    Align(
                                      alignment: Alignment.centerRight,
                                      child: Column(
                                        // color: Colors.red,
                                        children: [
                                          Text(LABEL_NUMBER_COMMENT,
                                              style: TextStyle(
                                                fontSize: 12,
                                              )),
                                          Padding(
                                            padding: const EdgeInsets.only(
                                                left: 30,
                                                bottom: 50,
                                                right: 10),
                                            child: Container(
                                                height: 50,
                                                width: 150,
                                                decoration: BoxDecoration(
                                                  border: Border.all(
                                                    color: Colors.black,
                                                  ),
                                                  borderRadius:
                                                      BorderRadius.circular(
                                                          10.0),
                                                ),
                                                child: InkWell(
                                                  onTap: () {
                                                    return showCommentPost();
                                                  },
                                                  child: Padding(
                                                    padding:
                                                        const EdgeInsets.only(
                                                            left: 20.0),
                                                    child: Row(
                                                      children: [
                                                        Image.asset(
                                                          "assets/icons/comment.png",
                                                        ),
                                                        Padding(
                                                          padding:
                                                              const EdgeInsets
                                                                      .only(
                                                                  left: 5.0),
                                                          child: Text(
                                                              LABEL_COMMENT,
                                                              style: TextStyle(
                                                                  fontSize: 15,
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .bold)),
                                                        ),
                                                      ],
                                                    ),
                                                  ),
                                                )),
                                          )
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          )
                        ],
                      ),
                    )),
                staggeredTileBuilder: (int index) => StaggeredTile.fit(1),
              ),
            );
          }),
        ),
      ),
    );
  }
}
