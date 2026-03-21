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

class ReturnFromInvite extends LoginEvent {
  const ReturnFromInvite();
  @override
  List<Object> get props => [];
}

class LogOut extends LoginEvent {
  const LogOut();
  @override
  List<Object> get props => [];
}
