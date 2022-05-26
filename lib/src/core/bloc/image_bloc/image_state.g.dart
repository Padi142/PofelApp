// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'image_state.dart';

// **************************************************************************
// CopyWithGenerator
// **************************************************************************

abstract class _$ImageStateWithDataCWProxy {
  ImageStateWithData imageStateEnum(ImageStateEnum imageStateEnum);

  ImageStateWithData photos(List<PofelImage> photos);

  ImageStateWithData totalToUpload(int totalToUpload);

  ImageStateWithData uploaded(int uploaded);

  /// This function **does support** nullification of nullable fields. All `null` values passed to `non-nullable` fields will be ignored. You can also use `ImageStateWithData(...).copyWith.fieldName(...)` to override fields one at a time with nullification support.
  ///
  /// Usage
  /// ```dart
  /// ImageStateWithData(...).copyWith(id: 12, name: "My name")
  /// ````
  ImageStateWithData call({
    ImageStateEnum? imageStateEnum,
    List<PofelImage>? photos,
    int? totalToUpload,
    int? uploaded,
  });
}

/// Proxy class for `copyWith` functionality. This is a callable class and can be used as follows: `instanceOfImageStateWithData.copyWith(...)`. Additionally contains functions for specific fields e.g. `instanceOfImageStateWithData.copyWith.fieldName(...)`
class _$ImageStateWithDataCWProxyImpl implements _$ImageStateWithDataCWProxy {
  final ImageStateWithData _value;

  const _$ImageStateWithDataCWProxyImpl(this._value);

  @override
  ImageStateWithData imageStateEnum(ImageStateEnum imageStateEnum) =>
      this(imageStateEnum: imageStateEnum);

  @override
  ImageStateWithData photos(List<PofelImage> photos) => this(photos: photos);

  @override
  ImageStateWithData totalToUpload(int totalToUpload) =>
      this(totalToUpload: totalToUpload);

  @override
  ImageStateWithData uploaded(int uploaded) => this(uploaded: uploaded);

  @override

  /// This function **does support** nullification of nullable fields. All `null` values passed to `non-nullable` fields will be ignored. You can also use `ImageStateWithData(...).copyWith.fieldName(...)` to override fields one at a time with nullification support.
  ///
  /// Usage
  /// ```dart
  /// ImageStateWithData(...).copyWith(id: 12, name: "My name")
  /// ````
  ImageStateWithData call({
    Object? imageStateEnum = const $CopyWithPlaceholder(),
    Object? photos = const $CopyWithPlaceholder(),
    Object? totalToUpload = const $CopyWithPlaceholder(),
    Object? uploaded = const $CopyWithPlaceholder(),
  }) {
    return ImageStateWithData(
      imageStateEnum: imageStateEnum == const $CopyWithPlaceholder() ||
              imageStateEnum == null
          ? _value.imageStateEnum
          // ignore: cast_nullable_to_non_nullable
          : imageStateEnum as ImageStateEnum,
      photos: photos == const $CopyWithPlaceholder() || photos == null
          ? _value.photos
          // ignore: cast_nullable_to_non_nullable
          : photos as List<PofelImage>,
      totalToUpload:
          totalToUpload == const $CopyWithPlaceholder() || totalToUpload == null
              ? _value.totalToUpload
              // ignore: cast_nullable_to_non_nullable
              : totalToUpload as int,
      uploaded: uploaded == const $CopyWithPlaceholder() || uploaded == null
          ? _value.uploaded
          // ignore: cast_nullable_to_non_nullable
          : uploaded as int,
    );
  }
}

extension $ImageStateWithDataCopyWith on ImageStateWithData {
  /// Returns a callable class that can be used as follows: `instanceOfImageStateWithData.copyWith(...)` or like so:`instanceOfImageStateWithData.copyWith.fieldName(...)`.
  _$ImageStateWithDataCWProxy get copyWith =>
      _$ImageStateWithDataCWProxyImpl(this);
}
