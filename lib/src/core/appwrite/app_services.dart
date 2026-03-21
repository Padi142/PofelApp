import 'dart:math';

import 'package:appwrite/appwrite.dart';
import 'package:appwrite/enums.dart' as appwrite_enums;
import 'package:appwrite/models.dart' as models;
import 'package:flutter/foundation.dart';
import 'package:pofel_app/src/core/appwrite/appwrite_environment.dart';
import 'package:pofel_app/src/core/appwrite/appwrite_serializers.dart';
import 'package:pofel_app/src/core/appwrite/appwrite_services.dart';
import 'package:pofel_app/src/core/models/login_models/user.dart';

class AppAuthService {
  static const Duration _oauthSessionRetryDelay = Duration(milliseconds: 400);
  static const int _oauthSessionRetryCount = 5;

  AppAuthService({AppwriteServices? services, AppwriteRepository? repository})
      : _services = services ?? AppwriteServices.instance,
        _repository = repository ?? AppwriteRepository();

  final AppwriteServices _services;
  final AppwriteRepository _repository;

  Future<UserModel?> currentUser() async {
    if (!AppwriteEnvironment.hasProjectConfig ||
        !AppwriteEnvironment.hasDatabaseConfig) {
      return null;
    }
    try {
      final accountUser = await _services.account.get();
      return await _ensureUserProfile(accountUser);
    } on AppwriteException {
      return null;
    }
  }

  Future<UserModel> signInWithProvider(
    appwrite_enums.OAuthProvider provider,
  ) async {
    _validateLoginConfiguration();

    try {
      await _services.account.createOAuth2Session(
        provider: provider,
        success: _webOAuthRedirectUrl,
        failure: _webOAuthRedirectUrl,
      );
      final accountUser = await _waitForOAuthSession();
      return await _ensureUserProfile(accountUser);
    } on AppwriteException catch (error) {
      throw _mapAppwriteError(error);
    }
  }

  Future<UserModel> signInWithEmailPassword({
    required String email,
    required String password,
  }) async {
    _validateLoginConfiguration();

    try {
      await _services.account.createEmailPasswordSession(
        email: email,
        password: password,
      );
      final accountUser = await _services.account.get();
      return await _ensureUserProfile(accountUser);
    } on AppwriteException catch (error) {
      throw _mapAppwriteError(error);
    }
  }

  Future<models.User> _waitForOAuthSession() async {
    AppwriteException? lastError;

    for (var attempt = 0; attempt < _oauthSessionRetryCount; attempt++) {
      try {
        return await _services.account.get();
      } on AppwriteException catch (error) {
        lastError = error;
        if (attempt == _oauthSessionRetryCount - 1) {
          rethrow;
        }
        await Future<void>.delayed(_oauthSessionRetryDelay);
      }
    }

    throw lastError ??
        AppwriteException('OAuth session was not available after callback.');
  }

  Future<void> signOut() async {
    if (!AppwriteEnvironment.hasProjectConfig) {
      return;
    }
    try {
      await _services.account.deleteSession(sessionId: 'current');
    } on AppwriteException {
      // No active session is fine during logout.
    }
  }

  Future<UserModel> _ensureUserProfile(models.User accountUser) async {
    final existingUser = await _repository.getDocument(
      AppwriteEnvironment.usersCollectionId,
      accountUser.$id,
    );
    if (existingUser != null) {
      return UserModel.fromMap(existingUser);
    }

    final generatedName = accountUser.name.isNotEmpty
        ? accountUser.name
        : 'Pofel ${accountUser.$id.substring(0, min(6, accountUser.$id.length))}';

    await _repository.createDocument(
      collectionId: AppwriteEnvironment.usersCollectionId,
      documentId: accountUser.$id,
      data: {
        'uid': accountUser.$id,
        'email': accountUser.email,
        'name': generatedName,
        'profile_pic':
            'https://ui-avatars.com/api/?background=8F3BB7&color=ffffff&name=${Uri.encodeComponent(generatedName)}',
        'isPremium': false,
        'premiumLevel': 0,
        'createdAt': serializeDateTime(DateTime.now()),
      },
    );

    return UserModel(
      uid: accountUser.$id,
      email: accountUser.email,
      name: generatedName,
      photo:
          'https://ui-avatars.com/api/?background=8F3BB7&color=ffffff&name=${Uri.encodeComponent(generatedName)}',
      isPremium: false,
    );
  }

  void _validateLoginConfiguration() {
    if (!AppwriteEnvironment.hasProjectConfig) {
      throw const AppAuthException(
        userMessage: 'Prihlaseni neni nakonfigurovane spravne.',
        debugMessage:
            'Appwrite login is missing APPWRITE_PROJECT_ID configuration.',
      );
    }

    if (!AppwriteEnvironment.hasDatabaseConfig) {
      throw const AppAuthException(
        userMessage:
            'Prihlaseni neni pripraveno. Zkontroluj nastaveni aplikace.',
        debugMessage:
            'Appwrite login is missing APPWRITE_DATABASE_ID configuration.',
      );
    }
  }

  String? get _webOAuthRedirectUrl {
    if (!kIsWeb) {
      return null;
    }

    final authUri = Uri.base.resolve('auth.html');
    return authUri.toString();
  }

  AppAuthException _mapAppwriteError(AppwriteException error) {
    final type = error.type?.toLowerCase() ?? '';
    final message = error.message ?? 'Unknown Appwrite error.';
    final details = [
      if (error.code != null) 'code=${error.code}',
      if (error.type != null) 'type=${error.type}',
      'message=$message',
    ].join(', ');

    if (type.contains('project')) {
      return AppAuthException(
        userMessage: 'Prihlaseni neni dostupne. Zkontroluj nastaveni projektu.',
        debugMessage: details,
      );
    }

    if (type.contains('database')) {
      return AppAuthException(
        userMessage:
            'Nepodarilo se nacist uzivatelsky profil. Zkus to pozdeji.',
        debugMessage: details,
      );
    }

    if (type.contains('collection')) {
      return AppAuthException(
        userMessage: 'Nepodarilo se dokoncit prihlaseni. Zkus to pozdeji.',
        debugMessage: details,
      );
    }

    if (type.contains('user_invalid_credentials') ||
        message.toLowerCase().contains('invalid credentials')) {
      return AppAuthException(
        userMessage: 'Neplatny email nebo heslo.',
        debugMessage: details,
      );
    }

    return AppAuthException(
      userMessage: 'Prihlaseni selhalo: $message',
      debugMessage: details,
    );
  }
}

class AppAuthException implements Exception {
  const AppAuthException({
    required this.userMessage,
    required this.debugMessage,
  });

  final String userMessage;
  final String debugMessage;

  @override
  String toString() => debugMessage;
}

class AppTelemetry {
  Future<void> setUserId(String id) async {}

  Future<void> logEvent(String name) async {}
}

class AppTopicSubscriptions {
  Future<void> subscribe(String topic) async {}

  Future<void> unsubscribe(String topic) async {}
}
