import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:pofel_app/constants.dart';
import 'package:pofel_app/src/core/bloc/chat_bloc/chat_bloc.dart';
import 'package:pofel_app/src/core/bloc/load_pofels_bloc/loadpofels_bloc.dart';
import 'package:pofel_app/src/core/bloc/login_bloc/login_bloc.dart';
import 'package:pofel_app/src/core/bloc/login_bloc/login_state.dart';
import 'package:pofel_app/src/core/bloc/navigation_bloc/navigation_bloc.dart';
import 'package:pofel_app/src/core/bloc/pofel_bloc/pofel_bloc.dart';
import 'package:pofel_app/src/core/bloc/pofel_navigation_bloc/pofeldetailnavigation_bloc.dart';
import 'package:pofel_app/src/core/bloc/public_pofel_bloc/public_pofel_bloc.dart';
import 'package:pofel_app/src/ui/pages/invite_link_page.dart';
import 'package:pofel_app/src/ui/pages/log_in_page.dart';
import 'package:pofel_app/src/ui/pages/main_page.dart';

class PofelApp extends StatelessWidget {
  const PofelApp({
    Key? key,
  }) : super(key: key);

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
      ],
      child: MaterialApp(
          theme: ThemeData(
              scaffoldBackgroundColor: Colors.white,
              canvasColor: primaryColor,
              textTheme: GoogleFonts.poppinsTextTheme()),
          home: BlocBuilder<LoginBloc, LoginState>(
            builder: (context, state) {
              if (state is LoginStateWithData) {
                if (state.loginStateEnum == LoginStateEnum.LOGGED_IN) {
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
