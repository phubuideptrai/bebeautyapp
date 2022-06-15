import 'package:bebeautyapp/constants.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:intl/intl.dart';

import '../../repo/services/chat_services.dart';

class Chat extends StatefulWidget {
  final String chatRoomId;
  final String user_id;
  final String user_name;

  Chat(
      {required this.chatRoomId,
      required this.user_id,
      required this.user_name});

  @override
  _ChatState createState() =>
      _ChatState(this.chatRoomId, this.user_id, this.user_name);
}

class _ChatState extends State<Chat> {
  Stream<QuerySnapshot>? chats;
  TextEditingController messageEditingController = new TextEditingController();
  String chatRoomId = "";
  String user_id = "";
  String user_name = "";

  final chatServices = new ChatServices();
  String latestMessageUserID = "";

  _ChatState(String chatRoomID, String userID, String userName) {
    this.chatRoomId = chatRoomID;
    this.user_id = userID;
    this.user_name = userName;
  }

  int Calculate(int a, int b) {
    DateTime notificationDate = DateTime.fromMillisecondsSinceEpoch(a);
    final date1 = DateTime.now();
    final diff = date1.difference(notificationDate);

    DateTime notificationDate1 = DateTime.fromMillisecondsSinceEpoch(b);
    final date2 = DateTime.now();
    final diff1 = date2.difference(notificationDate1);

    return diff.inMinutes - diff1.inMinutes;
  }

  Widget chatMessages() {
    String id = latestMessageUserID;

    String calculateTimeAgoSinceDate1(int time) {
      DateTime notificationDate = DateTime.fromMillisecondsSinceEpoch(time);
      final date2 = DateTime.now();
      final diff = date2.difference(notificationDate);

      if (diff.inDays > 7)
        return DateFormat("dd/MM/yyyy").format(notificationDate);
      else if (diff.inDays >= 2 && diff.inDays <= 7)
        return DateFormat('EEEE').format(notificationDate);
      else if (diff.inDays > 1 && diff.inDays < 2)
        return 'Yesterday';
      else
        return DateFormat("kk:mm a").format(notificationDate);
    }

    return StreamBuilder<QuerySnapshot>(
      stream: chats,
      builder: (context, snapshot) {
        return snapshot.hasData
            ? ListView.builder(
                physics: BouncingScrollPhysics(),
                itemCount: snapshot.data!.docs.length,
                itemBuilder: (context, index) {
                  bool isDisplayTime = false;
                  String timeBreakSection = "";
                  if (index == snapshot.data!.docs.length - 1) {
                    isDisplayTime = true;
                    timeBreakSection = "";
                  } else {
                    if (id == snapshot.data!.docs[index]["sendBy"] &&
                        id != snapshot.data!.docs[index + 1]["sendBy"]) {
                      isDisplayTime = true;
                      id = snapshot.data!.docs[index + 1]["sendBy"];
                    }
                    if (Calculate(snapshot.data!.docs[index]["time"],
                            snapshot.data!.docs[index + 1]["time"]) >
                        60) {
                      timeBreakSection = calculateTimeAgoSinceDate1(
                          snapshot.data!.docs[index + 1]["time"]);
                    }
                  }
                  return MessageTile(
                    message: snapshot.data!.docs[index]["message"],
                    sendByMe: user_id == snapshot.data!.docs[index]["sendBy"],
                    time: snapshot.data!.docs[index]["time"],
                    isDisplayTime: isDisplayTime,
                    timeBreakSection: timeBreakSection,
                  );
                })
            : Container();
      },
    );
  }

  addMessage() {
    if (messageEditingController.text.isNotEmpty) {
      int time = DateTime.now().millisecondsSinceEpoch;
      Map<String, dynamic> chatMessageMap = {
        "sendBy": user_id,
        "message": messageEditingController.text,
        'time': time,
      };

      chatServices.addMessage(widget.chatRoomId, chatMessageMap,
          messageEditingController.text, time, false, user_id, false);

      setState(() {
        messageEditingController.text = "";
      });
    } else {
      Fluttertoast.showToast(
          msg: 'Nothing to send!',
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.BOTTOM,
          backgroundColor: Colors.grey);
    }
  }

  @override
  void initState() {
    chatServices.getFirstMesageUserID(widget.chatRoomId);
    //  FirebaseFirestore.instance.collection("ChatRoom")
    //      .doc(chatRoomId)
    //      .collection("Chat")
    //      .orderBy('time')
    //      .get().then(((result) {
    //    String id = result.docs[0].get("sendBy");
    //    setState(() {
    //      latestMessageUserID = id;
    //    });
    //  }));

    chatServices.getChats(widget.chatRoomId).then((val) {
      setState(() {
        chats = val;
      });
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.white,
          title: kAppNameTextPinksm,
          centerTitle: true,
          elevation: 0,
        ),
        body: SingleChildScrollView(
          child: Container(
            height: MediaQuery.of(context).size.height - 135,
            child: Stack(
              children: <Widget>[
                Container(
                  height: MediaQuery.of(context).size.height - 100,
                  child: chatMessages(),
                ),
                Align(
                  alignment: Alignment.bottomLeft,
                  child: Container(
                    padding: EdgeInsets.only(left: 16, bottom: 10),
                    height: 70,
                    width: double.infinity,
                    color: Colors.white,
                    child: Row(
                      children: <Widget>[
                        Expanded(
                          child: TextField(
                            controller: messageEditingController,
                            decoration: InputDecoration(
                                hintText: "Type message...",
                                hintStyle:
                                    TextStyle(color: Colors.grey.shade500),
                                border: InputBorder.none),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                Align(
                  alignment: Alignment.bottomRight,
                  child: Container(
                    padding: EdgeInsets.only(right: 30, bottom: 40),
                    child: FloatingActionButton(
                      onPressed: () {
                        addMessage();
                      },
                      child: Icon(
                        Icons.send,
                        color: Colors.white,
                      ),
                      backgroundColor: kPrimaryColor,
                      elevation: 0,
                    ),
                  ),
                )
              ],
            ),
          ),
        ));
  }
}

class MessageTile extends StatelessWidget {
  final String message;
  final bool sendByMe;
  final int time;
  final bool isDisplayTime;
  final String timeBreakSection;

  MessageTile(
      {required this.message,
      required this.sendByMe,
      required this.time,
      required this.isDisplayTime,
      required this.timeBreakSection});

  String calculateTimeAgoSinceDate(int time) {
    DateTime notificationDate = DateTime.fromMillisecondsSinceEpoch(time);
    final date2 = DateTime.now();
    final diff = date2.difference(notificationDate);

    if (diff.inDays > 7)
      return DateFormat("kk:mm dd/MM/yyyy").format(notificationDate);
    else if (diff.inDays >= 2 && diff.inDays <= 7)
      return DateFormat('kk:mm a EEEE').format(notificationDate);
    else if (diff.inDays > 1 && diff.inDays < 2)
      return DateFormat("kk:mm a").format(notificationDate) + ' Yesterday';
    else
      return DateFormat("kk:mm a").format(notificationDate);
  }

  @override
  Widget build(BuildContext context) {
    String timeChat = calculateTimeAgoSinceDate(time);
    return Column(children: [
      Container(
          padding: EdgeInsets.only(
              top: 8,
              bottom: 8,
              left: sendByMe ? 0 : 24,
              right: sendByMe ? 24 : 0),
          alignment: sendByMe ? Alignment.bottomRight : Alignment.bottomLeft,
          child: Column(
            crossAxisAlignment:
                sendByMe ? CrossAxisAlignment.end : CrossAxisAlignment.start,
            children: [
              Container(
                margin: sendByMe
                    ? EdgeInsets.only(left: 30)
                    : EdgeInsets.only(right: 30),
                padding:
                    EdgeInsets.only(top: 17, bottom: 17, left: 20, right: 20),
                decoration: BoxDecoration(
                  borderRadius: sendByMe
                      ? BorderRadius.only(
                          topLeft: Radius.circular(23),
                          topRight: Radius.circular(23),
                          bottomLeft: Radius.circular(23))
                      : BorderRadius.only(
                          topLeft: Radius.circular(23),
                          topRight: Radius.circular(23),
                          bottomRight: Radius.circular(23)),
                  color: sendByMe ? Colors.white : kFourthColor,
                  boxShadow: [
                    BoxShadow(
                      color: Colors.grey.withOpacity(0.2),
                      spreadRadius: 2,
                      blurRadius: 3,
                      offset: Offset(0, 3),
                    ),
                  ],
                ),
                child: Text(message,
                    textAlign: TextAlign.start,
                    style: TextStyle(
                        color: Colors.black,
                        fontSize: 14,
                        fontWeight: FontWeight.w500)),
              ),
              SizedBox(
                height: 10,
              ),
              isDisplayTime
                  ? Container(
                      child: Text(
                        timeChat,
                        style: TextStyle(
                            color: Colors.grey,
                            fontSize: 12,
                            fontStyle: FontStyle.italic,
                            fontWeight: FontWeight.w600),
                      ),
                    )
                  : SizedBox(),
              SizedBox(
                height: 10,
              ),
            ],
          )),
      (timeBreakSection != "" && isDisplayTime)
          ? Container(
              height: 20,
              child: Center(
                  child: Text(
                timeBreakSection,
                style: TextStyle(
                    color: Colors.black,
                    fontSize: 12,
                    fontWeight: FontWeight.w600),
              )))
          : SizedBox(),
    ]);
  }
}
