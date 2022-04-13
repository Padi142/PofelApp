// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'public_pofel_state.dart';

// **************************************************************************
// CopyWithGenerator
// **************************************************************************

abstract class _$PublicPofelsLoadedCWProxy {
  PublicPofelsLoaded markers(List<Marker> markers);

  PublicPofelsLoaded pofels(List<PofelModel> pofels);

  PublicPofelsLoaded publicPofelEnum(PublicPofelEnum publicPofelEnum);

  /// This function **does support** nullification of nullable fields. All `null` values passed to `non-nullable` fields will be ignored. You can also use `PublicPofelsLoaded(...).copyWith.fieldName(...)` to override fields one at a time with nullification support.
  ///
  /// Usage
  /// ```dart
  /// PublicPofelsLoaded(...).copyWith(id: 12, name: "My name")
  /// ````
  PublicPofelsLoaded call({
    List<Marker>? markers,
    List<PofelModel>? pofels,
    PublicPofelEnum? publicPofelEnum,
  });
}

/// Proxy class for `copyWith` functionality. This is a callable class and can be used as follows: `instanceOfPublicPofelsLoaded.copyWith(...)`. Additionally contains functions for specific fields e.g. `instanceOfPublicPofelsLoaded.copyWith.fieldName(...)`
class _$PublicPofelsLoadedCWProxyImpl implements _$PublicPofelsLoadedCWProxy {
  final PublicPofelsLoaded _value;

  const _$PublicPofelsLoadedCWProxyImpl(this._value);

  @override
  PublicPofelsLoaded markers(List<Marker> markers) => this(markers: markers);

  @override
  PublicPofelsLoaded pofels(List<PofelModel> pofels) => this(pofels: pofels);

  @override
  PublicPofelsLoaded publicPofelEnum(PublicPofelEnum publicPofelEnum) =>
      this(publicPofelEnum: publicPofelEnum);

  @override

  /// This function **does support** nullification of nullable fields. All `null` values passed to `non-nullable` fields will be ignored. You can also use `PublicPofelsLoaded(...).copyWith.fieldName(...)` to override fields one at a time with nullification support.
  ///
  /// Usage
  /// ```dart
  /// PublicPofelsLoaded(...).copyWith(id: 12, name: "My name")
  /// ````
  PublicPofelsLoaded call({
    Object? markers = const $CopyWithPlaceholder(),
    Object? pofels = const $CopyWithPlaceholder(),
    Object? publicPofelEnum = const $CopyWithPlaceholder(),
  }) {
    return PublicPofelsLoaded(
      markers: markers == const $CopyWithPlaceholder() || markers == null
          ? _value.markers
          // ignore: cast_nullable_to_non_nullable
          : markers as List<Marker>,
      pofels: pofels == const $CopyWithPlaceholder() || pofels == null
          ? _value.pofels
          // ignore: cast_nullable_to_non_nullable
          : pofels as List<PofelModel>,
      publicPofelEnum: publicPofelEnum == const $CopyWithPlaceholder() ||
              publicPofelEnum == null
          ? _value.publicPofelEnum
          // ignore: cast_nullable_to_non_nullable
          : publicPofelEnum as PublicPofelEnum,
    );
  }
}

extension $PublicPofelsLoadedCopyWith on PublicPofelsLoaded {
  /// Returns a callable class that can be used as follows: `instanceOfclass PublicPofelsLoaded extends PublicPofelState.name.copyWith(...)` or like so:`instanceOfclass PublicPofelsLoaded extends PublicPofelState.name.copyWith.fieldName(...)`.
  _$PublicPofelsLoadedCWProxy get copyWith =>
      _$PublicPofelsLoadedCWProxyImpl(this);
}
