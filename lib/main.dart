import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import './pages/SplashScreen.dart';
import './pages/onboarding.dart';
import './pages/Signup.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      initialRoute: '/',
      routes: {
        '/': (context) => SignUpPage(),
        '/onboarding': (context) => OnboardingFlow(),
        '/signup': (context) => SignUpPage(),
      },
      theme: ThemeData(
        fontFamily: 'Nunito_Sans',
        textTheme: ThemeData.light().textTheme.apply(
              fontFamily: 'Nunito_Sans',
            ),
      ),
    );
  }
}