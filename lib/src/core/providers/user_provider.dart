import 'dart:async';
import 'dart:typed_data';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:image_picker/image_picker.dart';
import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;
import 'package:pofel_app/src/core/models/login_models/user.dart';
import 'package:pofel_app/src/core/models/profile_model.dart';

class UserProvider {
  Future<UserModel> fetchUserData(String userUid) async {
    FirebaseFirestore firestore = FirebaseFirestore.instance;
    var query = await firestore.collection("users").doc(userUid).get();

    UserModel oldUser = UserModel.fromMap(query.data() as Map<String, dynamic>);

    var followersQuery = await firestore
        .collection("users")
        .doc(userUid)
        .collection("followers")
        .get();
    var followingQuery = await firestore
        .collection("users")
        .doc(userUid)
        .collection("following")
        .get();
    UserModel user = UserModel(
      uid: oldUser.uid,
      name: oldUser.name,
      photo: oldUser.photo,
      isPremium: oldUser.isPremium,
      followers: profilesFromList(followersQuery.docs),
      following: profilesFromList(followingQuery.docs),
    );

    return user;
  }

  Future<void> updateUserName(String userUid, newName) async {
    FirebaseFirestore firestore = FirebaseFirestore.instance;
    var query = await firestore
        .collection("users")
        .where("uid", isEqualTo: userUid)
        .get();
    QueryDocumentSnapshot doc = query.docs[0];
    var docRef = doc.reference;

    docRef.update({"name": newName});
  }

  Future<void> updateProfilePic(String userUid, XFile image) async {
    FirebaseFirestore firestore = FirebaseFirestore.instance;
    firebase_storage.FirebaseStorage storage =
        firebase_storage.FirebaseStorage.instance;

    var query = await firestore
        .collection("users")
        .where("uid", isEqualTo: userUid)
        .get();
    QueryDocumentSnapshot doc = query.docs[0];
    String documentId = doc.id;
    Uint8List bytes = await image.readAsBytes();

    Reference ref = storage.ref().child('profile_pics/$userUid.png');
    UploadTask uploadTask =
        ref.putData(bytes, SettableMetadata(contentType: 'image/png'));
    TaskSnapshot taskSnapshot =
        await uploadTask.whenComplete(() => print('image uploaded!'));

    String imageUrl = await taskSnapshot.ref.getDownloadURL();

    var docRef = doc.reference;

    docRef.update({"profile_pic": imageUrl});
  }

  Future<void> buyPremium(
    String userUid,
  ) async {
    FirebaseFirestore firestore = FirebaseFirestore.instance;
    await firestore
        .collection("users")
        .doc(userUid)
        .update({"isPremium": true, "premiumLevel": FieldValue.increment(1)});
  }
}
