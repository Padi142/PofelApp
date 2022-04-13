import 'dart:async';
import 'dart:math';
import 'dart:typed_data';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:image_picker/image_picker.dart';
import 'package:pofel_app/src/core/models/pofel_image_model.dart';
import 'package:pofel_app/src/core/models/pofel_model.dart';
import 'package:pofel_app/src/core/models/pofel_user.dart';

class PofelProvider {
  Future<List<PofelModel>> fetchPofels(String userUid) async {
    List<PofelModel> pofels = [];
    FirebaseFirestore firestore = FirebaseFirestore.instance;
    DateTime sortDate = DateTime.now();
    sortDate = sortDate.subtract(const Duration(days: 4));
    await firestore
        .collection("active_pofels")
        .where("signedUsers", arrayContains: userUid)
        .where("dateFrom", isGreaterThan: sortDate)
        .get()
        .then((querySnapshot) => {
              // ignore: avoid_function_literals_in_foreach_calls
              querySnapshot.docs.forEach((doc) {
                PofelModel model = PofelModel(
                  name: doc["name"],
                  description: doc["description"],
                  adminUid: doc["adminUid"],
                  dateFrom: doc["dateFrom"].toDate(),
                  dateTo: doc["dateTo"].toDate(),
                  joinCode: doc["joinId"],
                  spotifyLink: doc["spotifyLink"],
                  pofelId: doc["pofelId"],
                  signedUsers: [],
                  createdAt: doc["createdAt"].toDate(),
                  pofelLocation: doc["pofelLocation"],
                  showDrugItems: doc["showDrugItems"] ?? false,
                  isPremium: doc["isPremium"] ?? false,
                  photos: [],
                );

                pofels.add(model);
              })
            });

    return pofels;
  }

  Future<List<PofelModel>> fetchPublicPofels(String userUid) async {
    List<PofelModel> pofels = [];
    FirebaseFirestore firestore = FirebaseFirestore.instance;
    DateTime sortDate = DateTime.now();
    sortDate = sortDate.subtract(const Duration(days: 4));
    await firestore
        .collection("active_pofels")
        .where("isPublic", isEqualTo: true)
        .where("dateFrom", isGreaterThan: sortDate)
        .get()
        .then((querySnapshot) => {
              // ignore: avoid_function_literals_in_foreach_calls
              querySnapshot.docs.forEach((doc) {
                PofelModel model = PofelModel(
                  name: doc["name"],
                  description: doc["description"],
                  adminUid: doc["adminUid"],
                  dateFrom: doc["dateFrom"].toDate(),
                  dateTo: doc["dateTo"].toDate(),
                  joinCode: doc["joinId"],
                  spotifyLink: doc["spotifyLink"],
                  pofelId: doc["pofelId"],
                  signedUsers: [],
                  createdAt: doc["createdAt"].toDate(),
                  pofelLocation: doc["pofelLocation"],
                  showDrugItems: doc["showDrugItems"] ?? false,
                  isPremium: doc["isPremium"] ?? false,
                  photos: [],
                );

                pofels.add(model);
              })
            });

    return pofels;
  }

  Future<List<PofelModel>> fetchPastPofels(String userUid) async {
    List<PofelModel> pofels = [];
    FirebaseFirestore firestore = FirebaseFirestore.instance;
    DateTime sortDate = DateTime.now();
    sortDate = sortDate.subtract(const Duration(days: 4));
    await firestore
        .collection("active_pofels")
        .where("signedUsers", arrayContains: userUid)
        .where("dateFrom", isLessThan: sortDate)
        .get()
        .then((querySnapshot) => {
              // ignore: avoid_function_literals_in_foreach_calls
              querySnapshot.docs.forEach((doc) {
                PofelModel model = PofelModel(
                  name: doc["name"],
                  description: doc["description"],
                  adminUid: doc["adminUid"],
                  dateFrom: doc["dateFrom"].toDate(),
                  dateTo: doc["dateTo"].toDate(),
                  joinCode: doc["joinId"],
                  spotifyLink: doc["spotifyLink"],
                  pofelId: doc["pofelId"],
                  signedUsers: [],
                  createdAt: doc["createdAt"].toDate(),
                  pofelLocation: doc["pofelLocation"],
                  showDrugItems: doc["showDrugItems"] ?? false,
                  isPremium: doc["isPremium"] ?? false,
                  photos: [],
                );

                pofels.add(model);
              })
            });

    return pofels;
  }

  Future<PofelModel> getPofel(String pofelId) async {
    List<PofelModel> pofels = [];
    FirebaseFirestore firestore = FirebaseFirestore.instance;
    await firestore
        .collection("active_pofels")
        .where("pofelId", isEqualTo: pofelId)
        .get()
        .then((querySnapshot) => {
              // ignore: avoid_function_literals_in_foreach_calls
              querySnapshot.docs.forEach((doc) {
                PofelModel model = PofelModel(
                  name: doc["name"],
                  description: doc["description"],
                  adminUid: doc["adminUid"],
                  dateFrom: doc["dateFrom"].toDate(),
                  dateTo: doc["dateTo"].toDate(),
                  joinCode: doc["joinId"],
                  pofelId: doc["pofelId"],
                  spotifyLink: doc["spotifyLink"],
                  signedUsers: [],
                  createdAt: doc["createdAt"].toDate(),
                  pofelLocation: doc["pofelLocation"],
                  showDrugItems: doc["showDrugItems"] ?? false,
                  isPremium: doc["isPremium"] ?? false,
                  photos: [],
                );
                pofels.add(model);
              })
            });
    var snapshot = await firestore
        .collection("active_pofels")
        .doc(pofelId)
        .collection("signedUsers")
        .get();
    pofels[0].signedUsers = pofelUsersFromList(snapshot.docs);

    return pofels[0];
  }

  Future<PofelModel> getPofelByJoinId(String joinId) async {
    List<PofelModel> pofels = [];
    FirebaseFirestore firestore = FirebaseFirestore.instance;
    await firestore
        .collection("active_pofels")
        .where("joinId", isEqualTo: joinId)
        .get()
        .then((querySnapshot) => {
              // ignore: avoid_function_literals_in_foreach_calls
              querySnapshot.docs.forEach((doc) {
                PofelModel model = PofelModel(
                  name: doc["name"],
                  description: doc["description"],
                  adminUid: doc["adminUid"],
                  dateFrom: doc["dateFrom"].toDate(),
                  dateTo: doc["dateTo"].toDate(),
                  joinCode: doc["joinId"],
                  pofelId: doc["pofelId"],
                  spotifyLink: doc["spotifyLink"],
                  signedUsers: [],
                  createdAt: doc["createdAt"].toDate(),
                  pofelLocation: doc["pofelLocation"],
                  showDrugItems: doc["showDrugItems"] ?? false,
                  isPremium: doc["isPremium"] ?? false,
                  photos: [],
                );
                pofels.add(model);
              })
            });
    var snapshot = await firestore
        .collection("active_pofels")
        .doc(pofels[0].pofelId)
        .collection("signedUsers")
        .get();
    if (snapshot.docs.isNotEmpty) {
      pofels[0].signedUsers = pofelUsersFromList(snapshot.docs);
    }

    return pofels[0];
  }

  Future<String> joinPofel(String uid, joinId) async {
    FirebaseFirestore firestore = FirebaseFirestore.instance;

    QuerySnapshot pofelQuery = await FirebaseFirestore.instance
        .collection('active_pofels')
        .where('joinId', isEqualTo: joinId)
        .get();
    QuerySnapshot userQuery = await FirebaseFirestore.instance
        .collection('users')
        .where('uid', isEqualTo: uid)
        .get();

    QueryDocumentSnapshot pofelDoc = pofelQuery.docs[0];
    QueryDocumentSnapshot userDoc = userQuery.docs[0];
    DocumentReference docRef = pofelDoc.reference;
    try {
      // subscribe to topic on each app start-up
      await FirebaseMessaging.instance.subscribeToTopic(docRef.id);
      await FirebaseMessaging.instance.subscribeToTopic(docRef.id + "chat");
    } catch (e) {
      print(e);
    }
    var joinedUsers = pofelDoc["signedUsers"];
    bool canJoin = !joinedUsers.contains(uid);
    if (canJoin) {
      docRef.update({
        "signedUsers": FieldValue.arrayUnion([uid]),
      }).then((value) => print("pofel created"));

      docRef.collection("signedUsers").doc(uid).set({
        "name": userDoc["name"],
        "uid": userDoc["uid"],
        "profile_pic": userDoc["profile_pic"],
        "isPremium": userDoc["isPremium"],
        "acceptedInvitation": true,
        "signedOn": DateTime.now(),
        "willArrive": DateTime.utc(1989, 11, 9)
      }).then((value) => print("user added"));
      return "";
    } else {
      return "Retarde, nemůžeš se dvakrat připojit na stejný pofel";
    }
  }

  Future<void> createPofel(
      String name, description, adminUid, DateTime dateFrom, dateTo) async {
    const _chars =
        'AaBbCcDdEeFfGgHhIiJjKkLlMmNnOoPpQqRrSsTtUuVvWwXxYyZz1234567890';
    Random _rnd = Random();

    String getRandomString(int length) =>
        String.fromCharCodes(Iterable.generate(
            length, (_) => _chars.codeUnitAt(_rnd.nextInt(_chars.length))));

    String documentId = getRandomString(18);
    try {
      // subscribe to topic on each app start-up
      await FirebaseMessaging.instance.subscribeToTopic(documentId);
      await FirebaseMessaging.instance.subscribeToTopic(documentId + "chat");
    } catch (e) {
      print(e);
    }

    FirebaseFirestore firestore = FirebaseFirestore.instance;
    await firestore.collection("active_pofels").doc(documentId).set({
      "name": name,
      "description": description,
      "createdAt": DateTime.now(),
      "dateFrom": dateFrom,
      "dateTo": dateTo,
      "pofelLocation": const GeoPoint(0, 0),
      "pofelId": documentId,
      "spotifyLink": "",
      "adminUid": adminUid,
      "signedUsers": [adminUid],
      "isPremium": false,
      "showDrugItems": false
    }).then((value) => print("pofel created"));
    firestore
        .collection("active_pofels")
        .doc(documentId)
        .collection("signedUsers")
        .doc(adminUid)
        .set({
      "signedOn": DateTime.now(),
      "acceptedInvitation": true,
      "uid": adminUid,
    }).then((value) => print("user added"));
  }

  Future<void> updateName(String name, pofelId) async {
    await FirebaseFirestore.instance
        .collection('active_pofels')
        .doc(pofelId)
        .update({
      "name": name,
    }).then((value) => print("pofel created"));
  }

  Future<void> updateDesc(String desc, pofelId) async {
    await FirebaseFirestore.instance
        .collection('active_pofels')
        .doc(pofelId)
        .update({
      "description": desc,
    }).then((value) => print("pofel created"));
  }

  Future<void> updateDatefrom(String pofelId, DateTime newdate) async {
    await FirebaseFirestore.instance
        .collection('active_pofels')
        .doc(pofelId)
        .update({
      "dateFrom": newdate,
    }).then((value) => print("pofel created"));
  }

  Future<void> updateSpotifyLink(String pofelId, newLink) async {
    await FirebaseFirestore.instance
        .collection('active_pofels')
        .doc(pofelId)
        .update({
      "spotifyLink": newLink,
    }).then((value) => print("spotify updated"));
    ;
  }

  Future<void> updatePofelLocation(String pofelId, GeoPoint newLocation) async {
    await FirebaseFirestore.instance
        .collection('active_pofels')
        .doc(pofelId)
        .update({
      "pofelLocation": newLocation,
    }).then((value) => print("Location updated"));
  }

  Future<void> updateUserArrivalDate(
      String pofelId, uid, DateTime newdate) async {
    QuerySnapshot pofelQuery = await FirebaseFirestore.instance
        .collection('active_pofels')
        .doc(pofelId)
        .collection("signedUsers")
        .where("uid", isEqualTo: uid)
        .get();
    QueryDocumentSnapshot doc = pofelQuery.docs[0];
    DocumentReference docRef = doc.reference;

    docRef.update({
      "willArrive": newdate,
    }).then((value) => print("pofel created"));
  }

  Future<void> toggleShowDrug(String pofelId, bool showDrugs) async {
    await FirebaseFirestore.instance
        .collection('active_pofels')
        .doc(pofelId)
        .update({
      "showDrugItems": !showDrugs,
    }).then((value) => print("drugs toggled"));
  }

  Future<void> changeAdmin(String pofelId, String uid) async {
    await FirebaseFirestore.instance
        .collection('active_pofels')
        .doc(pofelId)
        .update({
      "adminUid": uid,
    }).then((value) => print("admin changed"));
  }

  Future<void> upgradePofel(String pofelId) async {
    await FirebaseFirestore.instance
        .collection('active_pofels')
        .doc(pofelId)
        .update({
      "isPremium": true,
    }).then((value) => print("admin changed"));
  }

  Future<void> leavePofel(String pofelId, uid) async {
    await FirebaseFirestore.instance
        .collection('active_pofels')
        .doc(pofelId)
        .update({
      "signedUsers": FieldValue.arrayRemove([uid]),
    }).then((value) => print("person removed"));

    await FirebaseFirestore.instance
        .collection('active_pofels')
        .doc(pofelId)
        .collection("signedUsers")
        .doc(uid)
        .delete();
  }

  //Deleting whole pofel
  Future<void> deletePofel(String pofelId) async {
    await FirebaseFirestore.instance
        .collection('active_pofels')
        .doc(pofelId)
        .collection("signedUsers")
        .get()
        .then((users) => {
              users.docs.forEach((user) {
                user.reference.delete();
              })
            });
    await FirebaseFirestore.instance
        .collection('active_pofels')
        .doc(pofelId)
        .collection("chat")
        .get()
        .then((chats) => {
              chats.docs.forEach((chat) {
                chat.reference.delete();
              })
            });
    await FirebaseFirestore.instance
        .collection('active_pofels')
        .doc(pofelId)
        .collection("items")
        .get()
        .then((items) => {
              items.docs.forEach((item) {
                item.reference.delete();
              })
            });
    await FirebaseFirestore.instance
        .collection('active_pofels')
        .doc(pofelId)
        .collection("photos")
        .get()
        .then((photos) => {
              photos.docs.forEach((photo) {
                photo.reference.delete();
              })
            });
    await FirebaseFirestore.instance
        .collection('active_pofels')
        .doc(pofelId)
        .collection("todo")
        .get()
        .then((todo) => {
              todo.docs.forEach((chat) {
                chat.reference.delete();
              })
            });
    await FirebaseFirestore.instance
        .collection('active_pofels')
        .doc(pofelId)
        .collection("chat")
        .get()
        .then((chats) => {
              chats.docs.forEach((chat) {
                chat.reference.delete();
              })
            });
    await FirebaseFirestore.instance
        .collection('active_pofels')
        .doc(pofelId)
        .delete()
        .then((value) => {print("Bye bye pofel :/ :-(")});
  }
}
