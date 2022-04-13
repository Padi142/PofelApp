import 'dart:async';
import 'dart:typed_data';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:image_picker/image_picker.dart';
import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;
import 'package:pofel_app/src/core/models/item_model.dart';
import 'package:pofel_app/src/core/models/login_models/user.dart';
import 'package:pofel_app/src/core/models/to_do_model.dart';

class TodoProvider {
  Future<List<TodoModel>> fetchTodos(String pofelId) async {
    FirebaseFirestore firestore = FirebaseFirestore.instance;
    QuerySnapshot itemsQuery = await FirebaseFirestore.instance
        .collection('active_pofels')
        .doc(pofelId)
        .collection("todo")
        .get();

    List<TodoModel> items = pofelTodosFromList(itemsQuery.docs);
    return items;
  }

  Future<void> addTodo(String pofelId, TodoModel todo) async {
    await FirebaseFirestore.instance
        .collection('active_pofels')
        .doc(pofelId)
        .collection("todo")
        .doc(todo.todoId)
        .set({
      "todoTitle": todo.todoTitle,
      "todoId": todo.todoId,
      "isDone": todo.isDone,
      "assignedByName": todo.assignedByName,
      "assignedByProfilePic": todo.assignedByProfilePic,
      "assignedByUid": todo.assignedByUid,
      "assignedOn": todo.assignedOn,
      "assignedToName": todo.assignedToName,
      "assignedToProfilePic": todo.assignedToProfilePic,
      "assignedToUid": todo.assignedToUid,
      "doneOn": todo.doneOn,
    });
  }

  Future<void> removeTodo(String pofelId, String todoId) async {
    var query = await FirebaseFirestore.instance
        .collection('active_pofels')
        .doc(pofelId)
        .collection("items")
        .where("todoId", isEqualTo: todoId)
        .get();
    var doc = query.docs[0];
    var reference = doc.reference;
    reference.delete();
  }

  Future<void> todoIsDone(String pofelId, String todoId) async {
    var query = await FirebaseFirestore.instance
        .collection('active_pofels')
        .doc(pofelId)
        .collection("todo")
        .doc(todoId)
        .update({"isDone": true});
  }

  Future<void> todoIsNotDone(String pofelId, String todoId) async {
    var query = await FirebaseFirestore.instance
        .collection('active_pofels')
        .doc(pofelId)
        .collection("todo")
        .doc(todoId)
        .update({"isDone": false});
  }
}
