import 'package:equatable/equatable.dart';

abstract class LoginEvent extends Equatable {
  const LoginEvent();

  @override
  List<Object> get props => [];
}

class LogInInitial extends LoginEvent {
  const LogInInitial();
  @override
  List<Object> get props => [];
}

class GoogleLogInEvent extends LoginEvent {
  const GoogleLogInEvent();
  @override
  List<Object> get props => [];
}

class AppleLogInEvent extends LoginEvent {
  const AppleLogInEvent();
  @override
  List<Object> get props => [];
}

class EmailPasswordLogInEvent extends LoginEvent {
  const EmailPasswordLogInEvent({
    required this.email,
    required this.password,
  });

  final String email;
  final String password;

  @override
  List<Object> get props => [email, password];
}

class ReturnFromInvite extends LoginEvent {
  const ReturnFromInvite();
  @override
  List<Object> get props => [];
}

class ReceiveInviteLink extends LoginEvent {
  const ReceiveInviteLink({required this.joinId});

  final String joinId;

  @override
  List<Object> get props => [joinId];
}

class LogOut extends LoginEvent {
  const LogOut();
  @override
  List<Object> get props => [];
}
