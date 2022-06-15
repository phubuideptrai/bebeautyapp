import 'package:cloud_firestore/cloud_firestore.dart';

class ChatServices {
  // Create Chat Room Collection in FireStore
  Future<void> createChatRoom(chatRoomId) async {
    return await FirebaseFirestore.instance
        .collection("ChatRoom")
        .doc(chatRoomId)
        .set({
      'chatRoomID': chatRoomId,
      'latestMessage': "",
      'latestMessageTime': 0,
      'isSeenByAdmin': false,
      'latestMessageSendBy': ""
    }).catchError((e) {
      print(e);
    });
  }

  Future<void> addMessage(chatRoomId, chatMessageData, message, time,
      isSeenByAdmin, idSender, isAdmin) async {
    FirebaseFirestore.instance
        .collection("ChatRoom")
        .doc(chatRoomId)
        .collection("Chat")
        .add(chatMessageData)
        .catchError((e) {
      print(e.toString());
    });

    FirebaseFirestore.instance.collection("ChatRoom").doc(chatRoomId).update({
      'isSeenByAdmin': isSeenByAdmin,
      'latestMessage': message,
      'latestMessageTime': time,
      'latestMessageSendBy': idSender
    }).catchError((e) {
      print(e.toString());
    });
  }

  seen(String chatRoomId) async {
    return FirebaseFirestore.instance
        .collection("ChatRoom")
        .doc(chatRoomId)
        .update({'isSeenByAdmin': true}).catchError((e) {
      print(e.toString());
    });
  }

  getChats(String chatRoomId) async {
    return FirebaseFirestore.instance
        .collection("ChatRoom")
        .doc(chatRoomId)
        .collection("Chat")
        .orderBy('time')
        .snapshots();
  }

  Future<String> getFirstMesageUserID(String chatRoomId) async =>
      FirebaseFirestore.instance
          .collection("ChatRoom")
          .doc(chatRoomId)
          .collection("Chat")
          .orderBy('time')
          .get()
          .then(((result) {
        String id = "";
        id = result.docs[0].get("sendBy");
        return id;
      }));

  getChatRooms() async {
    return FirebaseFirestore.instance
        .collection("ChatRoom")
        .orderBy('latestMessageTime', descending: true)
        .snapshots();
  }

  searchByName(String searchField) {

    print(searchField);
    return FirebaseFirestore.instance
        .collection("Users")
        .where('displayName', isEqualTo: searchField)
        .get();
  }

  getUsers() async {
    return FirebaseFirestore.instance.collection("Users").get();
  }
}
