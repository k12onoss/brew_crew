import 'package:brew_crew/shared/loading.dart';
import 'package:flutter/material.dart';
import 'package:brew_crew/services/authenticate.dart';
import 'package:brew_crew/shared/constants.dart';

class Register extends StatefulWidget {
  final Function toggleView;

  const Register({super.key, required this.toggleView});

  @override
  State<Register> createState() => _RegisterState();
}

class _RegisterState extends State<Register> {
  final AuthService _authServices = AuthService();
  final _formKey = GlobalKey<FormState>();
  String _email = '';
  String _password = '';
  final ValueNotifier<bool> _notifier = ValueNotifier<bool>(false);

  @override
  void dispose() {
    _formKey.currentState?.dispose();
    _notifier.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    void snackBar(String? message) {
      if (message != null) {
        RegExp exp = RegExp(r"\[[^()]*\]");
        String test = message.replaceAll(exp, "");
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              test,
              style: const TextStyle(color: Colors.white),
            ),
            backgroundColor: Colors.brown[400],
            showCloseIcon: true,
            closeIconColor: Colors.white,
            padding: const EdgeInsets.all(5.0),
            behavior: SnackBarBehavior.floating,
            elevation: 0.0,
            shape: OutlineInputBorder(
              borderSide: BorderSide(
                color: Colors.brown[400]!,
              ),
            ),
          ),
        );
      }
    }

    return Scaffold(
      backgroundColor: Colors.brown[100],
      appBar: AppBar(
        title: const Text('Sign up to brew crew'),
        backgroundColor: Colors.brown[400],
        elevation: 0.0,
      ),
      body: Container(
        padding: const EdgeInsets.symmetric(
          vertical: 20.0,
          horizontal: 20.0,
        ),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              const SizedBox(
                height: 20,
              ),
              TextFormField(
                decoration: textInputDecoration.copyWith(
                  hintText: 'Email',
                  icon: const Icon(Icons.email),
                ),
                onChanged: (value) {
                  _email = value;
                },
                validator: (value) =>
                    value == null || value.isEmpty ? 'Enter an email' : null,
              ),
              const SizedBox(
                height: 20.0,
              ),
              TextFormField(
                obscureText: true,
                decoration: textInputDecoration.copyWith(
                  hintText: 'Password',
                  icon: const Icon(Icons.password),
                ),
                onChanged: (value) {
                  _password = value;
                },
                validator: (value) => value == null || value.length < 6
                    ? 'Enter a password at least 6 chars long'
                    : null,
              ),
              const SizedBox(
                height: 20,
              ),
              ValueListenableBuilder(
                valueListenable: _notifier,
                builder: (context, value, _) => value
                    ? const Loading()
                    : ElevatedButton(
                        onPressed: () async {
                          if (_formKey.currentState!.validate()) {
                            _notifier.value = true;
                            var result = await _authServices
                                .registerWithEmailAndPassword(
                              _email,
                              _password,
                            );
                            if (result is ErrorDescription) {
                              snackBar(result.toDescription());
                              _notifier.value = false;
                            }
                          }
                        },
                        style: ButtonStyle(
                          backgroundColor: MaterialStateProperty.all<Color?>(
                              Colors.pink[400]),
                        ),
                        child: const Text(
                          'Register',
                          style: TextStyle(
                            color: Colors.white,
                          ),
                        ),
                      ),
              ),
              Expanded(
                child: SizedBox.expand(
                  child: Align(
                    alignment: Alignment.bottomCenter,
                    child: TextButton(
                      onPressed: () => widget.toggleView(),
                      child: const Text(
                        'Already have an account?',
                        style: TextStyle(color: Colors.pink),
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
