import 'dart:async';
import 'dart:math';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:pofel_app/src/core/models/pofel_model.dart';
import 'package:pofel_app/src/core/models/pofel_user.dart';

class PofelProvider {
  Future<List<PofelModel>> fetchPofels(String userUid) async {
    List<PofelModel> pofels = [];
    FirebaseFirestore firestore = FirebaseFirestore.instance;
    await firestore
        .collection("active_pofels")
        .where("signedUsers", arrayContains: userUid)
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

  Future<void> joinPofel(String uid, joinId) async {
    FirebaseFirestore firestore = FirebaseFirestore.instance;

    QuerySnapshot pofelQuery = await FirebaseFirestore.instance
        .collection('active_pofels')
        .where('joinId', isEqualTo: joinId)
        .get();
    QuerySnapshot userQuery = await FirebaseFirestore.instance
        .collection('users')
        .where('uid', isEqualTo: uid)
        .get();

    QueryDocumentSnapshot doc = pofelQuery.docs[0];
    QueryDocumentSnapshot userDoc = userQuery.docs[0];
    DocumentReference docRef = doc.reference;

    docRef.update({
      "signedUsers": FieldValue.arrayUnion([uid]),
    }).then((value) => print("pofel created"));

    docRef.collection("signedUsers").doc(uid).set({
      "name": userDoc["name"],
      "uid": userDoc["uid"],
      "profile_pic": userDoc["profile_pic"],
      "acceptedInvitation": true,
      "signedOn": DateTime.now(),
      "willArrive": DateTime.utc(1989, 11, 9)
    }).then((value) => print("user added"));
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
    QuerySnapshot pofelQuery = await FirebaseFirestore.instance
        .collection('active_pofels')
        .where('pofelId', isEqualTo: pofelId)
        .get();
    QueryDocumentSnapshot doc = pofelQuery.docs[0];
    DocumentReference docRef = doc.reference;

    docRef.update({
      "name": name,
    }).then((value) => print("pofel created"));
  }

  Future<void> updateDesc(String desc, pofelId) async {
    QuerySnapshot pofelQuery = await FirebaseFirestore.instance
        .collection('active_pofels')
        .where('pofelId', isEqualTo: pofelId)
        .get();
    QueryDocumentSnapshot doc = pofelQuery.docs[0];
    DocumentReference docRef = doc.reference;

    docRef.update({
      "description": desc,
    }).then((value) => print("pofel created"));
  }

  Future<void> updateDatefrom(String pofelId, DateTime newdate) async {
    QuerySnapshot pofelQuery = await FirebaseFirestore.instance
        .collection('active_pofels')
        .where('pofelId', isEqualTo: pofelId)
        .get();
    QueryDocumentSnapshot doc = pofelQuery.docs[0];
    DocumentReference docRef = doc.reference;

    docRef.update({
      "dateFrom": newdate,
    }).then((value) => print("pofel created"));
  }

  Future<void> updateSpotifyLink(String pofelId, newLink) async {
    QuerySnapshot pofelQuery = await FirebaseFirestore.instance
        .collection('active_pofels')
        .where('pofelId', isEqualTo: pofelId)
        .get();
    QueryDocumentSnapshot doc = pofelQuery.docs[0];
    DocumentReference docRef = doc.reference;

    docRef.update({
      "spotifyLink": newLink,
    }).then((value) => print("spotify updated"));
  }

  Future<void> updatePofelLocation(String pofelId, GeoPoint newLocation) async {
    QuerySnapshot pofelQuery = await FirebaseFirestore.instance
        .collection('active_pofels')
        .where('pofelId', isEqualTo: pofelId)
        .get();
    QueryDocumentSnapshot doc = pofelQuery.docs[0];
    DocumentReference docRef = doc.reference;

    docRef.update({
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
}
