import 'package:equatable/equatable.dart';

abstract class LoginEvent extends Equatable {
  const LoginEvent();

  @override
  List<Object> get props => [];
}

class FacebookLogInEvent extends LoginEvent {
  FacebookLogInEvent();
  @override
  List<Object> get props => [];
}
