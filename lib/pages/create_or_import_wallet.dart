import 'package:flutter/material.dart';
import 'package:tongate/widgets/GradientButton.dart'; // Add this import
import 'package:tongate/widgets/GradientBorderButton.dart'; // Add this import
import 'package:tongate/pages/import_wallet_page.dart';

class CreateOrImportWalletPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          // Main background color
          Container(
            decoration: const BoxDecoration(
              color: Color.fromARGB(255, 0, 0, 0),
            ),
          ),
          // Glow background
          Positioned.fill(
            child: Opacity(
              opacity: 0.6,
              child: Image.asset(
                'assets/images/glow_background_1.png',
                fit: BoxFit.cover,
              ),
            ),
          ),
          // Top-left background image
         
          // Bottom-right background image
         
          // Content
          SafeArea(
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 24.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  // Center image
                  Image.asset(
                    'assets/images/getIn.png', // Replace with your actual image path
                    width: 250,
                    height: 250,
                  ),
                  SizedBox(height: 40),
                  Text(
                    'Let’s get you in',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 32,
                      fontWeight: FontWeight.w900,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  SizedBox(height: 16),
                  Text(
                    'To get started, please create a new wallet or import one from seed phrase.',
                    style: TextStyle(
                      color: Colors.white70,
                      fontSize: 16,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  SizedBox(height: 40),
                  GradientButton(
                    child: Text(
                      'Create a new wallet',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 16,
                      ),
                    ),
                    onPressed: () {
                      // TODO: Implement create wallet functionality
                    },
                  ),
                  SizedBox(height: 20),
                  GradientBorderButton(
                    text: 'Import a wallet',
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => ImportWalletPage()),
                      );
                    },
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
