import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';

class NotificationProvider {
  Future<void> notificationMakeRead(String userId, String notId) async {
    await FirebaseFirestore.instance
        .collection('users')
        .doc(userId)
        .collection("notification")
        .doc(notId)
        .update({"active": true});
  }
}
