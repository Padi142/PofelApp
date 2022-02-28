// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'todo_bloc_state.dart';

// **************************************************************************
// CopyWithGenerator
// **************************************************************************

abstract class _$TodosWithDataCWProxy {
  TodosWithData doneTodos(List<TodoModel> doneTodos);

  TodosWithData notDoneTodos(List<TodoModel> notDoneTodos);

  TodosWithData todosEnum(TodosEnum todosEnum);

  /// This function **does support** nullification of nullable fields. All `null` values passed to `non-nullable` fields will be ignored. You can also use `TodosWithData(...).copyWith.fieldName(...)` to override fields one at a time with nullification support.
  ///
  /// Usage
  /// ```dart
  /// TodosWithData(...).copyWith(id: 12, name: "My name")
  /// ````
  TodosWithData call({
    List<TodoModel>? doneTodos,
    List<TodoModel>? notDoneTodos,
    TodosEnum? todosEnum,
  });
}

/// Proxy class for `copyWith` functionality. This is a callable class and can be used as follows: `instanceOfTodosWithData.copyWith(...)`. Additionally contains functions for specific fields e.g. `instanceOfTodosWithData.copyWith.fieldName(...)`
class _$TodosWithDataCWProxyImpl implements _$TodosWithDataCWProxy {
  final TodosWithData _value;

  const _$TodosWithDataCWProxyImpl(this._value);

  @override
  TodosWithData doneTodos(List<TodoModel> doneTodos) =>
      this(doneTodos: doneTodos);

  @override
  TodosWithData notDoneTodos(List<TodoModel> notDoneTodos) =>
      this(notDoneTodos: notDoneTodos);

  @override
  TodosWithData todosEnum(TodosEnum todosEnum) => this(todosEnum: todosEnum);

  @override

  /// This function **does support** nullification of nullable fields. All `null` values passed to `non-nullable` fields will be ignored. You can also use `TodosWithData(...).copyWith.fieldName(...)` to override fields one at a time with nullification support.
  ///
  /// Usage
  /// ```dart
  /// TodosWithData(...).copyWith(id: 12, name: "My name")
  /// ````
  TodosWithData call({
    Object? doneTodos = const $CopyWithPlaceholder(),
    Object? notDoneTodos = const $CopyWithPlaceholder(),
    Object? todosEnum = const $CopyWithPlaceholder(),
  }) {
    return TodosWithData(
      doneTodos: doneTodos == const $CopyWithPlaceholder() || doneTodos == null
          ? _value.doneTodos
          // ignore: cast_nullable_to_non_nullable
          : doneTodos as List<TodoModel>,
      notDoneTodos:
          notDoneTodos == const $CopyWithPlaceholder() || notDoneTodos == null
              ? _value.notDoneTodos
              // ignore: cast_nullable_to_non_nullable
              : notDoneTodos as List<TodoModel>,
      todosEnum: todosEnum == const $CopyWithPlaceholder() || todosEnum == null
          ? _value.todosEnum
          // ignore: cast_nullable_to_non_nullable
          : todosEnum as TodosEnum,
    );
  }
}

extension $TodosWithDataCopyWith on TodosWithData {
  /// Returns a callable class that can be used as follows: `instanceOfclass TodosWithData extends TodoBlocState.name.copyWith(...)` or like so:`instanceOfclass TodosWithData extends TodoBlocState.name.copyWith.fieldName(...)`.
  _$TodosWithDataCWProxy get copyWith => _$TodosWithDataCWProxyImpl(this);
}
