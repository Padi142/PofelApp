import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:equatable/equatable.dart';

class TodoModel extends Equatable {
  const TodoModel({
    required this.todoTitle,
    required this.todoId,
    required this.isDone,
    required this.assignedByName,
    required this.assignedByProfilePic,
    required this.assignedByUid,
    required this.assignedToName,
    required this.assignedToProfilePic,
    required this.assignedToUid,
    required this.assignedOn,
    required this.doneOn,
  });

  final String todoTitle;
  final String todoId;
  final bool isDone;
  final String assignedByName;
  final String assignedByProfilePic;
  final String assignedByUid;
  final String assignedToName;
  final String assignedToProfilePic;
  final String assignedToUid;
  final DateTime assignedOn;
  final DateTime doneOn;

  @override
  List<Object?> get props => [];

  factory TodoModel.fromMap(
    Map<String, dynamic> map,
  ) {
    return TodoModel(
      todoTitle: map["todoTitle"],
      todoId: map["todoId"],
      isDone: map["isDone"],
      assignedByName: map["assignedByName"],
      assignedByProfilePic: map["assignedByProfilePic"],
      assignedByUid: map["assignedByUid"],
      assignedToName: map["assignedToName"],
      assignedToProfilePic: map["assignedToProfilePic"],
      assignedToUid: map["assignedToUid"],
      assignedOn: map["assignedOn"].toDate(),
      doneOn: map["doneOn"].toDate(),
    );
  }
  factory TodoModel.fromObject(QueryDocumentSnapshot<Object?> map) {
    return TodoModel(
      todoTitle: map["todoTitle"],
      todoId: map["todoId"],
      isDone: map["isDone"],
      assignedByName: map["assignedByName"],
      assignedByProfilePic: map["assignedByProfilePic"],
      assignedByUid: map["assignedByUid"],
      assignedToName: map["assignedToName"],
      assignedToProfilePic: map["assignedToProfilePic"],
      assignedToUid: map["assignedToUid"],
      assignedOn: map["assignedOn"].toDate(),
      doneOn: map["doneOn"].toDate(),
    );
  }
}

List<TodoModel> pofelTodosFromList(List<dynamic> list) {
  List<TodoModel> todos = [];
  for (var todo in list) {
    todos.add(TodoModel.fromMap(todo.data()));
  }
  return todos;
}
