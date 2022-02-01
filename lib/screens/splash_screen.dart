import 'dart:async';

import 'package:admin_pannel_app/screens/homescreen.dart';
import 'package:admin_pannel_app/screens/login_screen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({Key? key}) : super(key: key);

  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    Timer(Duration(seconds: 2), () {
      FirebaseAuth.instance.authStateChanges().listen((User? user) {
        if (user == null) {
          Navigator.pushReplacement(
              context,
              MaterialPageRoute(
                  builder: (BuildContext context) => LoginScreen()));
        } else {
          Navigator.pushReplacement(
              context,
              MaterialPageRoute(
                  builder: (BuildContext context) => HomeScreen()));
        }
      });
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Center(
        child: CircularProgressIndicator(),
      ),
    );
  }
}
