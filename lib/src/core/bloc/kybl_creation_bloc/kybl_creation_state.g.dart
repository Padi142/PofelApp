// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'kybl_creation_state.dart';

// **************************************************************************
// CopyWithGenerator
// **************************************************************************

abstract class _$KyblspotCreationDataCWProxy {
  KyblspotCreationData description(String description);

  KyblspotCreationData mode(creationState mode);

  KyblspotCreationData name(String name);

  KyblspotCreationData position(GeoPoint position);

  /// This function **does support** nullification of nullable fields. All `null` values passed to `non-nullable` fields will be ignored. You can also use `KyblspotCreationData(...).copyWith.fieldName(...)` to override fields one at a time with nullification support.
  ///
  /// Usage
  /// ```dart
  /// KyblspotCreationData(...).copyWith(id: 12, name: "My name")
  /// ````
  KyblspotCreationData call({
    String? description,
    creationState? mode,
    String? name,
    GeoPoint? position,
  });
}

/// Proxy class for `copyWith` functionality. This is a callable class and can be used as follows: `instanceOfKyblspotCreationData.copyWith(...)`. Additionally contains functions for specific fields e.g. `instanceOfKyblspotCreationData.copyWith.fieldName(...)`
class _$KyblspotCreationDataCWProxyImpl
    implements _$KyblspotCreationDataCWProxy {
  final KyblspotCreationData _value;

  const _$KyblspotCreationDataCWProxyImpl(this._value);

  @override
  KyblspotCreationData description(String description) =>
      this(description: description);

  @override
  KyblspotCreationData mode(creationState mode) => this(mode: mode);

  @override
  KyblspotCreationData name(String name) => this(name: name);

  @override
  KyblspotCreationData position(GeoPoint position) => this(position: position);

  @override

  /// This function **does support** nullification of nullable fields. All `null` values passed to `non-nullable` fields will be ignored. You can also use `KyblspotCreationData(...).copyWith.fieldName(...)` to override fields one at a time with nullification support.
  ///
  /// Usage
  /// ```dart
  /// KyblspotCreationData(...).copyWith(id: 12, name: "My name")
  /// ````
  KyblspotCreationData call({
    Object? description = const $CopyWithPlaceholder(),
    Object? mode = const $CopyWithPlaceholder(),
    Object? name = const $CopyWithPlaceholder(),
    Object? position = const $CopyWithPlaceholder(),
  }) {
    return KyblspotCreationData(
      description:
          description == const $CopyWithPlaceholder() || description == null
              ? _value.description
              // ignore: cast_nullable_to_non_nullable
              : description as String,
      mode: mode == const $CopyWithPlaceholder() || mode == null
          ? _value.mode
          // ignore: cast_nullable_to_non_nullable
          : mode as creationState,
      name: name == const $CopyWithPlaceholder() || name == null
          ? _value.name
          // ignore: cast_nullable_to_non_nullable
          : name as String,
      position: position == const $CopyWithPlaceholder() || position == null
          ? _value.position
          // ignore: cast_nullable_to_non_nullable
          : position as GeoPoint,
    );
  }
}

extension $KyblspotCreationDataCopyWith on KyblspotCreationData {
  /// Returns a callable class that can be used as follows: `instanceOfKyblspotCreationData.copyWith(...)` or like so:`instanceOfKyblspotCreationData.copyWith.fieldName(...)`.
  _$KyblspotCreationDataCWProxy get copyWith =>
      _$KyblspotCreationDataCWProxyImpl(this);
}
