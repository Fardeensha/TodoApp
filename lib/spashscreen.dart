import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:todo_firbase/homepage.dart';
import 'package:todo_firbase/sign_up.dart';

import 'main.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    CheckUserLoggedIn() ;
    super.initState();
  }

  Future<void> gotoLogin() async {
    await Future.delayed(const Duration(seconds: 2));
    Navigator.of(context).pushReplacement(
      MaterialPageRoute(
        builder: (ctx) =>const Signup(),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return  Scaffold(
      backgroundColor: Colors.white,
      body: Center(
          child: Image.asset('Assets/bird.webp')
            ),
    );
  }

     // ignore: non_constant_identifier_names
   Future<void>CheckUserLoggedIn() async {
    final _sharedPrefs = await SharedPreferences.getInstance();
    final _userLoggedIn = _sharedPrefs.getBool(SAVE_KEY_NAME);

    if (_userLoggedIn== null || _userLoggedIn== false) {
    gotoLogin();
    } else {
      // ignore: use_build_context_synchronously
      Navigator.of(context)
          .pushReplacement(MaterialPageRoute(
            builder: (ctx1) => Homepage())
            );
    }
  }
}