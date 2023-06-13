import 'package:brew_crew/models/user.dart';
import 'package:brew_crew/services/database.dart';
import 'package:brew_crew/shared/constants.dart';
import 'package:brew_crew/shared/loading.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:brew_crew/services/authenticate.dart';

class SettingForm extends StatefulWidget {
  const SettingForm({super.key});

  @override
  State<SettingForm> createState() => _SettingFormState();
}

class _SettingFormState extends State<SettingForm> {
  final _formKey = GlobalKey<FormState>();
  final List<String> _sugars = ['0', '1', '2', '3', '4'];
  String? _currentName;
  String? _currentSugars;
  final ValueNotifier<int?> _strength = ValueNotifier<int?>(null);

  @override
  void dispose() {
    _formKey.currentState?.dispose();
    _strength.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final user = Provider.of<CustomUser?>(context);

    void pop() => Navigator.pop(context);

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

    return StreamBuilder<UserData>(
      stream: DatabaseService(uid: user?.uid).userData,
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          UserData userData = snapshot.data!;
          return Container(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 30),
            color: Colors.brown[50],
            child: Form(
              key: _formKey,
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text(
                        'Brew settings',
                        style: TextStyle(fontSize: 18.0),
                      ),
                      IconButton(
                        onPressed: () async {
                          var result = await AuthService().signOut();
                          if (result is ErrorDescription) {
                            snackBar(result.toDescription());
                          }
                          pop();
                        },
                        icon: const Icon(Icons.logout),
                        tooltip: 'logout',
                      ),
                    ],
                  ),
                  const SizedBox(
                    height: 20.0,
                  ),
                  TextFormField(
                    initialValue: userData.name,
                    decoration: textInputDecoration.copyWith(hintText: 'Name'),
                    validator: (value) => value == '' || value == null
                        ? 'Please enter a name'
                        : null,
                    onChanged: (value) => _currentName = value,
                  ),
                  const SizedBox(
                    height: 20.0,
                  ),
                  DropdownButtonFormField(
                    decoration:
                        textInputDecoration.copyWith(hintText: 'Sugars'),
                    value: _currentSugars ?? userData.sugars,
                    items: _sugars
                        .map(
                          (sugar) => DropdownMenuItem(
                            value: sugar,
                            child: Text('$sugar sugar(s)'),
                          ),
                        )
                        .toList(),
                    onChanged: (value) => _currentSugars = value!,
                  ),
                  const SizedBox(
                    height: 20.0,
                  ),
                  ValueListenableBuilder(
                    valueListenable: _strength,
                    builder: (context, value, _) => Slider(
                      min: 100,
                      max: 900,
                      divisions: 8,
                      value: (_strength.value ?? userData.strength).toDouble(),
                      activeColor:
                          Colors.brown[_strength.value ?? userData.strength],
                      inactiveColor:
                          Colors.brown[_strength.value ?? userData.strength],
                      onChanged: (value) => _strength.value = value.toInt(),
                    ),
                  ),
                  const SizedBox(
                    height: 20.0,
                  ),
                  ElevatedButton(
                    onPressed: () async {
                      if (_formKey.currentState!.validate()) {
                        var result = await DatabaseService(uid: user?.uid)
                            .updateUserData(
                          _currentName ?? userData.name,
                          _currentSugars ?? userData.sugars,
                          _strength.value ?? userData.strength,
                        );
                        if (result is ErrorDescription) {
                          snackBar(result.toDescription());
                        }
                        print(_currentName);
                        print(_strength.value);
                        pop();
                      }
                    },
                    style: ButtonStyle(
                      backgroundColor:
                          MaterialStateProperty.all<Color>(Colors.pink[400]!),
                    ),
                    child: const Text('Update'),
                  )
                ],
              ),
            ),
          );
        } else {
          return const Loading();
        }
      },
    );
  }
}
