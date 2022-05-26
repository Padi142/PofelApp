// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'kyblspot_state.dart';

// **************************************************************************
// CopyWithGenerator
// **************************************************************************

abstract class _$KyblspotLoadedStateCWProxy {
  KyblspotLoadedState kyblspotEnum(KyblspotEnum kyblspotEnum);

  KyblspotLoadedState markers(List<Marker> markers);

  KyblspotLoadedState reviews(List<SpotReviewModel> reviews);

  KyblspotLoadedState spots(List<KyblspotModel> spots);

  /// This function **does support** nullification of nullable fields. All `null` values passed to `non-nullable` fields will be ignored. You can also use `KyblspotLoadedState(...).copyWith.fieldName(...)` to override fields one at a time with nullification support.
  ///
  /// Usage
  /// ```dart
  /// KyblspotLoadedState(...).copyWith(id: 12, name: "My name")
  /// ````
  KyblspotLoadedState call({
    KyblspotEnum? kyblspotEnum,
    List<Marker>? markers,
    List<SpotReviewModel>? reviews,
    List<KyblspotModel>? spots,
  });
}

/// Proxy class for `copyWith` functionality. This is a callable class and can be used as follows: `instanceOfKyblspotLoadedState.copyWith(...)`. Additionally contains functions for specific fields e.g. `instanceOfKyblspotLoadedState.copyWith.fieldName(...)`
class _$KyblspotLoadedStateCWProxyImpl implements _$KyblspotLoadedStateCWProxy {
  final KyblspotLoadedState _value;

  const _$KyblspotLoadedStateCWProxyImpl(this._value);

  @override
  KyblspotLoadedState kyblspotEnum(KyblspotEnum kyblspotEnum) =>
      this(kyblspotEnum: kyblspotEnum);

  @override
  KyblspotLoadedState markers(List<Marker> markers) => this(markers: markers);

  @override
  KyblspotLoadedState reviews(List<SpotReviewModel> reviews) =>
      this(reviews: reviews);

  @override
  KyblspotLoadedState spots(List<KyblspotModel> spots) => this(spots: spots);

  @override

  /// This function **does support** nullification of nullable fields. All `null` values passed to `non-nullable` fields will be ignored. You can also use `KyblspotLoadedState(...).copyWith.fieldName(...)` to override fields one at a time with nullification support.
  ///
  /// Usage
  /// ```dart
  /// KyblspotLoadedState(...).copyWith(id: 12, name: "My name")
  /// ````
  KyblspotLoadedState call({
    Object? kyblspotEnum = const $CopyWithPlaceholder(),
    Object? markers = const $CopyWithPlaceholder(),
    Object? reviews = const $CopyWithPlaceholder(),
    Object? spots = const $CopyWithPlaceholder(),
  }) {
    return KyblspotLoadedState(
      kyblspotEnum:
          kyblspotEnum == const $CopyWithPlaceholder() || kyblspotEnum == null
              ? _value.kyblspotEnum
              // ignore: cast_nullable_to_non_nullable
              : kyblspotEnum as KyblspotEnum,
      markers: markers == const $CopyWithPlaceholder() || markers == null
          ? _value.markers
          // ignore: cast_nullable_to_non_nullable
          : markers as List<Marker>,
      reviews: reviews == const $CopyWithPlaceholder() || reviews == null
          ? _value.reviews
          // ignore: cast_nullable_to_non_nullable
          : reviews as List<SpotReviewModel>,
      spots: spots == const $CopyWithPlaceholder() || spots == null
          ? _value.spots
          // ignore: cast_nullable_to_non_nullable
          : spots as List<KyblspotModel>,
    );
  }
}

extension $KyblspotLoadedStateCopyWith on KyblspotLoadedState {
  /// Returns a callable class that can be used as follows: `instanceOfKyblspotLoadedState.copyWith(...)` or like so:`instanceOfKyblspotLoadedState.copyWith.fieldName(...)`.
  _$KyblspotLoadedStateCWProxy get copyWith =>
      _$KyblspotLoadedStateCWProxyImpl(this);
}
