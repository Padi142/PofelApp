import 'dart:async';

import 'package:app_links/app_links.dart';
import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:pofel_app/constants.dart';
import 'package:pofel_app/src/core/bloc/chat_bloc/chat_bloc.dart';
import 'package:pofel_app/src/core/bloc/kybl_creation_bloc/kybl_creation_bloc.dart';
import 'package:pofel_app/src/core/bloc/kyblspot_bloc/kyblspot_bloc.dart';
import 'package:pofel_app/src/core/bloc/load_pofels_bloc/loadpofels_bloc.dart';
import 'package:pofel_app/src/core/bloc/login_bloc/login_bloc.dart';
import 'package:pofel_app/src/core/bloc/login_bloc/login_event.dart';
import 'package:pofel_app/src/core/bloc/login_bloc/login_state.dart';
import 'package:pofel_app/src/core/bloc/navigation_bloc/navigation_bloc.dart';
import 'package:pofel_app/src/core/notifications/push_notification_service.dart';
import 'package:pofel_app/src/core/bloc/pofel_bloc/pofel_bloc.dart';
import 'package:pofel_app/src/core/bloc/public_pofel_bloc/public_pofel_bloc.dart';
import 'package:pofel_app/src/core/bloc/social_bloc/social_bloc.dart';
import 'package:pofel_app/src/core/deep_links/pofel_deep_link_parser.dart';
import 'package:pofel_app/src/ui/pages/log_in_page.dart';
import 'package:pofel_app/src/ui/pages/main_page.dart';
import 'package:pofel_app/src/ui/components/pofel_design.dart';

class PofelApp extends StatefulWidget {
  const PofelApp({super.key});

  @override
  State<PofelApp> createState() => _PofelAppState();
}

class _PofelAppState extends State<PofelApp> {
  bool _permissionRequestScheduled = false;
  final LoginBloc _loginBloc = LoginBloc();
  final AppLinks _appLinks = AppLinks();
  StreamSubscription<Uri>? _deepLinkSubscription;

  @override
  void initState() {
    super.initState();
    _initializeDeepLinks();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (_permissionRequestScheduled) {
        return;
      }
      _permissionRequestScheduled = true;
      PushNotificationService.requestNotificationPermissions();
    });
  }

  Future<void> _initializeDeepLinks() async {
    final initialLink = await _appLinks.getInitialLink();
    _handleDeepLink(initialLink);
    _deepLinkSubscription = _appLinks.uriLinkStream.listen(_handleDeepLink);
  }

  void _handleDeepLink(Uri? uri) {
    final joinId = PofelDeepLinkParser.parseJoinId(uri);
    if (joinId == null || joinId.isEmpty) {
      return;
    }

    _loginBloc.add(ReceiveInviteLink(joinId: joinId));
  }

  @override
  void dispose() {
    _deepLinkSubscription?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider<NavigationBloc>(create: (ctx) => NavigationBloc()),
        BlocProvider<LoginBloc>(create: (ctx) => _loginBloc),
        BlocProvider<PofelBloc>(create: (ctx) => PofelBloc()),
        BlocProvider<LoadpofelsBloc>(create: (ctx) => LoadpofelsBloc()),
        BlocProvider<ChatBloc>(create: (ctx) => ChatBloc()),
        BlocProvider<PublicPofelBloc>(create: (ctx) => PublicPofelBloc()),
        BlocProvider<SocialBloc>(create: (ctx) => SocialBloc()),
        BlocProvider<KyblspotBloc>(create: (ctx) => KyblspotBloc()),
        BlocProvider<KyblCreationBloc>(create: (ctx) => KyblCreationBloc()),
      ],
      child: MaterialApp(
          debugShowCheckedModeBanner: false,
          locale: const Locale('cs', 'CZ'),
          supportedLocales: const [
            Locale('cs', 'CZ'),
          ],
          localizationsDelegates: const [
            GlobalMaterialLocalizations.delegate,
            GlobalWidgetsLocalizations.delegate,
            GlobalCupertinoLocalizations.delegate,
          ],
          theme: ThemeData(
            useMaterial3: true,
            scaffoldBackgroundColor: bgColor,
            canvasColor: primaryColor,
            colorScheme: ColorScheme.fromSeed(
              seedColor: PofelPalette.primary,
              brightness: Brightness.light,
              primary: PofelPalette.primary,
              secondary: PofelPalette.accentBlue,
              surface: Colors.white,
            ),
            textTheme: GoogleFonts.nunitoTextTheme(),
            snackBarTheme: SnackBarThemeData(
              behavior: SnackBarBehavior.floating,
              backgroundColor: PofelPalette.primaryDark,
              contentTextStyle: GoogleFonts.nunito(
                color: Colors.white,
                fontWeight: FontWeight.w700,
              ),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(18),
              ),
            ),
          ),
          home: BlocBuilder<LoginBloc, LoginState>(
            builder: (context, state) {
              if (state is LoginStateWithData) {
                if (state.loginStateEnum == LoginStateEnum.loggedIn) {
                  return const MainPage();
                } else {
                  return LogInPage();
                }
              } else {
                return const Center(
                  child: CircularProgressIndicator(),
                );
              }
            },
          )),
    );
  }
}
