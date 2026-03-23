import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pofel_app/src/core/bloc/login_bloc/login_bloc.dart';
import 'package:pofel_app/src/core/bloc/login_bloc/login_event.dart';
import 'package:pofel_app/src/core/bloc/login_bloc/login_state.dart';
import 'package:pofel_app/src/ui/components/pofel_design.dart';
import 'package:pofel_app/src/ui/components/snack_bar_error.dart';

class LogInPage extends StatefulWidget {
  const LogInPage({super.key});

  @override
  State<LogInPage> createState() => _LogInPageState();
}

class _LogInPageState extends State<LogInPage> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final GlobalKey<FormState> _emailSignInFormKey = GlobalKey<FormState>();
  bool _isEmailFormVisible = false;

  void _refreshLoginState() {
    if (!mounted) {
      return;
    }
    BlocProvider.of<LoginBloc>(context).add(const LogInInitial());
  }

  void _submitEmailPasswordLogIn() {
    final isValid = _emailSignInFormKey.currentState?.validate() ?? false;
    if (!isValid) {
      return;
    }

    FocusScope.of(context).unfocus();
    BlocProvider.of<LoginBloc>(context).add(
      EmailPasswordLogInEvent(
        email: _emailController.text.trim(),
        password: _passwordController.text,
      ),
    );
  }

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) => _refreshLoginState());
    WidgetsBinding.instance.addObserver(_lifecycleObserver);
  }

  late final WidgetsBindingObserver _lifecycleObserver = _LoginLifecycleObserver(onResumed: _refreshLoginState);

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(_lifecycleObserver);
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: PofelScreenBackground(
        showBottomBlobs: true,
        child: BlocListener<LoginBloc, LoginState>(
          listener: (context, state) {
            if (state is LoginStateWithData && state.loginStateEnum == LoginStateEnum.logInFailed) {
              ScaffoldMessenger.of(context)
                ..hideCurrentSnackBar()
                ..showSnackBar(SnackBarError(
                  context,
                  state.errorMessage ?? "Chyba při přihlašování",
                ));
            }
          },
          child: SingleChildScrollView(
            padding: const EdgeInsets.fromLTRB(24, 50, 24, 50),
            child: ConstrainedBox(
              constraints: BoxConstraints(
                minHeight: MediaQuery.of(context).size.height - 100,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const Align(
                        alignment: Alignment.centerLeft,
                        child: PofelWordmark(showVersion: true, size: 64),
                      ),
                      const SizedBox(height: 200),
                      PofelGradientButton(
                        label: _isEmailFormVisible ? 'Skrýt email login' : 'Email Login',
                        icon: Icons.mail_outline_rounded,
                        onPressed: () {
                          setState(() {
                            _isEmailFormVisible = !_isEmailFormVisible;
                          });
                        },
                      ),
                      AnimatedContainer(
                        duration: const Duration(milliseconds: 260),
                        curve: Curves.easeOutCubic,
                        margin: EdgeInsets.only(
                          top: _isEmailFormVisible ? 16 : 0,
                          bottom: _isEmailFormVisible ? 12 : 0,
                        ),
                        padding: EdgeInsets.all(_isEmailFormVisible ? 18 : 0),
                        decoration: BoxDecoration(
                          color: Colors.white.withValues(alpha: 0.94),
                          borderRadius: BorderRadius.circular(28),
                          boxShadow: _isEmailFormVisible
                              ? const [
                                  BoxShadow(
                                    color: PofelPalette.shadow,
                                    blurRadius: 16,
                                    offset: Offset(0, 8),
                                  ),
                                ]
                              : const [],
                        ),
                        child: ClipRect(
                          child: AnimatedAlign(
                            duration: const Duration(milliseconds: 260),
                            curve: Curves.easeOutCubic,
                            alignment: Alignment.topCenter,
                            heightFactor: _isEmailFormVisible ? 1 : 0,
                            child: AnimatedOpacity(
                              duration: const Duration(milliseconds: 180),
                              opacity: _isEmailFormVisible ? 1 : 0,
                              child: _EmailLoginForm(
                                formKey: _emailSignInFormKey,
                                emailController: _emailController,
                                passwordController: _passwordController,
                                onSubmit: _submitEmailPasswordLogIn,
                              ),
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(height: 16),
                      PofelAppleSignInButton(
                        onPressed: () {
                          BlocProvider.of<LoginBloc>(context).add(
                            AppleLogInEvent(),
                          );
                        },
                      ),
                      const SizedBox(height: 16),
                      PofelGradientButton(
                        label: 'Google Login',
                        icon: Icons.g_mobiledata_rounded,
                        gradient: PofelPalette.warmGradient,
                        onPressed: () {
                          BlocProvider.of<LoginBloc>(context).add(
                            GoogleLogInEvent(),
                          );
                        },
                      ),
                    ],
                  ),
                  Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        'Při prvním přihlášení vytvoříme tvůj profil. Jméno i fotku pak upravíš v profilu.',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          color: Colors.white.withValues(alpha: 0.94),
                          fontSize: 14,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                      const SizedBox(height: 36),
                      const Text(
                        'By: Matyáš Krejza - © Padisoft',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 14,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _EmailLoginForm extends StatelessWidget {
  const _EmailLoginForm({
    required this.formKey,
    required this.emailController,
    required this.passwordController,
    required this.onSubmit,
  });

  final GlobalKey<FormState> formKey;
  final TextEditingController emailController;
  final TextEditingController passwordController;
  final VoidCallback onSubmit;

  @override
  Widget build(BuildContext context) {
    return Form(
      key: formKey,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        mainAxisSize: MainAxisSize.min,
        children: [
          const Text(
            'Přihlášení emailem',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w800,
              color: PofelPalette.text,
            ),
          ),
          const SizedBox(height: 6),
          Text(
            'Použij email a heslo, které máš nastavené v Appwrite účtu.',
            style: TextStyle(
              color: Colors.black.withValues(alpha: 0.65),
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: 16),
          TextFormField(
            controller: emailController,
            keyboardType: TextInputType.emailAddress,
            autofillHints: const [AutofillHints.username],
            decoration: InputDecoration(
              labelText: 'Email',
              filled: true,
              fillColor: const Color(0xFFF8F6FB),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(18),
              ),
            ),
            validator: (value) {
              final email = value?.trim() ?? '';
              if (email.isEmpty) {
                return 'Zadej email.';
              }
              if (!email.contains('@')) {
                return 'Zadej platný email.';
              }
              return null;
            },
          ),
          const SizedBox(height: 12),
          TextFormField(
            controller: passwordController,
            obscureText: true,
            autofillHints: const [AutofillHints.password],
            decoration: InputDecoration(
              labelText: 'Heslo',
              filled: true,
              fillColor: const Color(0xFFF8F6FB),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(18),
              ),
            ),
            validator: (value) {
              if ((value ?? '').isEmpty) {
                return 'Zadej heslo.';
              }
              return null;
            },
            onFieldSubmitted: (_) => onSubmit(),
          ),
          const SizedBox(height: 14),
          PofelGradientButton(
            label: 'Přihlásit se emailem',
            icon: Icons.login_rounded,
            onPressed: onSubmit,
          ),
        ],
      ),
    );
  }
}

class _LoginLifecycleObserver extends WidgetsBindingObserver {
  _LoginLifecycleObserver({required this.onResumed});

  final VoidCallback onResumed;

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.resumed) {
      onResumed();
    }
  }
}
