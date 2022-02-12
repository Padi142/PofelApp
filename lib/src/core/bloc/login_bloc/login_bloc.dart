import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:pofel_app/src/core/bloc/login_bloc/login_event.dart';
import 'package:pofel_app/src/core/bloc/login_bloc/login_state.dart';
import 'package:pofel_app/src/core/models/login_models/user.dart';
import 'package:flutter_facebook_auth/flutter_facebook_auth.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LoginBloc extends Bloc<LoginEvent, LoginState> {
  LoginBloc()
      : super(const LoginStateWithData(
            isLoggedIn: false,
            user: UserModel.empty,
            loginStateEnum: LoginStateEnum.NOT_LOGGED_IN)) {
    on<FacebookLogInEvent>(_onFacebookLogIn);
  }
  //When fecebook log in
  _onFacebookLogIn(FacebookLogInEvent event, Emitter<LoginState> emit) async {
    final prefs = await SharedPreferences.getInstance();
    // Trigger the sign-in flow
    final LoginResult loginResult = await FacebookAuth.instance.login();

    // Create a credential from the access token
    final OAuthCredential facebookAuthCredential =
        FacebookAuthProvider.credential(loginResult.accessToken!.token);

    // Once signed in, return the UserCredential
    var userCredential = await FirebaseAuth.instance
        .signInWithCredential(facebookAuthCredential);

    //Check if user was created, emit state
    if (userCredential.user != null) {
      UserModel logedInUser = UserModel(
          uid: userCredential.user!.uid,
          name: userCredential.user!.displayName);
      prefs.setString("uid", userCredential.user!.uid);
      emit((state as LoginStateWithData).copyWith(
          user: logedInUser, loginStateEnum: LoginStateEnum.LOGGED_IN));
    } else {
      emit((state as LoginStateWithData)
          .copyWith(loginStateEnum: LoginStateEnum.LOG_IN_FAILED));
    }
  }
}
