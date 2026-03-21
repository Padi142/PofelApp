import 'package:bloc/bloc.dart';
import 'package:appwrite/enums.dart' as appwrite_enums;
import 'package:flutter/foundation.dart';
import 'package:pofel_app/src/core/appwrite/app_services.dart';
import 'package:pofel_app/src/core/bloc/login_bloc/login_event.dart';
import 'package:pofel_app/src/core/bloc/login_bloc/login_state.dart';
import 'package:pofel_app/src/core/models/login_models/user.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LoginBloc extends Bloc<LoginEvent, LoginState> {
  LoginBloc()
      : super(const LoginStateWithData(
            isLoggedIn: false,
            user: UserModel.empty,
            invite: "",
            inviteId: "",
            errorMessage: null,
            loginStateEnum: LoginStateEnum.notLoggedIn)) {
    on<GoogleLogInEvent>(
      (event, emit) => _onOAuthLogIn(appwrite_enums.OAuthProvider.google, emit),
    );
    on<AppleLogInEvent>(
      (event, emit) => _onOAuthLogIn(appwrite_enums.OAuthProvider.apple, emit),
    );
    on<EmailPasswordLogInEvent>(_onEmailPasswordLogIn);
    on<LogOut>(_onLogOut);
    on<LogInInitial>(_onInitial);
    on<ReturnFromInvite>(_onReturnFromInivte);
  }
  final AppAuthService _authService = AppAuthService();
  final AppTelemetry _telemetry = AppTelemetry();

  Future<void> _onInitial(LogInInitial event, Emitter<LoginState> emit) async {
    final prefs = await SharedPreferences.getInstance();
    try {
      final logedInUser = await _authService.currentUser();
      if (logedInUser != null) {
        await prefs.setString("uid", logedInUser.uid);
        await _telemetry.setUserId(logedInUser.uid);
        emit((state as LoginStateWithData).copyWith(
            isLoggedIn: true,
            user: logedInUser,
            errorMessage: null,
            loginStateEnum: LoginStateEnum.loggedIn));
      }
    } catch (e, st) {
      _logLoginError('Failed to restore the current session', e, st);
    }
  }

  Future<void> _onEmailPasswordLogIn(
    EmailPasswordLogInEvent event,
    Emitter<LoginState> emit,
  ) async {
    final prefs = await SharedPreferences.getInstance();
    try {
      final logedInUser = await _authService.signInWithEmailPassword(
        email: event.email.trim(),
        password: event.password,
      );
      await prefs.setString("uid", logedInUser.uid);
      await _telemetry.setUserId(logedInUser.uid);

      emit((state as LoginStateWithData).copyWith(
          isLoggedIn: true,
          user: logedInUser,
          errorMessage: null,
          loginStateEnum: LoginStateEnum.loggedIn));
    } on AppAuthException catch (e, st) {
      _logLoginError('Email/password login failed', e, st);
      emit((state as LoginStateWithData).copyWith(
          errorMessage: e.userMessage,
          loginStateEnum: LoginStateEnum.logInFailed));
    } catch (e, st) {
      _logLoginError('Unexpected email/password login failure', e, st);
      emit((state as LoginStateWithData).copyWith(
          errorMessage: 'Chyba pri prihlasovani. Zkus to prosim znovu.',
          loginStateEnum: LoginStateEnum.logInFailed));
    }
  }

  Future<void> _onOAuthLogIn(
    appwrite_enums.OAuthProvider provider,
    Emitter<LoginState> emit,
  ) async {
    final prefs = await SharedPreferences.getInstance();
    try {
      final logedInUser = await _authService.signInWithProvider(provider);
      await prefs.setString("uid", logedInUser.uid);
      await _telemetry.setUserId(logedInUser.uid);

      emit((state as LoginStateWithData).copyWith(
          isLoggedIn: true,
          user: logedInUser,
          errorMessage: null,
          loginStateEnum: LoginStateEnum.loggedIn));
    } on AppAuthException catch (e, st) {
      _logLoginError('${provider.name} login failed', e, st);
      emit((state as LoginStateWithData).copyWith(
          errorMessage: e.userMessage,
          loginStateEnum: LoginStateEnum.logInFailed));
    } catch (e, st) {
      _logLoginError('Unexpected login failure', e, st);
      emit((state as LoginStateWithData).copyWith(
          errorMessage: 'Chyba pri prihlasovani. Zkus to prosim znovu.',
          loginStateEnum: LoginStateEnum.logInFailed));
    }
  }

  Future<void> _onLogOut(LogOut event, Emitter<LoginState> emit) async {
    await _authService.signOut();
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove("uid");

    emit((state as LoginStateWithData).copyWith(
        isLoggedIn: false,
        user: UserModel.empty,
        errorMessage: null,
        loginStateEnum: LoginStateEnum.notLoggedIn));
  }

  Future<void> _onReturnFromInivte(
    ReturnFromInvite event,
    Emitter<LoginState> emit,
  ) async {
    emit((state as LoginStateWithData).copyWith(
      invite: "",
      inviteId: "",
    ));
  }

  void _logLoginError(String context, Object error, StackTrace stackTrace) {
    debugPrint('$context: $error');
    debugPrintStack(stackTrace: stackTrace);
  }
}
