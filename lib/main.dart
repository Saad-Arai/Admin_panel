import 'package:admin_pannel_app/screens/homescreen.dart';
import 'package:admin_pannel_app/screens/login_screen.dart';
import 'package:admin_pannel_app/screens/splash_screen.dart';

import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Admin Panel',
      theme: ThemeData(
        primaryColor: const Color(0xFF84c225),
      ),
      home: SplashScreen(),
    );
  }
}
