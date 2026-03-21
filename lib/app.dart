import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:pofel_app/constants.dart';
import 'package:pofel_app/src/core/bloc/chat_bloc/chat_bloc.dart';
import 'package:pofel_app/src/core/bloc/kybl_creation_bloc/kybl_creation_bloc.dart';
import 'package:pofel_app/src/core/bloc/kyblspot_bloc/kyblspot_bloc.dart';
import 'package:pofel_app/src/core/bloc/load_pofels_bloc/loadpofels_bloc.dart';
import 'package:pofel_app/src/core/bloc/login_bloc/login_bloc.dart';
import 'package:pofel_app/src/core/bloc/login_bloc/login_state.dart';
import 'package:pofel_app/src/core/bloc/navigation_bloc/navigation_bloc.dart';
import 'package:pofel_app/src/core/bloc/pofel_bloc/pofel_bloc.dart';
import 'package:pofel_app/src/core/bloc/public_pofel_bloc/public_pofel_bloc.dart';
import 'package:pofel_app/src/core/bloc/social_bloc/social_bloc.dart';
import 'package:pofel_app/src/ui/pages/invite_link_page.dart';
import 'package:pofel_app/src/ui/pages/log_in_page.dart';
import 'package:pofel_app/src/ui/pages/main_page.dart';
import 'package:pofel_app/src/ui/components/pofel_design.dart';

class PofelApp extends StatelessWidget {
  const PofelApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider<NavigationBloc>(create: (ctx) => NavigationBloc()),
        BlocProvider<LoginBloc>(create: (ctx) => LoginBloc()),
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
                  if (state.invite == "") {
                    return MainPage();
                  } else {
                    return (InviteLinkPage(
                      joinId: state.inviteId,
                    ));
                  }
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
