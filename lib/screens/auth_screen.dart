import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'dart:math';

import 'package:provider/provider.dart';
import 'package:section__8/exception/http_exception.dart';
import 'package:section__8/providers/auth.dart';
import 'package:section__8/screens/overview_screen.dart';

enum AuthMode { login, signin }

class AuthScreen extends StatefulWidget {
  static const route = '/auth';
  const AuthScreen({Key? key}) : super(key: key);

  @override
  State<AuthScreen> createState() => _AuthScreenState();
}

class _AuthScreenState extends State<AuthScreen> {
  final login = 'Login';
  final signin = 'Signin';
  final loginInstead = 'LOGIN INSTEAD';
  final signinInstead = 'SIGNIN INSTEAD';
  var authMode = AuthMode.login;
  final _key = GlobalKey<FormState>();
  final TextEditingController _pass = TextEditingController(text: '');
  late Auth auth;
  String email = '';
  String password = '';

  void swapMethod() {
    setState(() {
      authMode = authMode == AuthMode.login ? AuthMode.signin : AuthMode.login;
    });
  }

  @override
  void didChangeDependencies() {
    auth = Provider.of<Auth>(context);
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    var width = MediaQuery.of(context).size.width;
    return Scaffold(
      body: Container(
        width: double.infinity,
        height: double.infinity,
        alignment: Alignment.center,
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [
              Color.fromARGB(255, 255, 204, 255),
              Color.fromARGB(255, 255, 204, 153),
            ],
            begin: Alignment.topLeft,
          ),
        ),
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Transform.rotate(
                angle: -pi / 15,
                child: Container(
                  alignment: Alignment.center,
                  width: width - 150,
                  decoration: BoxDecoration(
                    color: Colors.redAccent,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  padding:
                      const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                  child: const Text(
                    'MyShop',
                    style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      fontSize: 36,
                    ),
                  ),
                ),
              ),
              const SizedBox(
                height: 36,
              ),
              Card(
                elevation: 16,
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16)),
                child: Container(
                  padding: const EdgeInsets.all(24),
                  width: width - 64,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(100),
                    color: Colors.white,
                  ),
                  child: Form(
                    key: _key,
                    child: Column(
                      children: [
                        TextFormField(
                          onSaved: (em) {
                            em = em ?? '';
                            email = em;
                          },
                          validator: (em) {
                            if (em == null) {
                              return null;
                            }
                            return RegExp(
                                        r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+")
                                    .hasMatch(em)
                                ? null
                                : 'Your email not correct!';
                          },
                          onFieldSubmitted: (value) {},
                          decoration:
                              const InputDecoration(labelText: 'E-mail'),
                        ),
                        const SizedBox(
                          height: 8,
                        ),
                        TextFormField(
                          controller: _pass,
                          onSaved: (pwd) {
                            pwd = pwd ?? '';
                            password = pwd;
                          },
                          obscureText: true,
                          validator: (value) {
                            return value != null
                                ? value.length > 8
                                    ? null
                                    : 'Your password need to longer'
                                : 'Your password need to longer';
                          },
                          decoration:
                              const InputDecoration(labelText: 'Password'),
                        ),
                        const SizedBox(
                          height: 8,
                        ),
                        Visibility(
                          visible: authMode == AuthMode.signin,
                          child: TextFormField(
                            validator: (value) {
                              return value == _pass.text
                                  ? null
                                  : 'Please, comfirm your password!';
                            },
                            obscureText: true,
                            decoration: const InputDecoration(
                                labelText: 'Confirm Password'),
                          ),
                        ),
                        const SizedBox(
                          height: 24,
                        ),
                        ElevatedButton(
                            style: ButtonStyle(
                              shape: MaterialStateProperty.all<
                                  RoundedRectangleBorder>(
                                RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(32),
                                ),
                              ),
                            ),
                            onPressed: () async {
                              var r = _key.currentState?.validate();
                              if (r != null && r) {
                                _key.currentState?.save();
                                try {
                                  if (authMode == AuthMode.login) {
                                    await auth.login(email, password);
                                  } else {
                                    await auth.signin(email, password);
                                  }
                                  if (mounted) {
                                    Navigator.pushReplacementNamed(
                                        context, OverviewScreen.route);
                                  }
                                } on HttpException catch (error) {
                                  var notice = '';
                                  switch (error.toString()) {
                                    case 'EMAIL_NOT_FOUND':
                                      notice =
                                          'There is no user record corresponding to this identifier. The user may have been deleted.';
                                      break;
                                    case 'INVALID_PASSWORD':
                                      notice =
                                          'The password is invalid or the user does not have a password.';
                                      break;
                                    case 'USER_DISABLED':
                                      notice =
                                          'The user account has been disabled by an administrator.';
                                      break;
                                    case 'EMAIL_EXISTS':
                                      notice =
                                          'The email address is already in use by another account.';
                                      break;
                                    case 'OPERATION_NOT_ALLOWED':
                                      notice =
                                          'Password sign-in is disabled for this project.';
                                      break;
                                    case 'TOO_MANY_ATTEMPTS_TRY_LATER':
                                      notice =
                                          'We have blocked all requests from this device due to unusual activity. Try again later.';
                                      break;
                                  }
                                  showDialog(
                                    context: context,
                                    builder: (context) {
                                      return AlertDialog(
                                        actions: [
                                          InkWell(
                                            onTap: () {
                                              Navigator.pop(context);
                                            },
                                            child: const Text(
                                              'OK',
                                              style: TextStyle(
                                                  color: Colors.purple),
                                            ),
                                          )
                                        ],
                                        title: const Text(
                                          'An Error Occurred!',
                                          style: TextStyle(
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                        content: Text(notice),
                                      );
                                    },
                                  );
                                  // ScaffoldMessenger.of(context).showSnackBar(
                                  //     SnackBar(content: Text(notice)));
                                }
                              }
                            },
                            child: Text(
                                authMode == AuthMode.login ? login : signin)),
                        ElevatedButton(
                          style: ButtonStyle(
                              elevation: MaterialStateProperty.all(0),
                              backgroundColor:
                                  MaterialStateProperty.all(Colors.white)),
                          onPressed: () {
                            swapMethod();
                          },
                          child: Text(
                            authMode == AuthMode.login
                                ? signinInstead
                                : loginInstead,
                            style: const TextStyle(color: Colors.purple),
                          ),
                        ),
                      ],
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
