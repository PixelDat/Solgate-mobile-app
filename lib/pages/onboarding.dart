import 'package:flutter/material.dart';
import 'dart:ui';
import 'dart:math' as math;
import 'dart:async';

void main() {
  runApp(MaterialApp(
    home: OnboardingFlow(),
    theme: ThemeData(
      fontFamily: 'Nunito_Sans',
      textTheme: ThemeData.light().textTheme.apply(
            fontFamily: 'Nunito_Sans',
          ),
    ),
  ));
}

class OnboardingFlow extends StatefulWidget {
  @override
  _OnboardingFlowState createState() => _OnboardingFlowState();
}

class _OnboardingFlowState extends State<OnboardingFlow> {
  int _currentPage = 0;
  bool _isAnimating = false;

  final List<OnboardingPage> pages = [
    OnboardingPage(
      title: 'Welcome to Solgate',
      description:
          'Solgate is a mobile portal for everything on the Solana network, a comprehensive gateway into the Solana ecosystem tailored for mobile users.',
      backgroundImagePath: 'assets/images/background.png',
      coins: [
        CoinImage(
            imagePath: 'assets/images/coin_jupiter.png',
            position: Offset(110, 10),
            size: 150),
        const CoinImage(
            imagePath: 'assets/images/coin_wen.png',
            position: Offset(-20, -20),
            size: 150),
        const CoinImage(
            imagePath: 'assets/images/coin_dogwithat.png',
            position: Offset(260, -20),
            size: 150),
        const CoinImage(
            imagePath: 'assets/images/coin_myro.png',
            position: Offset(10, 100),
            size: 150),
        const CoinImage(
            imagePath: 'assets/images/coin_bonk.png',
            position: Offset(230, 100),
            size: 150),
        const CoinImage(
            imagePath: 'assets/images/Tether 2.png',
            position: Offset(140, 150),
            size: 100),
        const CoinImage(
            imagePath: 'assets/images/Raydium 1.png',
            position: Offset(100, 230),
            size: 150),
        const CoinImage(
            imagePath: 'assets/images/Solana_3D.png',
            position: Offset(70, 400),
            size: 150),
        const CoinImage(
            imagePath: 'assets/images/coin_solana.png',
            position: Offset(90, 300),
            size: 300),
        const CoinInfo(
          imagePath: 'assets/images/Wen_logo.png',
          top: 80,
          size: 50,
          coinName: 'Wen',
          stickToRight: false,
        ),
        const CoinInfo(
          imagePath: 'assets/images/MYRO.png',
          top: 250,
          size: 50,
          coinName: 'Myro',
          stickToRight: false,
        ),
        const CoinInfo(
          imagePath: 'assets/images/dogwifhat-wif.png',
          top: 140,
          size: 50,
          coinName: 'Dogwithat',
          stickToRight: true,
        ),
        const CoinInfo(
          imagePath: 'assets/images/bonk1-bonk.png',
          top: 280,
          size: 50,
          coinName: 'Bank',
          stickToRight: true,
        ),
        const CoinInfo(
          imagePath: 'assets/images/raydium.png',
          top: 400,
          size: 50,
          coinName: 'Raydium',
          stickToRight: true,
        ),
      ],
    ),
    OnboardingPage(
      title: 'Wallet and exchange integration',
      description:
          'Securely manage, transfer and receive tokens. Conveniently handle transactions on Solana.',
      backgroundImagePath: 'assets/images/background.png',
      coins: [
        CoinImage(
            imagePath: 'assets/images/coin_jupiter.png',
            position: Offset(110, -50),
            size: 150),
        const CoinImage(
            imagePath: 'assets/images/coin_dogwithat.png',
            position: Offset(-50, 20),
            size: 150),
        const CoinImage(
            imagePath: 'assets/images/coin_wen.png',
            position: Offset(260, 20),
            size: 150),
        const CoinImage(
            imagePath: 'assets/images/coin_myro.png',
            position: Offset(-20, 460),
            size: 150),
        const CoinImage(
            imagePath: 'assets/images/coin_bonk.png',
            position: Offset(300, 390),
            size: 150),
        const WalletExchangeImage(
          imagePath: 'assets/images/Wallet_integration.png', // Update this path
          size: 500, // Adjust size as needed
        ),
      ],
    ),
    OnboardingPage(
      title: 'Launchpad for Solana tokens',
      description:
          'Get early access to promising Solana based projects and participate in ICOs securely.',
      backgroundImagePath: 'assets/images/background.png',
      coins: [
         const CoinImage(
            imagePath: 'assets/images/Solgate2.png',
            position: Offset(200, 20),
            size: 200),
            const CoinImage(
            imagePath: 'assets/images/coin_bonk.png',
            position: Offset(0, 450),
            size: 150),
        const WalletExchangeImage(
          imagePath: 'assets/images/Launchpad.png', // Update this path
          size: 1000, // Adjust size as needed
        ),
        const CoinImage(
            imagePath: 'assets/images/Myro1.png',
            position: Offset(300, 400),
            size: 150),
       ],
    ),
    OnboardingPage(
          title: 'Launchpad for Solana tokens',
          description:
              'Get early access to promising Solana based projects and participate in ICOs securely.',
          backgroundImagePath: 'assets/images/background.png',
          coins: [
            const WalletExchangeImage(
              imagePath: 'assets/images/Group481736.png', // Update this path
              size: 1000, // Adjust size as needed
            ),
            const CoinImage(
                imagePath: 'assets/images/coin_usdt.png',
                position: Offset(270, 450),
                size: 150),
          ],
        ),

];

  void _goToPage(int newPage) {
    if (_isAnimating || newPage < 0 || newPage >= pages.length) return;

    setState(() {
      _isAnimating = true;
      _currentPage = newPage;
    });

    // Reset _isAnimating after the animation completes
    Timer(Duration(milliseconds: 500), () {
      setState(() {
        _isAnimating = false;
      });
    });
  }

  void _onSwipe(DragEndDetails details) {
    if (_isAnimating) return;

    if (details.primaryVelocity == null) return;

    if (details.primaryVelocity! < -300) {
      // Swiped Left
      _goToPage(_currentPage + 1);
    } else if (details.primaryVelocity! > 300) {
      // Swiped Right
      _goToPage(_currentPage - 1);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: GestureDetector(
        onHorizontalDragEnd: _onSwipe,
        child: Container(
          color: Colors.black, // Ensures consistent background color
          child: Stack(
            children: [
              // AnimatedSwitcher handles the fade transition
              AnimatedSwitcher(
                duration: Duration(milliseconds: 500),
                transitionBuilder: (Widget child, Animation<double> animation) {
                  return FadeTransition(opacity: animation, child: child);
                },
                child: _buildFullPage(
                  pages[_currentPage],
                  key: ValueKey<int>(_currentPage),
                ),
              ),
              // Fixed Bottom Container remains outside AnimatedSwitcher
              Positioned(
                left: 0,
                right: 0,
                bottom: 0,
                child: _buildFixedBottomContainer(),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildFullPage(OnboardingPage page, {required Key key}) {
    return Container(
      key: key, // Important for AnimatedSwitcher to recognize changes
      width: double.infinity,
      height: double.infinity,
      decoration: BoxDecoration(
        image: DecorationImage(
          image: AssetImage(page.backgroundImagePath),
          fit: BoxFit.cover,
        ),
      ),
      child: Stack(
        children: page.coins,
      ),
    );
  }

  Widget _buildFixedBottomContainer() {
    final page = pages[_currentPage];
    return ClipRRect(
      borderRadius: BorderRadius.only(
        topLeft: Radius.circular(20),
        topRight: Radius.circular(20),
      ),
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
        child: Container(
          padding: EdgeInsets.all(20),
          decoration: BoxDecoration(
            color: Colors.black.withOpacity(0.2),
            border: Border(
              top: BorderSide(
                color: Colors.white.withOpacity(0.2),
                width: 0.5,
              ),
            ),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              LiquidDots(
                currentPage: _currentPage,
                pageCount: pages.length,
              ),
              SizedBox(height: 20),
              Text(
                page.title,
                style: TextStyle(
                    fontSize: 28,
                    fontWeight: FontWeight.bold,
                    color: Colors.white),
                textAlign: TextAlign.center,
              ),
              SizedBox(height: 16),
              Text(
                page.description,
                style: TextStyle(
                  fontSize: 16,
                  color: Colors.white.withOpacity(0.8),
                  fontWeight: FontWeight.w900,
                ),
                textAlign: TextAlign.center,
              ),
              SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }
}

class OnboardingPage extends StatelessWidget {
  final String title;
  final String description;
  final String backgroundImagePath;
  final List<Widget> coins;

  const OnboardingPage({
    required this.title,
    required this.description,
    required this.backgroundImagePath,
    required this.coins,
  });

  @override
  Widget build(BuildContext context) {
    return Stack(
      fit: StackFit.expand,
      children: [
        // Background image is handled in _buildFullPage to ensure consistent background
        ...coins,
      ],
    );
  }
}

class CoinImage extends StatelessWidget {
  final String imagePath;
  final Offset position;
  final double size;

  const CoinImage({
    required this.imagePath,
    required this.position,
    required this.size,
  });

  @override
  Widget build(BuildContext context) {
    return Positioned(
      left: position.dx,
      top: position.dy,
      child: Image.asset(
        imagePath,
        width: size,
        height: size,
      ),
    );
  }
}

class CoinInfo extends StatelessWidget {
  final String imagePath;
  final double top;
  final double size;
  final String coinName;
  final bool stickToRight;

  const CoinInfo({
    required this.imagePath,
    required this.top,
    required this.size,
    required this.coinName,
    this.stickToRight = false,
  });

  @override
  Widget build(BuildContext context) {
    final backgroundColor = Colors.black.withOpacity(0.2);
    final imageSize = size * 1.5;

    return Positioned(
      top: top,
      left: stickToRight ? null : 0,
      right: stickToRight ? 0 : null,
      child: ClipRRect(
        borderRadius: BorderRadius.horizontal(
          left: Radius.circular(stickToRight ? 20 : 0),
          right: Radius.circular(stickToRight ? 0 : 20),
        ),
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
          child: Container(
            padding: EdgeInsets.symmetric(horizontal: 12, vertical: 8),
            decoration: BoxDecoration(
              color: backgroundColor,
              borderRadius: BorderRadius.horizontal(
                left: Radius.circular(stickToRight ? 20 : 0),
                right: Radius.circular(stickToRight ? 0 : 20),
              ),
              border: Border.all(color: backgroundColor),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: stickToRight
                  ? [
                      Image.asset(
                        imagePath,
                        width: imageSize,
                        height: imageSize,
                      ),
                      SizedBox(width: 8),
                      Text(
                        coinName,
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ]
                  : [
                      Text(
                        coinName,
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      SizedBox(width: 8),
                      Image.asset(
                        imagePath,
                        width: imageSize,
                        height: imageSize,
                      ),
                    ],
            ),
          ),
        ),
      ),
    );
  }
}

class LiquidDots extends StatelessWidget {
  final int currentPage;
  final int pageCount;

  const LiquidDots(
      {Key? key, required this.currentPage, required this.pageCount})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 10,
      child: CustomPaint(
        size: Size(pageCount * 20.0, 10),
        painter:
            LiquidDotsPainter(currentPage: currentPage, pageCount: pageCount),
      ),
    );
  }
}
class LiquidDotsPainter extends CustomPainter {
  final int currentPage;
  final int pageCount;

  LiquidDotsPainter({required this.currentPage, required this.pageCount});

  @override
  void paint(Canvas canvas, Size size) {
    final dotPaint = Paint()
      ..color = Colors.grey
      ..style = PaintingStyle.fill;

    final activeDotPaint = Paint()
      ..color = Colors.purple.shade200
      ..style = PaintingStyle.fill;

    final dotRadius = 4.0;
    final activeDotRadius = 6.0;
    final spacing = size.width / (pageCount + 1);

    for (int i = 0; i < pageCount; i++) {
      if (i == currentPage) {
        canvas.drawCircle(
            Offset(spacing * (i + 1), size.height / 2),
            activeDotRadius,
            activeDotPaint);
      } else {
        canvas.drawCircle(
            Offset(spacing * (i + 1), size.height / 2),
            dotRadius,
            dotPaint);
      }
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}

class WalletExchangeImage extends StatelessWidget {
  final String imagePath;
  final double size;

  const WalletExchangeImage({
    Key? key,
    required this.imagePath,
    this.size = 300, // Default size, adjust as needed
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: EdgeInsets.only(bottom: 100),
        child: Image.asset(
          imagePath,
          width: size,
          height: size,
          fit: BoxFit.contain,
        ),
      ),
    );
  }
}
