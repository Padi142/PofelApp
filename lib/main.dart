import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_facebook_auth/flutter_facebook_auth.dart';
import 'package:kyblspot_app/firebase_options.dart';
import 'app.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  initialuzeFacebook();
  runApp(KyblApp());
}

void initialuzeFacebook() {
  FacebookAuth.i.webInitialize(
    appId: "694344538221677", //<-- YOUR APP_ID
    cookie: true,
    xfbml: true,
    version: "v12.0",
  );
}
