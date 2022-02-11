import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:pofel_app/src/core/bloc/login_bloc/login_event.dart';
import 'package:pofel_app/src/core/bloc/login_bloc/login_state.dart';
import 'package:pofel_app/src/core/models/login_models/user.dart';

class LoginBloc extends Bloc<LoginEvent, LoginState> {
  LoginBloc()
      : super(const LoginStateWithData(isLoggedIn: false, user: User.empty)) {
    on<FacebookLogInEvent>(_onFacebookLogIn);
  }
  _onFacebookLogIn(FacebookLogInEvent event, Emitter<LoginState> emit) async {}
}
