// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'loadpofels_state.dart';

// **************************************************************************
// CopyWithGenerator
// **************************************************************************

abstract class _$LoadPofelsWithDataCWProxy {
  LoadPofelsWithData loadPofelStateEnum(LoadPofelsStateEnum loadPofelStateEnum);

  LoadPofelsWithData myPofels(List<PofelModel> myPofels);

  /// This function **does support** nullification of nullable fields. All `null` values passed to `non-nullable` fields will be ignored. You can also use `LoadPofelsWithData(...).copyWith.fieldName(...)` to override fields one at a time with nullification support.
  ///
  /// Usage
  /// ```dart
  /// LoadPofelsWithData(...).copyWith(id: 12, name: "My name")
  /// ````
  LoadPofelsWithData call({
    LoadPofelsStateEnum? loadPofelStateEnum,
    List<PofelModel>? myPofels,
  });
}

/// Proxy class for `copyWith` functionality. This is a callable class and can be used as follows: `instanceOfLoadPofelsWithData.copyWith(...)`. Additionally contains functions for specific fields e.g. `instanceOfLoadPofelsWithData.copyWith.fieldName(...)`
class _$LoadPofelsWithDataCWProxyImpl implements _$LoadPofelsWithDataCWProxy {
  final LoadPofelsWithData _value;

  const _$LoadPofelsWithDataCWProxyImpl(this._value);

  @override
  LoadPofelsWithData loadPofelStateEnum(
          LoadPofelsStateEnum loadPofelStateEnum) =>
      this(loadPofelStateEnum: loadPofelStateEnum);

  @override
  LoadPofelsWithData myPofels(List<PofelModel> myPofels) =>
      this(myPofels: myPofels);

  @override

  /// This function **does support** nullification of nullable fields. All `null` values passed to `non-nullable` fields will be ignored. You can also use `LoadPofelsWithData(...).copyWith.fieldName(...)` to override fields one at a time with nullification support.
  ///
  /// Usage
  /// ```dart
  /// LoadPofelsWithData(...).copyWith(id: 12, name: "My name")
  /// ````
  LoadPofelsWithData call({
    Object? loadPofelStateEnum = const $CopyWithPlaceholder(),
    Object? myPofels = const $CopyWithPlaceholder(),
  }) {
    return LoadPofelsWithData(
      loadPofelStateEnum: loadPofelStateEnum == const $CopyWithPlaceholder() ||
              loadPofelStateEnum == null
          ? _value.loadPofelStateEnum
          // ignore: cast_nullable_to_non_nullable
          : loadPofelStateEnum as LoadPofelsStateEnum,
      myPofels: myPofels == const $CopyWithPlaceholder() || myPofels == null
          ? _value.myPofels
          // ignore: cast_nullable_to_non_nullable
          : myPofels as List<PofelModel>,
    );
  }
}

extension $LoadPofelsWithDataCopyWith on LoadPofelsWithData {
  /// Returns a callable class that can be used as follows: `instanceOfLoadPofelsWithData.copyWith(...)` or like so:`instanceOfLoadPofelsWithData.copyWith.fieldName(...)`.
  _$LoadPofelsWithDataCWProxy get copyWith =>
      _$LoadPofelsWithDataCWProxyImpl(this);
}
