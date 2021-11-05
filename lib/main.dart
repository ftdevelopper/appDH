import 'package:app_dos_hermanos/pages/homePage.dart';
import 'package:flutter/material.dart';
import 'package:animated_splash_screen/animated_splash_screen.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Dos Hermanos',
      theme: ThemeData(
        primarySwatch: Colors.red,
      ),
      home: AnimatedSplashScreen(
        splash: Image.asset('assets/logo.png'),
        splashTransition: SplashTransition.fadeTransition,
        nextScreen: MyHomePage(),
        duration: 1000,
      ),
    );
  }
}


