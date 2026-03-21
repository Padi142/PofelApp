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
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final GlobalKey<FormState> _emailSignInFormKey = GlobalKey<FormState>();
  bool _isEmailFormVisible = false;

  @override
  void initState() {
    super.initState();
    BlocProvider.of<LoginBloc>(context).add(LogInInitial());
  }

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
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
          child: LayoutBuilder(
            builder: (context, constraints) {
              return SingleChildScrollView(
                padding:
                    const EdgeInsets.symmetric(horizontal: 25, vertical: 20),
                child: ConstrainedBox(
                  constraints: BoxConstraints(minHeight: constraints.maxHeight),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      const SizedBox(height: 32),
                      Center(
                        child: Stack(
                          children: [
                            Padding(
                              padding:
                                  const EdgeInsets.only(left: 30, bottom: 8),
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
                              'Pofel app',
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 50,
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 28),
                      Text(
                        'Vyber si zpusob, jak pokracovat do aplikace.',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                            color: Colors.grey.shade700, fontSize: 15),
                      ),
                      const SizedBox(height: 20),
                      _buildLoginButton(
                        label: _isEmailFormVisible
                            ? 'Skryt email prihlaseni'
                            : 'Pokracovat emailem',
                        icon: const Icon(Icons.mail_outline),
                        foregroundColor: Colors.black87,
                        backgroundColor: const Color(0xFFF6F1FA),
                        borderColor: const Color(0xFFD8C0E7),
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
                          top: _isEmailFormVisible ? 12 : 0,
                          bottom: _isEmailFormVisible ? 6 : 0,
                        ),
                        padding: EdgeInsets.all(_isEmailFormVisible ? 16 : 0),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(24),
                          border: Border.all(
                            color: const Color(0xFFE8D9F1),
                            width: _isEmailFormVisible ? 1 : 0,
                          ),
                          boxShadow: _isEmailFormVisible
                              ? [
                                  BoxShadow(
                                    color: _brandColor.withValues(alpha: 0.10),
                                    blurRadius: 24,
                                    offset: const Offset(0, 12),
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
                                brandColor: _brandColor,
                                onSubmit: _submitEmailPasswordLogIn,
                              ),
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(height: 10),
                      _buildLoginButton(
                        label: 'Pokracovat s Googlem',
                        icon: const _GoogleIcon(),
                        foregroundColor: Colors.black87,
                        backgroundColor: Colors.white,
                        borderColor: Colors.grey.shade300,
                        onPressed: () {
                          BlocProvider.of<LoginBloc>(context).add(
                            GoogleLogInEvent(),
                          );
                        },
                      ),
                      const SizedBox(height: 10),
                      _buildLoginButton(
                        label: 'Pokracovat s Applem',
                        icon: const _AppleIcon(),
                        foregroundColor: Colors.white,
                        backgroundColor: Colors.black,
                        borderColor: Colors.black,
                        onPressed: () {
                          BlocProvider.of<LoginBloc>(context).add(
                            AppleLogInEvent(),
                          );
                        },
                      ),
                      const SizedBox(height: 18),
                      Text(
                        'Pri prvnim prihlaseni vytvorime tvuj profil. Jmeno a fotku pak muzes zmenit v profilu.',
                        textAlign: TextAlign.center,
                        style: TextStyle(color: Colors.grey.shade700),
                      ),
                      const SizedBox(height: 24),
                      const Text(
                        'By: Matyas Krejza -  © Padisoft',
                        textAlign: TextAlign.center,
                      ),
                    ],
                  ),
                ),
              );
            },
          ),
        ),
      ),
    );
  }

  Widget _buildLoginButton({
    required String label,
    required Widget icon,
    required Color foregroundColor,
    required Color backgroundColor,
    required Color borderColor,
    required VoidCallback onPressed,
  }) {
    return SizedBox(
      width: double.infinity,
      child: OutlinedButton(
        onPressed: onPressed,
        style: OutlinedButton.styleFrom(
          foregroundColor: foregroundColor,
          backgroundColor: backgroundColor,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(30.0),
          ),
          side: BorderSide(width: 1, color: borderColor),
        ),
        child: Padding(
          padding: const EdgeInsets.all(12.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              icon,
              const SizedBox(width: 12),
              Text(label),
            ],
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
    required this.brandColor,
    required this.onSubmit,
  });

  final GlobalKey<FormState> formKey;
  final TextEditingController emailController;
  final TextEditingController passwordController;
  final Color brandColor;
  final VoidCallback onSubmit;

  @override
  Widget build(BuildContext context) {
    return Form(
      key: formKey,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            'Prihlaseni emailem',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w700,
              color: Colors.grey.shade900,
            ),
          ),
          const SizedBox(height: 6),
          Text(
            'Pouzij email a heslo, ktere mas nastavene v Appwrite uctu.',
            style: TextStyle(color: Colors.grey.shade600),
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
                return 'Zadej platny email.';
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
          FilledButton(
            onPressed: onSubmit,
            style: FilledButton.styleFrom(
              backgroundColor: brandColor,
              padding: const EdgeInsets.symmetric(vertical: 14),
            ),
            child: const Text('Prihlasit se emailem'),
          ),
        ],
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
