// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'pofel_state.dart';

// **************************************************************************
// CopyWithGenerator
// **************************************************************************

abstract class _$PofelStateWithDataCWProxy {
  PofelStateWithData choosenPofel(PofelModel choosenPofel);

  PofelStateWithData errorMessage(String? errorMessage);

  PofelStateWithData pofelStateEnum(PofelStateEnum pofelStateEnum);

  /// This function **does support** nullification of nullable fields. All `null` values passed to `non-nullable` fields will be ignored. You can also use `PofelStateWithData(...).copyWith.fieldName(...)` to override fields one at a time with nullification support.
  ///
  /// Usage
  /// ```dart
  /// PofelStateWithData(...).copyWith(id: 12, name: "My name")
  /// ````
  PofelStateWithData call({
    PofelModel? choosenPofel,
    String? errorMessage,
    PofelStateEnum? pofelStateEnum,
  });
}

/// Proxy class for `copyWith` functionality. This is a callable class and can be used as follows: `instanceOfPofelStateWithData.copyWith(...)`. Additionally contains functions for specific fields e.g. `instanceOfPofelStateWithData.copyWith.fieldName(...)`
class _$PofelStateWithDataCWProxyImpl implements _$PofelStateWithDataCWProxy {
  final PofelStateWithData _value;

  const _$PofelStateWithDataCWProxyImpl(this._value);

  @override
  PofelStateWithData choosenPofel(PofelModel choosenPofel) =>
      this(choosenPofel: choosenPofel);

  @override
  PofelStateWithData errorMessage(String? errorMessage) =>
      this(errorMessage: errorMessage);

  @override
  PofelStateWithData pofelStateEnum(PofelStateEnum pofelStateEnum) =>
      this(pofelStateEnum: pofelStateEnum);

  @override

  /// This function **does support** nullification of nullable fields. All `null` values passed to `non-nullable` fields will be ignored. You can also use `PofelStateWithData(...).copyWith.fieldName(...)` to override fields one at a time with nullification support.
  ///
  /// Usage
  /// ```dart
  /// PofelStateWithData(...).copyWith(id: 12, name: "My name")
  /// ````
  PofelStateWithData call({
    Object? choosenPofel = const $CopyWithPlaceholder(),
    Object? errorMessage = const $CopyWithPlaceholder(),
    Object? pofelStateEnum = const $CopyWithPlaceholder(),
  }) {
    return PofelStateWithData(
      choosenPofel:
          choosenPofel == const $CopyWithPlaceholder() || choosenPofel == null
              ? _value.choosenPofel
              // ignore: cast_nullable_to_non_nullable
              : choosenPofel as PofelModel,
      errorMessage: errorMessage == const $CopyWithPlaceholder()
          ? _value.errorMessage
          // ignore: cast_nullable_to_non_nullable
          : errorMessage as String?,
      pofelStateEnum: pofelStateEnum == const $CopyWithPlaceholder() ||
              pofelStateEnum == null
          ? _value.pofelStateEnum
          // ignore: cast_nullable_to_non_nullable
          : pofelStateEnum as PofelStateEnum,
    );
  }
}

extension $PofelStateWithDataCopyWith on PofelStateWithData {
  /// Returns a callable class that can be used as follows: `instanceOfclass PofelStateWithData extends PofelState.name.copyWith(...)` or like so:`instanceOfclass PofelStateWithData extends PofelState.name.copyWith.fieldName(...)`.
  _$PofelStateWithDataCWProxy get copyWith =>
      _$PofelStateWithDataCWProxyImpl(this);
}
