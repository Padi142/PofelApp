import 'dart:async';
import 'dart:typed_data';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:image_picker/image_picker.dart';
import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;
import 'package:pofel_app/src/core/models/item_model.dart';
import 'package:pofel_app/src/core/models/login_models/user.dart';
import 'package:pofel_app/src/core/models/pofel_model.dart';

class ItemsProvider {
  Future<List<ItemModel>> fetchPofelItems(String pofelId) async {
    FirebaseFirestore firestore = FirebaseFirestore.instance;
    QuerySnapshot itemsQuery = await FirebaseFirestore.instance
        .collection('active_pofels')
        .doc(pofelId)
        .collection("items")
        .get();

    List<ItemModel> items = pofelUsersFromList(itemsQuery.docs);
    return items;
  }

  Future<void> addItem(String pofelId, userUid, name, int count, double price,
      DateTime addedOn, ItemType itemType) async {
    await FirebaseFirestore.instance
        .collection('active_pofels')
        .doc(pofelId)
        .collection("items")
        .doc()
        .set({
      "name": name,
      "count": count,
      "addedByUid": userUid,
      "itemType": getStringFromType(itemType),
      "price": price,
      "addedOn": addedOn,
    });
  }

  Future<void> removeItem(String pofelId, DateTime createdAt) async {
    var query = await FirebaseFirestore.instance
        .collection('active_pofels')
        .doc(pofelId)
        .collection("items")
        .where("addedOn", isEqualTo: createdAt)
        .get();
    var doc = query.docs[0];
    var reference = doc.reference;
    reference.delete();
  }
}
