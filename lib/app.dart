import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';

class PofelApp extends StatelessWidget {
  const PofelApp({
    Key? key,
  }) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [],
      child: MaterialApp(
          theme: ThemeData(
              scaffoldBackgroundColor: Colors.white,
              canvasColor: Colors.orange,
              textTheme: GoogleFonts.poppinsTextTheme()),
          home: const MapPage()),
    );
  }
}
