import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:pofel_app/src/core/models/profile_model.dart';

class SocialProvider {
  Future<void> follow(String currentUserId, String userId) async {
    await FirebaseFirestore.instance
        .collection('users')
        .doc(userId)
        .collection("followers")
        .doc(currentUserId)
        .set({"followedOn": DateTime.now(), "uid": currentUserId});

    await FirebaseFirestore.instance
        .collection('users')
        .doc(currentUserId)
        .collection("following")
        .doc(userId)
        .set({"followedOn": DateTime.now(), "uid": userId});
  }

  Future<List<ProfileModel>> search(String query) async {
    var getQuery = await FirebaseFirestore.instance
        .collection('users')
        .where("name", isGreaterThanOrEqualTo: query, isLessThan: query + 'z')
        .limit(10)
        .get();

    return profilesFromList(getQuery.docs);
  }

  Future<List<ProfileModel>> myFollowing(String uid) async {
    var getQuery = await FirebaseFirestore.instance
        .collection('users')
        .doc(uid)
        .collection("following")
        .get();

    return profilesFromList(getQuery.docs);
  }

  Future<bool> isFollowing(String uid, followeUid) async {
    var getQuery = await FirebaseFirestore.instance
        .collection('users')
        .doc(uid)
        .collection("following")
        .doc(followeUid)
        .get();

    if (getQuery.data() != null) {
      return true;
    } else {
      return false;
    }
  }
}
