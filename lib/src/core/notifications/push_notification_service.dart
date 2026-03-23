import 'dart:async';

import 'package:appwrite/appwrite.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/foundation.dart';
import 'package:pofel_app/firebase_options.dart';
import 'package:pofel_app/src/core/appwrite/appwrite_environment.dart';
import 'package:pofel_app/src/core/appwrite/appwrite_services.dart';
import 'package:shared_preferences/shared_preferences.dart';

@pragma('vm:entry-point')
Future<void> firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  await PushNotificationService.ensureFirebaseInitialized();
}

class PushNotificationService {
  PushNotificationService({AppwriteServices? services})
      : _services = services ?? AppwriteServices.instance;

  static const _targetIdKey = 'appwrite_push_target_id';
  static const _tokenKey = 'appwrite_push_token';

  final AppwriteServices _services;
  final StreamController<RemoteMessage> _foregroundController =
      StreamController<RemoteMessage>.broadcast();

  StreamSubscription<String>? _tokenRefreshSubscription;
  StreamSubscription<RemoteMessage>? _foregroundSubscription;
  bool _initialized = false;

  static bool _firebaseReady = false;

  Stream<RemoteMessage> get foregroundMessages => _foregroundController.stream;

  static Future<bool> ensureFirebaseInitialized() async {
    if (kIsWeb) {
      return false;
    }

    if (_firebaseReady) {
      return true;
    }

    try {
      if (Firebase.apps.isEmpty) {
        await Firebase.initializeApp(
          options: DefaultFirebaseOptions.currentPlatform,
        );
      }
      _firebaseReady = true;
      return true;
    } catch (error, stackTrace) {
      debugPrint('Firebase push initialization failed: $error');
      debugPrintStack(stackTrace: stackTrace);
      return false;
    }
  }

  static Future<void> requestNotificationPermissions() async {
    final firebaseReady = await ensureFirebaseInitialized();
    if (!firebaseReady) {
      return;
    }

    await FirebaseMessaging.instance.requestPermission(
      alert: true,
      badge: true,
      sound: true,
      provisional: false,
    );
  }

  Future<void> initialize() async {
    if (_initialized) {
      return;
    }

    final firebaseReady = await ensureFirebaseInitialized();
    if (!firebaseReady) {
      return;
    }

    await requestNotificationPermissions();

    final token = await FirebaseMessaging.instance.getToken();
    if (token != null && token.isNotEmpty) {
      await _syncToken(token);
    }

    _tokenRefreshSubscription =
        FirebaseMessaging.instance.onTokenRefresh.listen(_syncToken);
    _foregroundSubscription =
        FirebaseMessaging.onMessage.listen(_foregroundController.add);
    _initialized = true;
  }

  Future<void> clearRegisteredTarget() async {
    final prefs = await SharedPreferences.getInstance();
    final targetId = prefs.getString(_targetIdKey);

    if (targetId != null && targetId.isNotEmpty) {
      try {
        await _services.account.deletePushTarget(targetId: targetId);
      } on AppwriteException catch (error, stackTrace) {
        debugPrint('Deleting push target failed: ${error.message}');
        debugPrintStack(stackTrace: stackTrace);
      } catch (error, stackTrace) {
        debugPrint('Deleting push target failed: $error');
        debugPrintStack(stackTrace: stackTrace);
      }
    }

    await prefs.remove(_targetIdKey);
    await prefs.remove(_tokenKey);
  }

  Future<void> dispose() async {
    await _tokenRefreshSubscription?.cancel();
    await _foregroundSubscription?.cancel();
    await _foregroundController.close();
    _initialized = false;
  }

  Future<void> _syncToken(String token) async {
    if (token.isEmpty) {
      return;
    }

    final prefs = await SharedPreferences.getInstance();
    final existingTargetId = prefs.getString(_targetIdKey);
    final existingToken = prefs.getString(_tokenKey);

    try {
      if (existingTargetId != null && existingTargetId.isNotEmpty) {
        if (existingToken != token) {
          await _services.account.updatePushTarget(
            targetId: existingTargetId,
            identifier: token,
          );
        }
      } else {
        final target = await _services.account.createPushTarget(
          targetId: ID.unique(),
          identifier: token,
          providerId: AppwriteEnvironment.pushProviderId.isEmpty
              ? null
              : AppwriteEnvironment.pushProviderId,
        );
        await prefs.setString(_targetIdKey, target.$id);
      }

      await prefs.setString(_tokenKey, token);
    } on AppwriteException catch (error, stackTrace) {
      debugPrint('Registering Appwrite push target failed: ${error.message}');
      debugPrintStack(stackTrace: stackTrace);
    } catch (error, stackTrace) {
      debugPrint('Registering Appwrite push target failed: $error');
      debugPrintStack(stackTrace: stackTrace);
    }
  }
}
