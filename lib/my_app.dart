// ignore_for_file: use_key_in_widget_constructors
// import 'package:e_learning/src/auth/sign_in.dart';
import 'package:e_learning/src/home/home_screen.dart';
import 'package:flutter/material.dart';

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      debugShowCheckedModeBanner: false,
      home: HomeScreen(),
    );
  }
}
