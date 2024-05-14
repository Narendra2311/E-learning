// ignore_for_file: file_names, library_private_types_in_public_api, avoid_print

import 'dart:async';
import 'dart:ui';
import 'package:e_learning/src/auth/sign_in.dart';
import 'package:e_learning/src/home/home_screen.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    checkLoginStatus();
  }

  Future<void> checkLoginStatus() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    int? userId = prefs.getInt('userId');
    print('Stored userId: $userId');

    Timer(
      const Duration(seconds: 2),
      () {
        try {
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(
              builder: (context) => userId != null && userId != 0
                  ? const HomeScreen()
                  : const SignInScreen(),
            ),
          );
        } catch (e) {
          print('Navigation error: $e');
        }
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        fit: StackFit.expand,
        children: <Widget>[
          Image.asset(
            'assets/SplashScreen/splashscreen.jpg',
            fit: BoxFit.cover,
          ),
          Center(
            child: ClipRRect(
              borderRadius: BorderRadius.circular(10.0),
              child: BackdropFilter(
                filter: ImageFilter.blur(sigmaX: 5.0, sigmaY: 5.0),
                child: Container(
                  padding: const EdgeInsets.all(120.0),
                  color: Colors.black.withOpacity(0.5),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Image.asset(
                        'assets/images/Logo.png',
                        width: 200,
                        height: 200,
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
