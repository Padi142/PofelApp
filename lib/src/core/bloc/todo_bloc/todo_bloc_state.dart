import 'package:equatable/equatable.dart';
import 'package:pofel_app/src/core/models/to_do_model.dart';
import 'package:copy_with_extension/copy_with_extension.dart';

part "todo_bloc_state.g.dart";

abstract class TodoBlocState extends Equatable {
  const TodoBlocState();

  @override
  List<Object> get props => [];
}

@CopyWith()
class TodosWithData extends TodoBlocState {
  final List<TodoModel> doneTodos;
  final List<TodoModel> notDoneTodos;
  final TodosEnum todosEnum;
  TodosWithData({
    required this.doneTodos,
    required this.notDoneTodos,
    required this.todosEnum,
  });

  @override
  List<Object> get props => [doneTodos, notDoneTodos, todosEnum];
}

enum TodosEnum {
  INITIAL,
  TODO_ADDED,
  TODOS_LOADED,
  TODO_DONE,
  TODO_UPDATED,
}
