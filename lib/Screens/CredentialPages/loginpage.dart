import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:provider/provider.dart';
import 'package:rituniversity/Animation/Animation.Dart';
import 'package:rituniversity/Consents/colors.dart';
import 'package:rituniversity/Consents/helperfunctions.dart';
import 'package:rituniversity/Consents/routes.dart';
import 'package:google_fonts/google_fonts.dart';
import 'dart:async';

import 'package:rituniversity/Provider/authentication_provider.dart';
import 'package:rituniversity/Provider/credentialprovider.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final _formKey = GlobalKey<FormState>();

  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  bool _obsecureText = true;
  Timer? _timer;
  bool _rememberMe = false;

  void _toggleObscureText() {
    setState(() {
      _obsecureText = !_obsecureText;
    });

    if (!_obsecureText) {
      _timer?.cancel();
      _timer = Timer(const Duration(seconds: 1), () {
        setState(() {
          _obsecureText = true;
        });
      });
    }
  }

  Future<void> _loadSavedCredentials() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? username = prefs.getString('username');
    String? password = prefs.getString('password');

    setState(() {
      _usernameController.text = username ?? '';
      _passwordController.text = password ?? '';
      _rememberMe = (username != null && password != null);
    });
  }

  Future<void> _saveCredentials(String username, String password) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString('username', username);
    await prefs.setString('password', password);
  }

  Future<void> _clearCredentials() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.remove('username');
    await prefs.remove('password');
  }

  @override
  void initState() {
    super.initState();
    _loadSavedCredentials();
  }

  @override
  void dispose() {
    _usernameController.dispose();
    _passwordController.dispose();
    _timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: FadeAnimation(1.6,
            Consumer<AuthProvider>(builder: (context, authProvider, child) {
      return authProvider.isLoading
          ? Center(
              child: const CircularProgressIndicator(
                color: mainColor,
              ),
            )
          : Container(
              width: double.infinity,
              decoration: const BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  colors: [mainColor, secColor, terColor],
                ),
              ),
              child: Column(
                children: <Widget>[
                  const SizedBox(height: 80),
                  Padding(
                    padding: const EdgeInsets.all(20),
                    child: Container(
                      alignment: Alignment.topLeft,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          FadeAnimation(
                              1,
                              Text(
                                "Login",
                                style: GoogleFonts.alef(
                                    textStyle: const TextStyle(
                                        color: Colors.white, fontSize: 40)),
                              )),
                          const SizedBox(height: 10),
                          FadeAnimation(
                            1.3,
                            const Text("Welcome Back",
                                style: TextStyle(
                                    color: Colors.white, fontSize: 18)),
                          ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 20),
                  Expanded(
                    child: Stack(
                      children: [
                        Container(
                          height: double.infinity,
                          decoration: const BoxDecoration(
                            boxShadow: [
                              BoxShadow(
                                color: Color.fromRGBO(225, 95, 27, .3),
                                blurRadius: 20,
                                offset: Offset(0, 10),
                              )
                            ],
                            color: Colors.white,
                            borderRadius: BorderRadius.only(
                              topLeft: Radius.circular(60),
                              topRight: Radius.circular(60),
                            ),
                          ),
                          child: SingleChildScrollView(
                            child: Padding(
                              padding: const EdgeInsets.all(20),
                              child: Column(
                                children: <Widget>[
                                  const SizedBox(height: 60),
                                  Padding(
                                    padding: const EdgeInsets.all(16.0),
                                    child: Form(
                                      key: _formKey,
                                      child: Column(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: [
                                          FadeAnimation(
                                              1.4,
                                              TextFormField(
                                                controller: _usernameController,
                                                decoration:
                                                    const InputDecoration(
                                                  hintText: 'Username',
                                                  border: InputBorder.none,
                                                ),
                                                validator: (value) {
                                                  if (value == null ||
                                                      value.isEmpty) {
                                                    return 'Please enter your Username';
                                                  }
                                                  return null;
                                                },
                                              )),
                                          const SizedBox(height: 40),
                                          FadeAnimation(
                                              1.5,
                                              TextFormField(
                                                controller: _passwordController,
                                                decoration: InputDecoration(
                                                    border: InputBorder.none,
                                                    hintText: 'Password',
                                                    suffixIcon: IconButton(
                                                        onPressed:
                                                            _toggleObscureText,
                                                        icon: _obsecureText
                                                            ? const Icon(
                                                                Icons
                                                                    .visibility,
                                                                color:
                                                                    mainColor,
                                                              )
                                                            : const Icon(
                                                                Icons
                                                                    .visibility_off,
                                                                color:
                                                                    mainColor,
                                                              ))),
                                                obscureText: _obsecureText,
                                                validator: (value) {
                                                  if (value == null ||
                                                      value.isEmpty) {
                                                    return 'Please enter your password';
                                                  }
                                                  return null;
                                                },
                                              )),
                                          const SizedBox(height: 20),
                                          SizedBox(
                                            width: MediaQuery.of(context)
                                                .size
                                                .width,
                                            height: 50,
                                            child: ElevatedButton(
                                              style: ElevatedButton.styleFrom(
                                                  backgroundColor: mainColor),
                                              onPressed: () {
                                                if (_formKey.currentState!
                                                    .validate()) {
                                                  _handleLogin();
                                                }
                                              },
                                              child: const Text(
                                                'Login',
                                                style: TextStyle(
                                                    fontSize: 25,
                                                    color: Colors.white),
                                              ),
                                            ),
                                          ),
                                          const SizedBox(height: 20),
                                          FadeAnimation(
                                              1.7,
                                              Row(
                                                children: [
                                                  Checkbox(
                                                    activeColor: mainColor,
                                                    value: _rememberMe,
                                                    onChanged: (value) {
                                                      setState(() {
                                                        _rememberMe = value!;
                                                      });
                                                    },
                                                  ),
                                                  Text(
                                                    'Remember Me',
                                                    style: TextStyle(
                                                        color: mainColor),
                                                  ),
                                                ],
                                              )),
                                          const SizedBox(height: 20),
                                          FadeAnimation(
                                              1.7,
                                              Row(
                                                mainAxisAlignment:
                                                    MainAxisAlignment.center,
                                                children: [
                                                  const Text(
                                                    'Don\'t have an account?',
                                                    style: TextStyle(
                                                        color: Colors.black38),
                                                  ),
                                                  TextButton(
                                                    onPressed: () {
                                                      Navigator.pushNamed(
                                                          context,
                                                          AppRoutes.register);
                                                    },
                                                    child: const Text(
                                                      'Register',
                                                      style: TextStyle(
                                                          color: mainColor),
                                                    ),
                                                  ),
                                                ],
                                              )),
                                        ],
                                      ),
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
                ],
              ),
            );
    })));
  }

  Future<void> _handleLogin() async {
    AuthProvider authProvider =
        Provider.of<AuthProvider>(context, listen: false);

    if (_usernameController.text.isEmpty || _passwordController.text.isEmpty) {
      showTextSnackBar(context, 'Please enter Email and Password');
      return;
    }

    if (_passwordController.text.isEmpty) {
      showTextSnackBar(context, 'Enter a password');
      return;
    }

    authProvider.clearError();
    authProvider.anApiStarted();
    bool success = await StudentRegistrationProvider.loginRequest(
      authProvider,
      username: _usernameController.text.trim(),
      password: _passwordController.text.trim(),
    );
    authProvider.anApiStopped();

    if (success) {
      //showTextSnackBar(context, 'Login Successful');
      if (_rememberMe) {
        await _saveCredentials(
            _usernameController.text.trim(), _passwordController.text.trim());
      } else {
        await _clearCredentials();
      }
      Navigator.pushReplacementNamed(context, AppRoutes.drawer);
    } else {
      showTextSnackBar(context, authProvider.errorMessage);
    }
  }
}
