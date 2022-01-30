import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:pofel_app/constants.dart';
import 'package:pofel_app/src/core/bloc/navigation_bloc/navigation_bloc.dart';
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
      ],
      child: MaterialApp(
          theme: ThemeData(
              scaffoldBackgroundColor: Colors.white,
              canvasColor: primaryColor,
              textTheme: GoogleFonts.poppinsTextTheme()),
          home: MainPage()),
    );
  }
}
