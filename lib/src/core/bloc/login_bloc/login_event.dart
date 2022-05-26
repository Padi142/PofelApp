import 'package:equatable/equatable.dart';

abstract class LoginEvent extends Equatable {
  const LoginEvent();

  @override
  List<Object> get props => [];
}

class LogInInitial extends LoginEvent {
  LogInInitial();
  @override
  List<Object> get props => [];
}

class FacebookLogInEvent extends LoginEvent {
  FacebookLogInEvent();
  @override
  List<Object> get props => [];
}

class GoogleLogInEvent extends LoginEvent {
  GoogleLogInEvent();
  @override
  List<Object> get props => [];
}

class AppleLoginEvent extends LoginEvent {
  AppleLoginEvent();
  @override
  List<Object> get props => [];
}

class GoogleSupportLogIn extends LoginEvent {
  GoogleSupportLogIn();
  @override
  List<Object> get props => [];
}

class ReturnFromInvite extends LoginEvent {
  ReturnFromInvite();
  @override
  List<Object> get props => [];
}

class LogOut extends LoginEvent {
  LogOut();
  @override
  List<Object> get props => [];
}
