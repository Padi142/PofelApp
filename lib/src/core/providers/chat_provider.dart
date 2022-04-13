import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:pofel_app/src/core/models/login_models/user.dart';
import 'package:pofel_app/src/core/models/message_model.dart';

class ChatProvider {
  Future<List<MessageModel>> fetchFirstMessages(String pofelId) async {
    FirebaseFirestore firestore = FirebaseFirestore.instance;
    List<MessageModel> messages = [];
    var query = await firestore
        .collection("active_pofels")
        .doc(pofelId)
        .collection("chat")
        .orderBy("sentOn")
        .limit(20)
        .get()
        .then((querySnapshot) => {
              // ignore: avoid_function_literals_in_foreach_calls
              querySnapshot.docs.forEach((doc) {
                MessageModel message = MessageModel.fromMap(doc);
                messages.add(message);
              })
            });
    return messages;
  }

  Future<void> sendMessage(MessageModel message, String pofelId) async {
    FirebaseFirestore firestore = FirebaseFirestore.instance;
    await firestore
        .collection("active_pofels")
        .doc(pofelId)
        .collection("chat")
        .add({
      "message": message.message,
      "sentByName": message.sentByName,
      "sentByUid": message.sentByUid,
      "sentByProfilePic": message.sentByProfilePic,
      "sentOn": message.sentOn,
    });
  }
}
