import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:tongate/pages/create_or_import_wallet.dart';
import './pages/SplashScreen.dart';
import './pages/onboarding.dart';
import './pages/Signup.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  await dotenv.load(fileName: ".env");
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      initialRoute: '/',
      routes: {
        '/': (context) => CreateOrImportWalletPage(),
        '/splashscreen': (context) => SplashScreen(),
        '/onboarding': (context) => OnboardingFlow(),
        '/signup': (context) => SignUpPage(),
        '/createorimportwalletpage': (context) => CreateOrImportWalletPage(),
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