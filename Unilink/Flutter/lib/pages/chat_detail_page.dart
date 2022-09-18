import 'dart:typed_data';

import 'package:agora_rtc_engine/rtc_engine.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:provider/provider.dart';
import 'package:unilink_flutter_app/constant/path_router.dart';
import 'package:unilink_flutter_app/models/create_message_image_model.dart';
import 'package:unilink_flutter_app/models/member_model.dart';
import 'package:unilink_flutter_app/models/message.dart';
import 'package:unilink_flutter_app/pages/call_page.dart';
import 'package:unilink_flutter_app/service/socket_service.dart';
import 'package:unilink_flutter_app/translate/vn.dart';
import 'package:unilink_flutter_app/utils/asset_icon.dart';
import 'package:unilink_flutter_app/utils/color.dart';
import 'package:unilink_flutter_app/utils/hex_color.dart';
import 'package:unilink_flutter_app/utils/spinner.dart';
import 'package:unilink_flutter_app/view_model/member_view_model.dart';
import 'package:unilink_flutter_app/view_model/message_view_model.dart';
import 'package:socket_io_client/socket_io_client.dart' as IO;
import 'package:unilink_flutter_app/view_model/party_view_model.dart';
import 'package:unilink_flutter_app/widgets/modal_image_message.dart';
import 'package:unilink_flutter_app/widgets/modal_image_picker.dart';

// ignore: must_be_immutable
class ChatDetailPage extends StatefulWidget {
  String routerBack = MAIN_ROUTE;
  ChatDetailPage({Key key, this.routerBack}) : super(key: key);
  @override
  _ChatDetailPageState createState() => _ChatDetailPageState();
}

class ChatMessage {
  String messageContent;
  String messageType;
  String avatar;
  String timeReceived;
  String nameOfPeople;

  ChatMessage(
      {@required this.messageContent,
      @required this.messageType,
      @required this.avatar,
      @required this.timeReceived,
      @required this.nameOfPeople});
}

class ChatReceivedObject {
  String avatar;
  String name;
  String
      chatType; //chatType = group will show name every receiver chating && private is not
  ChatReceivedObject(
      {@required this.avatar, @required this.name, @required this.chatType});
}

Future<void> _handleCameraAndMic(Permission permission) async {
  final status = await permission.request();
  print(status);
}

Future<void> onJoin(BuildContext context, String partyId) async {
  // update input validation
  await _handleCameraAndMic(Permission.camera);
  await _handleCameraAndMic(Permission.microphone);
  // push video page with given channel name
  await Navigator.push(
    context,
    MaterialPageRoute(
      builder: (context) => CallPage(
        role: ClientRole.Broadcaster,
        channelName: partyId,
      ),
    ),
  );
}

class _ChatDetailPageState extends State<ChatDetailPage> {
  SocketService socketService = new SocketService();
  ScrollController controller;
  final TextEditingController textEditingController = TextEditingController();
  String currentPartyId;
  String currentPartyMessageId;
  String currentUserId;
  MemberViewModel memberVM;
  PartyViewModel currentParty;
  bool loading = false;
  IO.Socket socket;
  int page = 1;
  Uint8List imageSend;
  onRouter(String path) => Navigator.of(context).pushNamed(path);
  int currentIndex = 0;
  ChatReceivedObject receivedObject = new ChatReceivedObject(
      avatar: "assets/icons/group_image.png",
      name: "Group HCI",
      chatType: "private");

  List<Message> messages = [];
  Future<void> connectServer() async {
    setState(() {
      loading = true;
    });
    Provider.of<MessageViewModel>(context, listen: false).messagOfGroup = [];
    var memberVMTemp =
        await Provider.of<MemberListViewModel>(context, listen: false)
            .getInforCurrentMember();
    var currentPartyIdTemp =
        Provider.of<PartyListViewModel>(context, listen: false)
            .currentParty
            .party
            .id;
    var currentPartyMessageIdTemp =
        await Provider.of<PartyListViewModel>(context, listen: false)
            .getPartyForMessage(currentPartyIdTemp);

    await Provider.of<MessageViewModel>(context, listen: false)
        .getGroupMessage(currentPartyMessageIdTemp, page);
    socket = socketService.connectGroup(currentPartyMessageIdTemp, context);
    setState(() {
      currentPartyMessageId = currentPartyMessageIdTemp;
      currentParty =
          Provider.of<PartyListViewModel>(context, listen: false).currentParty;
      currentPartyId = currentPartyIdTemp;
      memberVM = memberVMTemp;
      currentUserId =
          Provider.of<MemberListViewModel>(context, listen: false).identifier;
      loading = false;
    });
  }

  @override
  void dispose() {
    // TODO: implement dispose
    socketService.disconnect();
    super.dispose();
  }

  Future<void> loadImg() async {
    var xFile =
        Provider.of<MemberListViewModel>(context, listen: false).avatarUpdate;
    if (xFile != null) {
      CreateMessageImage createMessageImage = new CreateMessageImage(
          image: Provider.of<MemberListViewModel>(context, listen: false)
              .avatarUpdate,
          partyId: currentPartyId);
      setState(() {
        loading = true;
      });
      String imageURL =
          await Provider.of<MessageViewModel>(context, listen: false)
              .sendImage(createMessageImage);
      print(imageURL);
      var message = {
        "receiverId": currentPartyMessageId,
        "senderName": memberVM.fullName,
        "senderId": currentUserId,
        "content": imageURL
      };
      socket.emit('GROUP_MESSAGE', message);
      Provider.of<MessageViewModel>(context, listen: false)
          .addMessageToMessageOfGroup(Message.jsonFromInternal(message));
      Provider.of<MemberListViewModel>(context, listen: false).avatarUpdate =
          null;
      setState(() {
        loading = false;
      });
    }
  }

  Widget buildChatArea() {
    return Container(
      child: Row(
        children: <Widget>[
          Container(
              width: MediaQuery.of(context).size.width * 0.2,
              child: InkWell(
                onTap: () {
                  Provider.of<MemberListViewModel>(context, listen: false)
                      .avatarUpdate = null;
                  showDialog(
                      context: context,
                      builder: (context) {
                        return ModelImageMessagePicker(
                          callback: loadImg,
                        );
                      });
                },
                child: Icon(Icons.camera_alt_outlined),
              )),
          Container(
            width: MediaQuery.of(context).size.width * 0.6,
            child: TextField(
              controller: textEditingController,
            ),
          ),
          SizedBox(width: 10.0),
          FloatingActionButton(
            backgroundColor: PrimaryColor,
            onPressed: () {
              var message = {
                "receiverId": currentPartyMessageId,
                "senderName": memberVM.fullName,
                "senderId": currentUserId,
                "content": textEditingController.text
              };
              socket.emit('GROUP_MESSAGE', message);
              Provider.of<MessageViewModel>(context, listen: false)
                  .addMessageToMessageOfGroup(
                      Message.jsonFromInternal(message));
              textEditingController.text = '';
            },
            elevation: 0,
            child: Icon(Icons.send),
          ),
        ],
      ),
    );
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    connectServer();
    controller = new ScrollController();
    controller.addListener(() {
      if (controller.position.pixels == controller.position.minScrollExtent) {
        setState(() {
          page = page += 1;
        });
        getMoreMessage();
      }
    });
  }

  getMoreMessage() async {
    await Provider.of<MessageViewModel>(context, listen: false)
        .getGroupMessage(currentPartyMessageId, page);
  }

  @override
  Widget build(BuildContext context) {
    messages = Provider.of<MessageViewModel>(context).messagOfGroup;
    return Scaffold(
      body: Center(
          child: Container(
        child: Container(
          color: Colors.white,
          child: Column(
            children: [
              Container(
                child: Expanded(
                  child: !loading
                      ? ListView.builder(
                          controller: controller,
                          itemCount: messages.length,
                          itemBuilder: (context, i) {
                            return Container(
                              margin: EdgeInsets.all(10),
                              child: Row(
                                mainAxisAlignment:
                                    messages[i].senderId == currentUserId
                                        ? MainAxisAlignment.end
                                        : MainAxisAlignment.start,
                                children: [
                                  Container(
                                    padding: EdgeInsets.all(20),
                                    decoration: BoxDecoration(
                                        color: PrimaryColor,
                                        borderRadius:
                                            BorderRadius.circular(10)),
                                    child: Column(
                                      children: [
                                        Text(
                                          messages[i].senderName,
                                          style: TextStyle(
                                              fontWeight: FontWeight.bold),
                                        ),
                                        Container(
                                          margin: EdgeInsets.only(top: 10),
                                          child: messages[i]
                                                  .content
                                                  .contains("/api/v1/file")
                                              ? Image.network(
                                                  messages[i].content,
                                                  width: 200,
                                                  height: 200, loadingBuilder:
                                                      (BuildContext context,
                                                          Widget child,
                                                          ImageChunkEvent
                                                              loadingProgress) {
                                                  if (loadingProgress == null)
                                                    return child;
                                                  return Center(
                                                    child:
                                                        CircularProgressIndicator(
                                                      color: Colors.orange,
                                                      value: loadingProgress
                                                                  .expectedTotalBytes !=
                                                              null
                                                          ? loadingProgress
                                                                  .cumulativeBytesLoaded /
                                                              loadingProgress
                                                                  .expectedTotalBytes
                                                          : null,
                                                    ),
                                                  );
                                                })
                                              : Text(messages[i].content),
                                        )
                                      ],
                                    ),
                                  )
                                ],
                              ),
                            );
                          })
                      : Center(
                          child: CircularProgressIndicator(),
                        ),
                ),
              ),
              Column(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [buildChatArea()],
              ),
            ],
          ),
        ),
      )),
      appBar: AppBar(
        shape: Border(
            bottom: BorderSide(color: HexColor.fromHex("#CFCACA"), width: 1)),
        backgroundColor: Colors.white,
        elevation: 0.0,
        leading: Container(),
        bottom: PreferredSize(
          preferredSize: Size.fromHeight(50),
          child: Column(
            children: [
              Container(
                  padding: EdgeInsets.only(bottom: 10, right: 20),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(children: [
                        Container(
                          padding: EdgeInsets.only(top: 10),
                          child: Container(
                            child: Ink(
                              decoration: ShapeDecoration(
                                shape: CircleBorder(),
                              ),
                              child: IconButton(
                                onPressed: () {
                                  Navigator.of(context).pop();
                                },
                                color: Colors.white,
                                iconSize: 40,
                                icon: Image.asset(getPathOfIcon("back.png")),
                              ),
                            ),
                          ),
                        ),
                        // Padding(
                        //   padding: EdgeInsets.only(top: 10),
                        //   child: Container(
                        //     width: 50,
                        //     height: 50,
                        //     decoration: BoxDecoration(
                        //       shape: BoxShape.circle,
                        //       image: DecorationImage(
                        //           image: AssetImage(receivedObject.avatar),
                        //           fit: BoxFit.fill),
                        //     ),
                        //   ),
                        // ),
                        Container(
                            width: 80,
                            height: 80,
                            child: Icon(
                              Icons.group,
                              size: 60,
                              color: Colors.orange,
                            )),
                        Padding(
                          padding: EdgeInsets.only(top: 10, left: 10),
                          child: Text(
                            currentParty != null ? currentParty.party.name : "",
                            style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 20,
                                color: Colors.orange),
                          ),
                        )
                      ]),
                      Container(
                        decoration: BoxDecoration(
                            color: PrimaryColor,
                            borderRadius: BorderRadius.circular(10)),
                        padding: EdgeInsets.all(10),
                        child: Container(
                          width: 30,
                          height: 30,
                          child: InkWell(
                            child: Icon(
                              Icons.call,
                              size: 30,
                            ),
                            onTap: () async {
                              await onJoin(context, currentPartyId);
                            },
                          ),
                        ),
                      ),
                    ],
                  )),
            ],
          ),
        ),
      ),
    );
  }
}
