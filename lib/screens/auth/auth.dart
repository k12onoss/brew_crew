import 'package:brew_crew/screens/auth/register.dart';
import 'package:brew_crew/screens/auth/sign_in.dart';
import 'package:flutter/material.dart';

class Auth extends StatefulWidget {
  const Auth({Key? key}) : super(key: key);

  @override
  State<Auth> createState() => _AuthState();
}

class _AuthState extends State<Auth> {
  bool _showSignIn = true;

  void toggleView() => setState(() => _showSignIn = !_showSignIn);

  @override
  Widget build(BuildContext context) {
    return _showSignIn
        ? SignIn(
            toggleView: toggleView,
          )
        : Register(
            toggleView: toggleView,
          );
  }
}
