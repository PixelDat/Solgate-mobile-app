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
    theme: ThemeData(
      fontFamily: 'Nunito_Sans',
      textTheme: ThemeData.light().textTheme.apply(
        fontFamily: 'Nunito_Sans',
      ),
    ),
  ));
}