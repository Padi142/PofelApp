import 'package:equatable/equatable.dart';
import 'package:pofel_app/src/core/models/login_models/user.dart';
import 'package:copy_with_extension/copy_with_extension.dart';

part "login_state.g.dart";

abstract class LoginState extends Equatable {
  const LoginState();

  @override
  List<Object> get props => [];
}

@CopyWith()
class LoginStateWithData extends LoginState {
  final bool isLoggedIn;
  final UserModel user;
  final LoginStateEnum loginStateEnum;
  final String invite;
  final String inviteId;
  final String? errorMessage;
  const LoginStateWithData(
      {required this.isLoggedIn,
      required this.user,
      required this.invite,
      required this.inviteId,
      required this.errorMessage,
      required this.loginStateEnum});

  @override
  List<Object> get props =>
      [isLoggedIn, user, loginStateEnum, inviteId, invite, errorMessage ?? ""];
}

enum LoginStateEnum { notLoggedIn, loggedIn, logInFailed }
