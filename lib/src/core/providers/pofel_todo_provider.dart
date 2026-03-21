import 'package:pofel_app/src/core/appwrite/appwrite_environment.dart';
import 'package:pofel_app/src/core/appwrite/appwrite_serializers.dart';
import 'package:pofel_app/src/core/appwrite/appwrite_services.dart';
import 'package:pofel_app/src/core/models/to_do_model.dart';

class TodoProvider {
  TodoProvider({AppwriteRepository? repository})
      : _repository = repository ?? AppwriteRepository();

  final AppwriteRepository _repository;

  Future<List<TodoModel>> fetchTodos(String pofelId) async {
    final todos = await _repository.listDocuments(
      AppwriteEnvironment.pofelTodosCollectionId,
    );
    final filtered = todos
        .where((todo) => todo['pofelId'] == pofelId)
        .toList()
      ..sort(
        (a, b) =>
            DateTime.parse(a['assignedOn'] as String).compareTo(
              DateTime.parse(b['assignedOn'] as String),
            ),
      );
    return filtered.map(TodoModel.fromMap).toList();
  }

  Future<void> addTodo(String pofelId, TodoModel todo) async {
    final assigner = await _repository.getDocument(
      AppwriteEnvironment.usersCollectionId,
      todo.assignedByUid,
    );
    await _repository.createDocument(
      collectionId: AppwriteEnvironment.pofelTodosCollectionId,
      documentId: todo.todoId,
      data: {
        'pofelId': pofelId,
        'todoTitle': todo.todoTitle,
        'todoId': todo.todoId,
        'isDone': todo.isDone,
        'assignedByName': assigner?['name'] ?? todo.assignedByName,
        'assignedByProfilePic':
            assigner?['profile_pic'] ?? todo.assignedByProfilePic,
        'assignedByUid': todo.assignedByUid,
        'assignedOn': serializeDateTime(todo.assignedOn),
        'assignedToName': todo.assignedToName,
        'assignedToProfilePic': todo.assignedToProfilePic,
        'assignedToUid': todo.assignedToUid,
        'doneOn': serializeDateTime(todo.doneOn),
      },
    );
  }

  Future<void> removeTodo(String pofelId, String todoId) async {
    await _repository.deleteDocument(
      collectionId: AppwriteEnvironment.pofelTodosCollectionId,
      documentId: todoId,
    );
  }

  Future<void> todoIsDone(String pofelId, String todoId) async {
    final todo = await _repository.getDocument(
      AppwriteEnvironment.pofelTodosCollectionId,
      todoId,
    );
    if (todo == null || todo['pofelId'] != pofelId) {
      return;
    }

    await _repository.updateDocument(
      collectionId: AppwriteEnvironment.pofelTodosCollectionId,
      documentId: todoId,
      data: {
        ...sanitizeDocumentData(todo),
        'isDone': true,
        'doneOn': serializeDateTime(DateTime.now()),
      },
    );
  }

  Future<void> todoIsNotDone(String pofelId, String todoId) async {
    final todo = await _repository.getDocument(
      AppwriteEnvironment.pofelTodosCollectionId,
      todoId,
    );
    if (todo == null || todo['pofelId'] != pofelId) {
      return;
    }

    await _repository.updateDocument(
      collectionId: AppwriteEnvironment.pofelTodosCollectionId,
      documentId: todoId,
      data: {
        ...sanitizeDocumentData(todo),
        'isDone': false,
      },
    );
  }
}
