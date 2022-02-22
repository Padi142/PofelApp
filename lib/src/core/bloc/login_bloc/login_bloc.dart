import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_dynamic_links/firebase_dynamic_links.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:pofel_app/src/core/bloc/login_bloc/login_event.dart';
import 'package:pofel_app/src/core/bloc/login_bloc/login_state.dart';
import 'package:pofel_app/src/core/bloc/navigation_bloc/navigation_bloc.dart';
import 'package:pofel_app/src/core/models/login_models/user.dart';
import 'package:flutter_facebook_auth/flutter_facebook_auth.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LoginBloc extends Bloc<LoginEvent, LoginState> {
  LoginBloc()
      : super(const LoginStateWithData(
            isLoggedIn: false,
            user: UserModel.empty,
            invite: "",
            inviteId: "",
            loginStateEnum: LoginStateEnum.NOT_LOGGED_IN)) {
    on<FacebookLogInEvent>(_onFacebookLogIn);
    on<GoogleLogInEvent>(_onGoogleLogIn);
    on<LogOut>(_onLogOut);
    on<LogInInitial>(_onInitial);
    on<ReturnFromInvite>(_onReturnFromInivte);
  }
  _onInitial(LogInInitial event, Emitter<LoginState> emit) async {
    final prefs = await SharedPreferences.getInstance();
    final FirebaseAuth auth = FirebaseAuth.instance;

    if (auth.currentUser != null) {
      UserModel logedInUser = UserModel(
          uid: (auth.currentUser!.uid), name: auth.currentUser!.displayName);
      prefs.setString("uid", auth.currentUser!.uid);

      final PendingDynamicLinkData? initialLink =
          await FirebaseDynamicLinks.instance.getInitialLink();

      if (initialLink != null) {
        var pofelId = initialLink.link
            .toString()
            .substring(initialLink.link.toString().length - 5);

        emit((state as LoginStateWithData).copyWith(
            invite: initialLink.link.toString(),
            inviteId: pofelId,
            user: logedInUser,
            loginStateEnum: LoginStateEnum.LOGGED_IN));
      }

      emit((state as LoginStateWithData).copyWith(
          user: logedInUser, loginStateEnum: LoginStateEnum.LOGGED_IN));
    }
  }

  //When fecebook log in
  _onFacebookLogIn(FacebookLogInEvent event, Emitter<LoginState> emit) async {
    final prefs = await SharedPreferences.getInstance();
    // Trigger the sign-in flow
    try {
      final LoginResult loginResult = await FacebookAuth.instance.login();

      // Create a credential from the access token
      final OAuthCredential facebookAuthCredential =
          FacebookAuthProvider.credential(loginResult.accessToken!.token);

      // Once signed in, return the UserCredential
      var userCredential = await FirebaseAuth.instance
          .signInWithCredential(facebookAuthCredential);

      //Check if user was created, emit state
      UserModel logedInUser = UserModel(
          uid: userCredential.user!.uid,
          name: userCredential.user!.displayName);
      prefs.setString("uid", userCredential.user!.uid);
      emit((state as LoginStateWithData).copyWith(
          user: logedInUser, loginStateEnum: LoginStateEnum.LOGGED_IN));
    } catch (e) {
      print(e);
      emit((state as LoginStateWithData)
          .copyWith(loginStateEnum: LoginStateEnum.LOG_IN_FAILED));
    }
  }

  _onGoogleLogIn(GoogleLogInEvent event, Emitter<LoginState> emit) async {
    final prefs = await SharedPreferences.getInstance();
    // Trigger the sign-in flow
    try {
      final FirebaseAuth _auth = FirebaseAuth.instance;
      final GoogleSignIn _googleSignIn = GoogleSignIn();

      final GoogleSignInAccount? googleSignInAccount =
          await _googleSignIn.signIn();
      final GoogleSignInAuthentication googleSignInAuthentication =
          await googleSignInAccount!.authentication;
      final AuthCredential credential = GoogleAuthProvider.credential(
        accessToken: googleSignInAuthentication.accessToken,
        idToken: googleSignInAuthentication.idToken,
      );
      await _auth.signInWithCredential(credential);

      User? user = FirebaseAuth.instance.currentUser;

      UserModel logedInUser = UserModel(
        uid: user!.uid,
        name: user.displayName,
      );
      prefs.setString("uid", user.uid);
      emit((state as LoginStateWithData).copyWith(
          user: logedInUser, loginStateEnum: LoginStateEnum.LOGGED_IN));
    } catch (_) {
      emit((state as LoginStateWithData)
          .copyWith(loginStateEnum: LoginStateEnum.LOG_IN_FAILED));
    }
  }

  _onLogOut(LogOut event, Emitter<LoginState> emit) async {
    await FirebaseAuth.instance.signOut();

    emit((state as LoginStateWithData)
        .copyWith(loginStateEnum: LoginStateEnum.LOG_IN_FAILED));
  }

  _onReturnFromInivte(ReturnFromInvite event, Emitter<LoginState> emit) async {
    emit((state as LoginStateWithData).copyWith(
      invite: "",
      inviteId: "",
    ));
  }
}
