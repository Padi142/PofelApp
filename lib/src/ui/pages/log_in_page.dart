import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:pofel_app/src/core/bloc/login_bloc/login_bloc.dart';
import 'package:pofel_app/src/core/bloc/login_bloc/login_event.dart';
import 'package:pofel_app/src/core/bloc/login_bloc/login_state.dart';
import 'package:pofel_app/src/ui/components/facebook_button.dart';
import 'package:pofel_app/src/ui/components/google_button.dart';
import 'package:pofel_app/src/ui/components/snack_bar_error.dart';
import 'package:the_apple_sign_in/apple_sign_in_button.dart' as appleUi;
import 'dart:io' show Platform;

class LogInPage extends StatefulWidget {
  LogInPage({Key? key}) : super(key: key);

  @override
  State<LogInPage> createState() => _DashboardPageState();
}

class _DashboardPageState extends State<LogInPage> {
  @override
  Widget build(BuildContext context) {
    BlocProvider.of<LoginBloc>(context).add(LogInInitial());
    return Scaffold(
      body: SafeArea(
        child: BlocListener<LoginBloc, LoginState>(
          listener: (context, state) {
            if (state is LoginStateWithData) {
              switch (state.loginStateEnum) {
                case LoginStateEnum.LOG_IN_FAILED:
                  ScaffoldMessenger.of(context).showSnackBar(
                      SnackBarError(context, "Chyba při přihlašování"));
                  break;
                default:
                  break;
              }
            }
          },
          child: Stack(
            children: [
              SvgPicture.asset(
                "assets/images/log_in_design.svg",
                fit: BoxFit.cover,
                height: double.infinity,
                width: double.infinity,
                alignment: Alignment.center,
                allowDrawingOutsideViewBox: true,
              ),
              Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const SizedBox(
                    height: 100,
                  ),
                  Align(
                    alignment: Alignment.center,
                    child: SizedBox(
                      width: MediaQuery.of(context).size.width / 1.5,
                      child: FacebookButton(
                        onpressed: () {
                          BlocProvider.of<LoginBloc>(context)
                              .add(FacebookLogInEvent());
                        },
                      ),
                    ),
                  ),
                  Platform.isAndroid
                      ? Align(
                          alignment: Alignment.center,
                          child: SizedBox(
                            width: MediaQuery.of(context).size.width / 1.5,
                            child: GoogleButton(
                              onpressed: () {
                                BlocProvider.of<LoginBloc>(context)
                                    .add(GoogleLogInEvent());
                              },
                            ),
                          ))
                      : Container(),
                  Platform.isIOS
                      ? Align(
                          alignment: Alignment.center,
                          child: Padding(
                            padding: const EdgeInsets.only(top: 12),
                            child: SizedBox(
                                width: MediaQuery.of(context).size.width / 1.65,
                                child: appleUi.AppleSignInButton(
                                  style: appleUi.ButtonStyle.black,
                                  onPressed: () {
                                    BlocProvider.of<LoginBloc>(context)
                                        .add(AppleLoginEvent());
                                  },
                                )),
                          ))
                      : Container(),
                ],
              ),
              Column(
                mainAxisAlignment: MainAxisAlignment.end,
                children: const [
                  Align(
                    alignment: Alignment.bottomCenter,
                    child: Text("By: Matyáš Krejza -  © Padisoft ",
                        style: TextStyle(color: Colors.white)),
                  ),
                  Align(
                    alignment: Alignment.bottomCenter,
                    child: Text("UI by: @obrazkymemikove",
                        style: TextStyle(color: Colors.white)),
                  ),
                  SizedBox(
                    height: 30,
                  )
                ],
              )
            ],
          ),
        ),
      ),
    );
  }
}
