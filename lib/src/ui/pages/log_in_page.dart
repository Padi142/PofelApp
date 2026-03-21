import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pofel_app/src/core/bloc/login_bloc/login_bloc.dart';
import 'package:pofel_app/src/core/bloc/login_bloc/login_event.dart';
import 'package:pofel_app/src/core/bloc/login_bloc/login_state.dart';
import 'package:pofel_app/src/ui/components/snack_bar_error.dart';

class LogInPage extends StatefulWidget {
  const LogInPage({super.key});

  @override
  State<LogInPage> createState() => _DashboardPageState();
}

class _DashboardPageState extends State<LogInPage> {
  static const Color _brandColor = Color(0xFF8F3BB7);

  @override
  void initState() {
    super.initState();
    BlocProvider.of<LoginBloc>(context).add(LogInInitial());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: BlocListener<LoginBloc, LoginState>(
          listener: (context, state) {
            if (state is LoginStateWithData) {
              switch (state.loginStateEnum) {
                case LoginStateEnum.logInFailed:
                  ScaffoldMessenger.of(context)
                    ..hideCurrentSnackBar()
                    ..showSnackBar(SnackBarError(context,
                        state.errorMessage ?? "Chyba při přihlašování"));
                  break;
                default:
                  break;
              }
            }
          },
          child: Flex(
              direction: Axis.vertical,
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.max,
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Expanded(flex: 1, child: Container()),
                Expanded(
                  flex: 1,
                  child: Center(
                    child: Stack(
                      children: [
                        Padding(
                          padding: const EdgeInsets.only(left: 30, bottom: 8),
                          child: Transform(
                            transform: Matrix4.rotationZ(-5),
                            alignment: FractionalOffset.center,
                            child: Container(
                              width: 80,
                              height: 100,
                              color: _brandColor,
                            ),
                          ),
                        ),
                        const Text(
                          "Pofel app",
                          style: TextStyle(
                              fontWeight: FontWeight.bold, fontSize: 50),
                        ),
                      ],
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 25),
                  child: Text(
                    'Vyber si zpusob, jak pokracovat do aplikace.',
                    textAlign: TextAlign.center,
                    style: TextStyle(color: Colors.grey.shade700, fontSize: 15),
                  ),
                ),
                Flexible(
                  child: Padding(
                    padding: const EdgeInsets.only(
                        left: 25, right: 25, top: 10, bottom: 5),
                    child: SizedBox(
                      width: double.infinity,
                      child: OutlinedButton(
                        onPressed: () {
                          BlocProvider.of<LoginBloc>(context).add(
                            GoogleLogInEvent(),
                          );
                        },
                        style: OutlinedButton.styleFrom(
                          foregroundColor: Colors.black87,
                          backgroundColor: Colors.white,
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(30.0)),
                          side:
                              BorderSide(width: 1, color: Colors.grey.shade300),
                        ),
                        child: const Padding(
                          padding: EdgeInsets.all(12.0),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              _GoogleIcon(),
                              SizedBox(width: 12),
                              Text('Pokracovat s Googlem'),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
                Flexible(
                  child: Padding(
                    padding: const EdgeInsets.only(
                        left: 25, right: 25, top: 10, bottom: 5),
                    child: SizedBox(
                      width: double.infinity,
                      child: OutlinedButton(
                        onPressed: () {
                          BlocProvider.of<LoginBloc>(context).add(
                            AppleLogInEvent(),
                          );
                        },
                        style: OutlinedButton.styleFrom(
                          foregroundColor: Colors.white,
                          backgroundColor: Colors.black,
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(30.0)),
                          side: const BorderSide(width: 1, color: Colors.black),
                        ),
                        child: const Padding(
                          padding: EdgeInsets.all(12.0),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              _AppleIcon(),
                              SizedBox(width: 12),
                              Text('Pokracovat s Applem'),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
                Flexible(
                  child: Padding(
                    padding: const EdgeInsets.only(
                        left: 25, right: 25, top: 10, bottom: 5),
                    child: SizedBox(
                      width: double.infinity,
                      child: Text(
                        'Pri prvnim prihlaseni vytvorime tvuj profil. Jmeno a fotku pak muzes zmenit v profilu.',
                        textAlign: TextAlign.center,
                        style: TextStyle(color: Colors.grey.shade700),
                      ),
                    ),
                  ),
                ),
                Expanded(flex: 3, child: Container()),
                const Expanded(
                  child:
                      Center(child: Text("By: Matyáš Krejza -  © Padisoft ")),
                ),
              ]),
        ),
      ),
    );
  }
}

class _GoogleIcon extends StatelessWidget {
  const _GoogleIcon();

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 22,
      height: 22,
      decoration: const BoxDecoration(
        color: Colors.white,
        shape: BoxShape.circle,
      ),
      alignment: Alignment.center,
      child: RichText(
        text: const TextSpan(
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w700,
            height: 1,
          ),
          children: [
            TextSpan(text: 'G', style: TextStyle(color: Color(0xFF4285F4))),
            TextSpan(text: '', style: TextStyle(color: Color(0xFF34A853))),
          ],
        ),
      ),
    );
  }
}

class _AppleIcon extends StatelessWidget {
  const _AppleIcon();

  @override
  Widget build(BuildContext context) {
    return const Icon(Icons.apple, size: 22, color: Colors.white);
  }
}
