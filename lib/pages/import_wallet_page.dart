import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:tongate/widgets/GradientButton.dart';

class ImportWalletPage extends StatefulWidget {
  @override
  _ImportWalletPageState createState() => _ImportWalletPageState();
}

class _ImportWalletPageState extends State<ImportWalletPage> {
  final TextEditingController _recoveryPhraseController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          // Background elements (unchanged)
          Container(
            decoration: const BoxDecoration(
              color: Color.fromARGB(255, 0, 0, 0),
            ),
          ),
          Positioned.fill(
            child: Opacity(
              opacity: 0.6,
              child: Image.asset(
                'assets/images/glow_background_1.png',
                fit: BoxFit.cover,
              ),
            ),
          ),
          Positioned(
            top: -700,
            left: -900,
            child: Image.asset(
              'assets/images/background_top_left.png',
              width: 2200,
              height: 2200,
            ),
          ),
          Positioned(
            top: -10,
            left: -30,
            child: Image.asset(
              'assets/images/background_bottom_right.png',
              width: 300,
              height: 300,
            ),
          ),
          // Main content
          SafeArea(
            child: Column(
              children: [
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 24.0),
                  child: Row(
                    children: [
                      IconButton(
                        icon: Icon(Icons.arrow_back, color: Colors.white),
                        onPressed: () => Navigator.pop(context),
                      ),
                      SizedBox(width: 8),
                      Text(
                        'Import Wallet',
                        style: TextStyle(color: Colors.white, fontSize: 24, fontWeight: FontWeight.bold),
                      ),
                    ],
                  ),
                ),
                Expanded(
                  child: SingleChildScrollView(
                    padding: EdgeInsets.symmetric(horizontal: 24.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        SizedBox(height: 40),
                        Text(
                          'Enter\nRecovery Phrase',
                          style: TextStyle(color: Colors.white, fontSize: 32, fontWeight: FontWeight.bold),
                        ),
                        SizedBox(height: 16),
                        Text(
                          'Your recovery phrase has 12 or 24 words, enter the words in the correct order, divided with spaces.',
                          style: TextStyle(color: Colors.white70, fontSize: 16),
                        ),
                        SizedBox(height: 24),
                        Container(
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(16),
                            gradient: LinearGradient(
                              colors: [
                                Color(0xFF8A2BE2),
                                Color(0xFF4169E1),
                                Color(0xFF00CED1),
                              ],
                              begin: Alignment.topLeft,
                              end: Alignment.bottomRight,
                            ),
                          ),
                          padding: EdgeInsets.all(1), // Thin border
                          child: Container(
                            decoration: BoxDecoration(
                              color: Color(0xFF1F1F3D),
                              borderRadius: BorderRadius.circular(15),
                            ),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.stretch,
                              children: [
                                TextField(
                                  controller: _recoveryPhraseController,
                                  style: TextStyle(color: Colors.white),
                                  maxLines: 3,
                                  decoration: InputDecoration(
                                    hintText: 'Enter your recovery phrase',
                                    hintStyle: TextStyle(color: Colors.white54),
                                    border: InputBorder.none,
                                    contentPadding: EdgeInsets.all(16),
                                  ),
                                ),
                                Divider(
                                  color: Colors.white24,
                                  height: 1,
                                ),
                                TextButton.icon(
                                  icon: Icon(Icons.copy_outlined, color: Colors.white70, size: 20),
                                  label: Text(
                                    'Paste phrase',
                                    style: TextStyle(color: Colors.white70, fontSize: 14),
                                  ),
                                  style: TextButton.styleFrom(
                                    padding: EdgeInsets.symmetric(vertical: 16),
                                    alignment: Alignment.center,
                                  ),
                                  onPressed: () async {
                                    ClipboardData? clipboardData = await Clipboard.getData(Clipboard.kTextPlain);
                                    if (clipboardData != null && clipboardData.text != null) {
                                      setState(() {
                                        _recoveryPhraseController.text = clipboardData.text!;
                                      });
                                    }
                                  },
                                ),
                              ],
                            ),
                          ),
                        ),
                        SizedBox(height: 40),
                      ],
                    ),
                  ),
                ),
                Padding(
                  padding: EdgeInsets.all(24.0),
                  child: GradientButton(
                    text: 'Confirm wallet',
                    onPressed: () {
                      // Implement wallet confirmation logic
                    },
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
