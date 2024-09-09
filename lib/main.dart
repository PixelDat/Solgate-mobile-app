import 'package:flutter/material.dart';
import './pages/SplashScreen.dart';

void main() {
  runApp(MaterialApp(
    initialRoute: '/',
    routes: {
      '/': (context) => SplashScreen(), // Add splash screen as initial route
      // '/home': (context) => HomeScreen(), // Your home screen widget
    },
  ));
}