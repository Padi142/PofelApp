// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'social_state.dart';

// **************************************************************************
// CopyWithGenerator
// **************************************************************************

abstract class _$MyFollowingStateCWProxy {
  MyFollowingState inviteEnum(InviteEnum inviteEnum);

  MyFollowingState profiles(List<ProfileModel> profiles);

  /// This function **does support** nullification of nullable fields. All `null` values passed to `non-nullable` fields will be ignored. You can also use `MyFollowingState(...).copyWith.fieldName(...)` to override fields one at a time with nullification support.
  ///
  /// Usage
  /// ```dart
  /// MyFollowingState(...).copyWith(id: 12, name: "My name")
  /// ````
  MyFollowingState call({
    InviteEnum? inviteEnum,
    List<ProfileModel>? profiles,
  });
}

/// Proxy class for `copyWith` functionality. This is a callable class and can be used as follows: `instanceOfMyFollowingState.copyWith(...)`. Additionally contains functions for specific fields e.g. `instanceOfMyFollowingState.copyWith.fieldName(...)`
class _$MyFollowingStateCWProxyImpl implements _$MyFollowingStateCWProxy {
  final MyFollowingState _value;

  const _$MyFollowingStateCWProxyImpl(this._value);

  @override
  MyFollowingState inviteEnum(InviteEnum inviteEnum) =>
      this(inviteEnum: inviteEnum);

  @override
  MyFollowingState profiles(List<ProfileModel> profiles) =>
      this(profiles: profiles);

  @override

  /// This function **does support** nullification of nullable fields. All `null` values passed to `non-nullable` fields will be ignored. You can also use `MyFollowingState(...).copyWith.fieldName(...)` to override fields one at a time with nullification support.
  ///
  /// Usage
  /// ```dart
  /// MyFollowingState(...).copyWith(id: 12, name: "My name")
  /// ````
  MyFollowingState call({
    Object? inviteEnum = const $CopyWithPlaceholder(),
    Object? profiles = const $CopyWithPlaceholder(),
  }) {
    return MyFollowingState(
      inviteEnum:
          inviteEnum == const $CopyWithPlaceholder() || inviteEnum == null
              ? _value.inviteEnum
              // ignore: cast_nullable_to_non_nullable
              : inviteEnum as InviteEnum,
      profiles: profiles == const $CopyWithPlaceholder() || profiles == null
          ? _value.profiles
          // ignore: cast_nullable_to_non_nullable
          : profiles as List<ProfileModel>,
    );
  }
}

extension $MyFollowingStateCopyWith on MyFollowingState {
  /// Returns a callable class that can be used as follows: `instanceOfclass MyFollowingState extends SocialState.name.copyWith(...)` or like so:`instanceOfclass MyFollowingState extends SocialState.name.copyWith.fieldName(...)`.
  _$MyFollowingStateCWProxy get copyWith => _$MyFollowingStateCWProxyImpl(this);
}
