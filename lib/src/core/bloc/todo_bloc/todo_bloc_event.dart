import 'package:equatable/equatable.dart';

abstract class TodoBlocEvent extends Equatable {
  const TodoBlocEvent();

  @override
  List<Object> get props => [];
}

class LoadTodos extends TodoBlocEvent {
  final String pofelId;

  const LoadTodos({
    required this.pofelId,
  });

  @override
  List<Object> get props => [];
}

class AddTodoEvent extends TodoBlocEvent {
  final String pofelId;

  final String todoTitle;
  final bool isDone;
  final String assignedByName;
  final String assignedByProfilePic;
  final String assignedByUid;
  final String assignedToName;
  final String assignedToProfilePic;
  final String assignedToUid;

  const AddTodoEvent({
    required this.pofelId,
    required this.todoTitle,
    required this.isDone,
    required this.assignedByName,
    required this.assignedByProfilePic,
    required this.assignedByUid,
    required this.assignedToName,
    required this.assignedToProfilePic,
    required this.assignedToUid,
  });

  @override
  List<Object> get props => [];
}

class FinishTodo extends TodoBlocEvent {
  final String pofelId;

  final String todoId;

  const FinishTodo({
    required this.pofelId,
    required this.todoId,
  });

  @override
  List<Object> get props => [];
}

class UnfinishTodo extends TodoBlocEvent {
  final String pofelId;

  final String todoId;

  const UnfinishTodo({
    required this.pofelId,
    required this.todoId,
  });

  @override
  List<Object> get props => [];
}
