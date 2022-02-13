import 'dart:async';
import 'dart:math';

import 'package:cloud_firestore/cloud_firestore.dart';
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
                  pofelId: doc["pofelId"],
                  signedUsers: [],
                  createdAt: doc["createdAt"].toDate(),
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
                  signedUsers: pofelUsersFromList(doc["signedUsersList"]),
                  createdAt: doc["createdAt"].toDate(),
                );

                pofels.add(model);
              })
            });

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

    Map<String, dynamic> signedUserMap = ({
      "name": userDoc["name"],
      "uid": userDoc["uid"],
      "profile_pic": userDoc["profile_pic"],
      "acceptedInvitation": true,
      "signedOn": DateTime.now()
    });

    Map<String, dynamic> signedUser =
        ({"uid": uid, "acceptedInvitation": true, "joinedOn": DateTime.now()});
    docRef.update({
      "signedUsers": FieldValue.arrayUnion([uid]),
      "signedUsersList": FieldValue.arrayUnion([signedUserMap])
    }).then((value) => print("pofel created"));
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
    Map<String, dynamic> signedUser = ({
      "name": name,
      "uid": adminUid,
      "acceptedInvitation": true,
      "signedOn": DateTime.now()
    });
    await firestore.collection("active_pofels").doc(documentId).set({
      "name": name,
      "description": description,
      "createdAt": DateTime.now(),
      "dateFrom": dateFrom,
      "dateTo": dateTo,
      "pofelId": documentId,
      "adminUid": adminUid,
      //"signedUsersList": [signedUser],
      "signedUsers": [adminUid],
    }).then((value) => print("pofel created"));
  }
}
