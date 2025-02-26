import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:tongate/widgets/GradientButton.dart';
import 'package:bip39/bip39.dart' as bip39;
import 'dart:ui';
import 'package:tongate/utils/toast_utils.dart';
import 'package:tongate/widgets/CustomToast.dart';
import 'dart:math';

class wallet_creation_page extends StatefulWidget {
  @override
  _wallet_creation_pageState createState() => _wallet_creation_pageState();
}

class _wallet_creation_pageState extends State<wallet_creation_page> {
  final PageController _pageController = PageController();
  late List<String> _recoveryPhrase;
  bool _showPhrase = false;
  int _currentPage = 0;
  List<String> _selectedWords = [];
  int _currentConfirmationIndex = 0;
  bool _isConfirmationCorrect = false;
  List<int> _selectedIndices = [];
  int _confirmedCount = 0;

  @override
  void initState() {
    super.initState();
    _recoveryPhrase = bip39.generateMnemonic().split(' ');
    _generateConfirmationWords();
  }

  void _generateConfirmationWords() {
    final random = Random();
    _selectedIndices = List.generate(3, (_) => random.nextInt(_recoveryPhrase.length))..sort();
    _selectedWords = _selectedIndices.map((index) => _recoveryPhrase[index]).toList();
  }

  void _copyToClipboard() {
    Clipboard.setData(ClipboardData(text: _recoveryPhrase.join(' ')));
    showCustomToast(
      context,
      'Recovery phrase copied to clipboard',
      ToastType.success,
    );
  }

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
          
        
          // Main content
          SafeArea(
            child: Column(
              children: [
                _buildProgressIndicator(),
                Expanded(
                  child: PageView(
                    controller: _pageController,
                    onPageChanged: (index) {
                      setState(() {
                        _currentPage = index;
                      });
                    },
                    children: [
                      _buildWriteItDownScreen(),
                      _buildDontShareScreen(),
                      _buildRecoveryPhraseScreen(),
                      _buildConfirmationScreen(),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildProgressIndicator() {
    return Container(
      height: 4,
      child: Row(
        children: List.generate(3, (index) {
          return Expanded(
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 2),
              child: Container(
                decoration: BoxDecoration(
                  gradient: index <= _currentPage
                      ? LinearGradient(
                          colors: [
                            if (index == 0) Color(0xFFA98CFF),
                            if (index == 1) Color(0xFFA98CFF),
                            if (index == 2) Color(0xFFA98CFF),
                            Color(0xFFA98CFF),
                          ],
                          begin: Alignment.centerLeft,
                          end: Alignment.centerRight,
                        )
                      : null,
                  color: index <= _currentPage ? null : Color.fromARGB(255, 53, 48, 77),
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
            ),
          );
        }),
      ),
    );
  }

  Widget _buildWriteItDownScreen() {
    return SingleChildScrollView(
      child: Padding(
        padding: EdgeInsets.all(24.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Align(
              alignment: Alignment.topRight,
              child: TextButton.icon(
                icon: Icon(Icons.arrow_forward, color: Colors.white70, size: 18),
                label: Text(
                  'Skip',
                  style: TextStyle(
                    color: Colors.white70,
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                  ),
                ),
                onPressed: () => _pageController.nextPage(
                  duration: Duration(milliseconds: 300),
                  curve: Curves.easeInOut,
                ),
              ),
            ),
            SizedBox(height: 10),
            Center(
              child: Image.asset(
                'assets/images/write_it_down.png',
                height: 300,
                width: 300,
                fit: BoxFit.contain,
              ),
            ),
            SizedBox(height: 1),
            Text(
              'Write it down!',
              style: TextStyle(color: Colors.white, fontSize: 32, fontWeight: FontWeight.bold),
              textAlign: TextAlign.center,
            ),
            SizedBox(height: 16),
            Text(
              'This secret phrase can be used to access or recover your wallet. Keep it safe!',
              style: TextStyle(color: Colors.white70, fontSize: 16),
              textAlign: TextAlign.center,
            ),
            SizedBox(height: 24),
            _buildInfoItem(
              'Write it down, write your secret phrase, and store it in a secure offline location!',
            ),
            SizedBox(height: 12),
            _buildInfoItem(
              'Solgate does not keep a copy of your secret phrase.',
            ),
            SizedBox(height: 12),
            _buildInfoItem(
              'Saving this digitally in plain text is not advisable, examples include screenshots, text files, or emailing yourself.',
            ),
            SizedBox(height: 12),
            _buildInfoItem(
              'Keep it confident, and choose a secure storage method.',
            ),
            SizedBox(height: 24),
            Text(
              'An estimated total of 4.2B\$ was lost, due to people losing access to their wallet',
              style: TextStyle(color: Colors.white54, fontSize: 12),
              textAlign: TextAlign.center,
            ),
            SizedBox(height: 24),
            GradientButton(
              onPressed: () => _pageController.nextPage(
                duration: Duration(milliseconds: 300),
                curve: Curves.easeInOut,
              ),
              child: Text('Next', style: TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.bold)),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildInfoItem(String text) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(8),
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
        child: Container(
          decoration: BoxDecoration(
            color: Color.fromARGB(255, 0, 0, 0).withOpacity(0.3),
            border: Border.all(color: Colors.purple.withOpacity(0.3), width: 1),
            borderRadius: BorderRadius.circular(8),
          ),
          padding: EdgeInsets.all(12),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Icon(Icons.check_circle_outline, color: Colors.green, size: 20),
              SizedBox(width: 12),
              Expanded(
                child: Text(
                  text,
                  style: TextStyle(color: Colors.white70, fontSize: 14),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildDontShareScreen() {
    return Padding(
      padding: EdgeInsets.all(24.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Align(
            alignment: Alignment.topRight,
            child: TextButton.icon(
              icon: Icon(Icons.arrow_forward, color: Colors.white70, size: 18),
              label: Text(
                'Skip',
                style: TextStyle(
                  color: Colors.white70,
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                ),
              ),
              onPressed: () => _pageController.nextPage(
                duration: Duration(milliseconds: 300),
                curve: Curves.easeInOut,
              ),
            ),
          ),
          Spacer(),
          Center(
            child: Image.asset('assets/images/dont_share.png', height: 200),
          ),
          SizedBox(height: 24),
          Text(
            'Don\'t',
            style: TextStyle(color: Colors.white, fontSize: 32, fontWeight: FontWeight.bold),
          ),
          Text(
            'share your phrase',
            style: TextStyle(color: Colors.white, fontSize: 32, fontWeight: FontWeight.bold),
          ),
          SizedBox(height: 16),
          Text(
            'To ensure your funds and wallet is secured, please refrain from sharing your passphrase with anyone.',
            style: TextStyle(color: Colors.white70, fontSize: 16),
            textAlign: TextAlign.center,
          ),
          Spacer(),
          GradientButton(
            onPressed: () => _pageController.nextPage(
              duration: Duration(milliseconds: 300),
              curve: Curves.easeInOut,
            ),
            child: Text('Next', style: TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.bold)),
          ),
        ],
      ),
    );
  }

  Widget _buildRecoveryPhraseScreen() {
    return Padding(
      padding: EdgeInsets.all(24.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Text(
            'Passphrase',
            style: TextStyle(color: Colors.white, fontSize: 32, fontWeight: FontWeight.bold),
            textAlign: TextAlign.center,
          ),
          SizedBox(height: 16),
          Text(
            'For added security. This is the only way you\'d be able to recover your account. Store it securely to keep your tokens safe.',
            style: TextStyle(color: Colors.white70, fontSize: 16),
            textAlign: TextAlign.center,
          ),
          SizedBox(height: 24),
          Text(
            'Recovery Phrases',
            style: TextStyle(color: Colors.white, fontSize: 20, fontWeight: FontWeight.bold),
            textAlign: TextAlign.center,
          ),
          SizedBox(height: 16),
          Text(
            'Please record this phrases in the correct order using the corresponding numbers and save it in a secure place.',
            style: TextStyle(color: Colors.white70, fontSize: 14),
            textAlign: TextAlign.center,
          ),
          SizedBox(height: 16),
          Expanded(
            child: _showPhrase ? _buildPhraseGrid() : _buildShowPhraseButton(),
          ),
          SizedBox(height: 16),
          TextButton.icon(
            icon: Icon(Icons.copy, color: Colors.white70),
            label: Text('Copy to clipboard', style: TextStyle(color: Colors.white70)),
            onPressed: _copyToClipboard,
          ),
          SizedBox(height: 24),
          Text(
            'An estimated total of 4.2B\$ was lost, due to people losing access to their wallet',
            style: TextStyle(color: Colors.white54, fontSize: 12),
            textAlign: TextAlign.center,
          ),
          SizedBox(height: 24),
          GradientButton(
            onPressed: () {
              _pageController.nextPage(
                duration: Duration(milliseconds: 300),
                curve: Curves.easeInOut,
              );
            },
            child: Text('Proceed', style: TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.bold)),
          ),
        ],
      ),
    );
  }

  Widget _buildShowPhraseButton() {
    return Center(
      child: ElevatedButton.icon(
        icon: Icon(Icons.visibility_off, color: Colors.white, size: 20),
        label: Text(
          'Show phrase',
          style: TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.bold),
        ),
        onPressed: () {
          setState(() {
            _showPhrase = true;
          });
        },
        style: ElevatedButton.styleFrom(
          backgroundColor: Color.fromARGB(255, 24, 33, 51),  // Dark background color
          foregroundColor: Colors.white,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),  // Rounded corners
          ),
          padding: EdgeInsets.symmetric(horizontal: 20, vertical: 12),
        ),
      ),
    );
  }

  Widget _buildPhraseGrid() {
    return GridView.builder(
      shrinkWrap: true,
      physics: BouncingScrollPhysics(),
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        childAspectRatio: 4,
        crossAxisSpacing: 10,
        mainAxisSpacing: 10,
      ),
      itemCount: _recoveryPhrase.length,
      itemBuilder: (context, index) {
        return Container(
          decoration: BoxDecoration(
            color: Color.fromARGB(0, 30, 27, 46),
            borderRadius: BorderRadius.circular(30),
            border: Border.all(color: Color.fromARGB(255, 100, 64, 117), width: 1),
          ),
          child: Row(
            children: [
              Container(
                width: 40,
                alignment: Alignment.center,
                decoration: BoxDecoration(
                  border: Border(
                    right: BorderSide(color: Color.fromARGB(255, 100, 64, 117), width: 1),
                  ),
                ),
                child: Text(
                  '${(index + 1).toString().padLeft(2, '0')}',
                  style: TextStyle(color: Color.fromARGB(255, 219, 140, 255), fontWeight: FontWeight.bold),
                ),
              ),
              Expanded(
                child: Center(
                  child: Text(
                    _recoveryPhrase[index],
                    style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildConfirmationScreen() {
    return Padding(
      padding: EdgeInsets.all(24.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Text(
            'Confirm Recovery Phrase',
            style: TextStyle(color: Colors.white, fontSize: 24, fontWeight: FontWeight.bold),
          ),
          SizedBox(height: 16),
          Text(
            'Progress: ${_confirmedCount + 1} / 3',
            style: TextStyle(color: Colors.white70, fontSize: 16),
          ),
          SizedBox(height: 16),
          Text(
            'What\'s the ${_getOrdinal(_selectedIndices[_currentConfirmationIndex] + 1)} word in your recovery phrase?',
            style: TextStyle(color: Colors.white70, fontSize: 16),
            textAlign: TextAlign.center,
          ),
          SizedBox(height: 24),
          Expanded(
            child: ListView.builder(
              itemCount: 6,
              itemBuilder: (context, index) {
                final word = index < _selectedWords.length ? _selectedWords[index] : _getRandomWord();
                return _buildWordOption(word);
              },
            ),
          ),
          SizedBox(height: 24),
          if (_confirmedCount == 2)
            Column(
              children: [
                Image.asset('assets/images/confirmation_complete.png', height: 100),
                SizedBox(height: 16),
                Text(
                  'Great job! You\'ve confirmed your recovery phrase.',
                  style: TextStyle(color: Colors.white, fontSize: 16),
                  textAlign: TextAlign.center,
                ),
              ],
            ),
          if (_isConfirmationCorrect)
            GradientButton(
              onPressed: () {
                // Handle wallet creation or navigation to the next screen
              },
              child: Text('Create a passcode', style: TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.bold)),
            ),
        ],
      ),
    );
  }

  Widget _buildWordOption(String word) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 8),
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.transparent,
          foregroundColor: Colors.white,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8),
            side: BorderSide(color: Colors.purple.withOpacity(0.5)),
          ),
          padding: EdgeInsets.symmetric(vertical: 12),
        ),
        onPressed: () => _checkWord(word),
        child: Text(word),
      ),
    );
  }

  void _checkWord(String selectedWord) {
    if (selectedWord == _recoveryPhrase[_selectedIndices[_currentConfirmationIndex]]) {
      setState(() {
        _confirmedCount++;
        if (_currentConfirmationIndex < 2) {
          _currentConfirmationIndex++;
        } else {
          _isConfirmationCorrect = true;
        }
      });
    } else {
      showCustomToast(
        context,
        'Incorrect word. Please try again.',
        ToastType.error,
      );
    }
  }

  String _getRandomWord() {
    final random = Random();
    return _recoveryPhrase[random.nextInt(_recoveryPhrase.length)];
  }

  String _getOrdinal(int number) {
    if (number == 1) return '1st';
    if (number == 2) return '2nd';
    if (number == 3) return '3rd';
    return '${number}th';
  }
}
