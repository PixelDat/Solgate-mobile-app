import 'package:flutter/material.dart';
import './pages/SplashScreen.dart';
import './pages/onboarding.dart';  // Add this import

void main() {
  runApp(MaterialApp(
    initialRoute: '/',
    routes: {
      '/': (context) => SplashScreen(),
      '/onboarding': (context) => OnboardingFlow(),  // Add this route
    },
  ));
}