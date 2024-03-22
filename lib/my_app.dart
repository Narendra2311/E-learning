import 'package:flutter/material.dart';
import 'SplashScreen.dart';

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      debugShowCheckedModeBanner: false, // Set this property to false
      home: SplashScreen(),
    );
  }
}
