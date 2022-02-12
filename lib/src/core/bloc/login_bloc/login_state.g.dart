// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'login_state.dart';

// **************************************************************************
// CopyWithGenerator
// **************************************************************************

abstract class _$LoginStateWithDataCWProxy {
  LoginStateWithData isLoggedIn(bool isLoggedIn);

  LoginStateWithData loginStateEnum(LoginStateEnum loginStateEnum);

  LoginStateWithData user(UserModel user);

  /// This function **does support** nullification of nullable fields. All `null` values passed to `non-nullable` fields will be ignored. You can also use `LoginStateWithData(...).copyWith.fieldName(...)` to override fields one at a time with nullification support.
  ///
  /// Usage
  /// ```dart
  /// LoginStateWithData(...).copyWith(id: 12, name: "My name")
  /// ````
  LoginStateWithData call({
    bool? isLoggedIn,
    LoginStateEnum? loginStateEnum,
    UserModel? user,
  });
}

/// Proxy class for `copyWith` functionality. This is a callable class and can be used as follows: `instanceOfLoginStateWithData.copyWith(...)`. Additionally contains functions for specific fields e.g. `instanceOfLoginStateWithData.copyWith.fieldName(...)`
class _$LoginStateWithDataCWProxyImpl implements _$LoginStateWithDataCWProxy {
  final LoginStateWithData _value;

  const _$LoginStateWithDataCWProxyImpl(this._value);

  @override
  LoginStateWithData isLoggedIn(bool isLoggedIn) =>
      this(isLoggedIn: isLoggedIn);

  @override
  LoginStateWithData loginStateEnum(LoginStateEnum loginStateEnum) =>
      this(loginStateEnum: loginStateEnum);

  @override
  LoginStateWithData user(UserModel user) => this(user: user);

  @override

  /// This function **does support** nullification of nullable fields. All `null` values passed to `non-nullable` fields will be ignored. You can also use `LoginStateWithData(...).copyWith.fieldName(...)` to override fields one at a time with nullification support.
  ///
  /// Usage
  /// ```dart
  /// LoginStateWithData(...).copyWith(id: 12, name: "My name")
  /// ````
  LoginStateWithData call({
    Object? isLoggedIn = const $CopyWithPlaceholder(),
    Object? loginStateEnum = const $CopyWithPlaceholder(),
    Object? user = const $CopyWithPlaceholder(),
  }) {
    return LoginStateWithData(
      isLoggedIn:
          isLoggedIn == const $CopyWithPlaceholder() || isLoggedIn == null
              ? _value.isLoggedIn
              // ignore: cast_nullable_to_non_nullable
              : isLoggedIn as bool,
      loginStateEnum: loginStateEnum == const $CopyWithPlaceholder() ||
              loginStateEnum == null
          ? _value.loginStateEnum
          // ignore: cast_nullable_to_non_nullable
          : loginStateEnum as LoginStateEnum,
      user: user == const $CopyWithPlaceholder() || user == null
          ? _value.user
          // ignore: cast_nullable_to_non_nullable
          : user as UserModel,
    );
  }
}

extension $LoginStateWithDataCopyWith on LoginStateWithData {
  /// Returns a callable class that can be used as follows: `instanceOfclass LoginStateWithData extends LoginState.name.copyWith(...)` or like so:`instanceOfclass LoginStateWithData extends LoginState.name.copyWith.fieldName(...)`.
  _$LoginStateWithDataCWProxy get copyWith =>
      _$LoginStateWithDataCWProxyImpl(this);
}
