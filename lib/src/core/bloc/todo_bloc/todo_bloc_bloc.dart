import 'dart:math';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:pofel_app/src/core/bloc/todo_bloc/todo_bloc_event.dart';
import 'package:pofel_app/src/core/bloc/todo_bloc/todo_bloc_state.dart';
import 'package:pofel_app/src/core/models/to_do_model.dart';
import 'package:pofel_app/src/core/providers/pofel_todo_provider.dart';

class TodoBloc extends Bloc<TodoBlocEvent, TodoBlocState> {
  TodoBloc()
      : super(TodosWithData(
            doneTodos: const [],
            todosEnum: TodosEnum.INITIAL,
            notDoneTodos: const [])) {
    on<LoadTodos>(_onLoadTodos);
    on<AddTodoEvent>(_onAddTodo);
    on<FinishTodo>(_onFinishTodo);
    on<UnfinishTodo>(_onUnFinishTodo);
  }
  TodoProvider todoProvider = TodoProvider();
  _onLoadTodos(LoadTodos event, Emitter<TodoBlocState> emit) async {
    List<TodoModel> todos = await todoProvider.fetchTodos(event.pofelId);

    List<TodoModel> doneTodos = [];
    List<TodoModel> notDoneTodos = [];

    for (TodoModel todo in todos) {
      if (todo.isDone) {
        doneTodos.add(todo);
      } else {
        notDoneTodos.add(todo);
      }
    }
    emit((state as TodosWithData).copyWith(
        doneTodos: doneTodos,
        notDoneTodos: notDoneTodos,
        todosEnum: TodosEnum.TODOS_LOADED));
  }

  _onAddTodo(AddTodoEvent event, Emitter<TodoBlocState> emit) async {
    const _chars =
        'AaBbCcDdEeFfGgHhIiJjKkLlMmNnOoPpQqRrSsTtUuVvWwXxYyZz1234567890';
    Random _rnd = Random();

    String getRandomString(int length) =>
        String.fromCharCodes(Iterable.generate(
            length, (_) => _chars.codeUnitAt(_rnd.nextInt(_chars.length))));

    String todoId = getRandomString(10);

    TodoModel todo = TodoModel(
        assignedByName: event.assignedByName,
        assignedByProfilePic: event.assignedByProfilePic,
        assignedByUid: event.assignedByUid,
        assignedOn: DateTime.now(),
        assignedToName: event.assignedToName,
        assignedToProfilePic: event.assignedToProfilePic,
        assignedToUid: event.assignedToUid,
        doneOn: DateTime.parse('1969-07-20 20:18:04Z'),
        isDone: false,
        todoId: todoId,
        todoTitle: event.todoTitle);

    await todoProvider.addTodo(event.pofelId, todo);

    emit((state as TodosWithData).copyWith(todosEnum: TodosEnum.TODO_ADDED));
  }

  _onFinishTodo(FinishTodo event, Emitter<TodoBlocState> emit) async {
    await todoProvider.todoIsDone(event.pofelId, event.todoId);

    emit((state as TodosWithData).copyWith(todosEnum: TodosEnum.TODO_UPDATED));
  }

  _onUnFinishTodo(UnfinishTodo event, Emitter<TodoBlocState> emit) async {
    await todoProvider.todoIsNotDone(event.pofelId, event.todoId);

    emit((state as TodosWithData).copyWith(todosEnum: TodosEnum.TODO_UPDATED));
  }
}
