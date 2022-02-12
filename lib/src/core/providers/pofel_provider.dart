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
                  pofelId: "c",
                  signedUsers: [],
                  createdAt: doc["createdAt"].toDate(),
                );

                pofels.add(model);
              })
            });

    return pofels;
  }

  Future<void> joinPofel(String uid, joinId) async {
    FirebaseFirestore firestore = FirebaseFirestore.instance;

    QuerySnapshot querySnap = await FirebaseFirestore.instance
        .collection('active_pofels')
        .where('joinId', isEqualTo: joinId)
        .get();
    QueryDocumentSnapshot doc = querySnap.docs[0];
    DocumentReference docRef = doc.reference;

    Map<String, dynamic> signedUser =
        ({"uid": uid, "acceptedInvitation": true, "joinedOn": DateTime.now()});
    docRef.update({
      "signedUsers": FieldValue.arrayUnion([uid]),
    }).then((value) => print("pofel created"));

    docRef.collection("signedUsers").doc().set({
      "signedOn": DateTime.now(),
      "acceptedInvitation": true,
      "uid": uid,
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
    Map<String, dynamic> signedUser = ({
      "uid": adminUid,
      "acceptedInvitation": true,
      "joinedOn": DateTime.now()
    });
    await firestore.collection("active_pofels").doc(documentId).set({
      "name": name,
      "description": description,
      "createdAt": DateTime.now(),
      "dateFrom": dateFrom,
      "dateTo": dateTo,
      "pofelId": documentId,
      "adminUid": adminUid,
      "signedUsers": [adminUid],
    }).then((value) => print("pofel created"));

    firestore
        .collection("active_pofels")
        .doc(documentId)
        .collection("signedUsers")
        .doc()
        .set({
      "name": name,
      "signedOn": DateTime.now(),
      "acceptedInvitation": true,
      "uid": adminUid,
    }).then((value) => print("user added"));
  }
}
