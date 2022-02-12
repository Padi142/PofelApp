import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pofel_app/src/core/bloc/login_bloc/login_bloc.dart';
import 'package:pofel_app/src/core/bloc/login_bloc/login_event.dart';

class LogInPage extends StatefulWidget {
  LogInPage({Key? key}) : super(key: key);

  @override
  State<LogInPage> createState() => _DashboardPageState();
}

class _DashboardPageState extends State<LogInPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
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
                            color: const Color(0xFF8F3BB7),
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
              Flexible(
                child: Padding(
                  padding: const EdgeInsets.only(
                      left: 25, right: 25, top: 10, bottom: 5),
                  child: SizedBox(
                      width: double.infinity,
                      child: OutlinedButton(
                        onPressed: () {
                          BlocProvider.of<LoginBloc>(context)
                              .add(FacebookLogInEvent());
                        },
                        child: const Padding(
                          padding: EdgeInsets.all(8.0),
                          child: Text('Fb přihlášení',
                              style: TextStyle(color: Color(0xFF3b5998))),
                        ),
                        style: OutlinedButton.styleFrom(
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(30.0)),
                          side: const BorderSide(
                              width: 1, color: Color(0xFF3b5998)),
                        ),
                      )),
                ),
              ),
              Expanded(flex: 3, child: Container()),
            ]),
      ),
    );
  }
}
