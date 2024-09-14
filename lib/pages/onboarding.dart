import 'package:flutter/material.dart';

void main() {
  runApp(MaterialApp(
    home: OnboardingFlow(),
    theme: ThemeData(
      fontFamily: 'Roboto', // Ensure you have this font in your project
    ),
  ));
}

class OnboardingFlow extends StatefulWidget {
  @override
  _OnboardingFlowState createState() => _OnboardingFlowState();
}

class _OnboardingFlowState extends State<OnboardingFlow> {
  final PageController _pageController = PageController();
  int _currentPage = 0;

  List<OnboardingPage> pages = [
    OnboardingPage(
      title: 'Welcome to Solgate',
      description: 'Solgate is a mobile portal for everything on the Solana network, a comprehensive gateway into the Solana ecosystem tailored for mobile users.',
      backgroundImagePath: 'assets/images/background.png',
      coins: [
        CoinImage(imagePath: 'assets/images/coin_wen.png', position: Offset(20, 100), size: 100),
        CoinImage(imagePath: 'assets/images/coin_solana.png', position: Offset(80, 180), size: 100),
        CoinImage(imagePath: 'assets/images/coin_dogwithat.png', position: Offset(250, 120), size: 100),
        CoinImage(imagePath: 'assets/images/coin_myro.png', position: Offset(40, 300), size: 100),
        CoinImage(imagePath: 'assets/images/coin_bonk.png', position: Offset(200, 280), size: 100),
        CoinImage(imagePath: 'assets/images/coin_raydium.png', position: Offset(280, 400), size: 100),
      ],
    ),
    OnboardingPage(
      title: 'Wallet and exchange integration',
      description: 'Securely manage, transfer and receive tokens. Conveniently handle transactions on Solana.',
      backgroundImagePath: 'assets/images/background.png',
      coins: [
        CoinImage(imagePath: 'assets/images/coin_solana.png', position: Offset(20, 150), size: 80),
        CoinImage(imagePath: 'assets/images/coin_usdt.png', position: Offset(100, 200), size: 80),
        CoinImage(imagePath: 'assets/images/coin_usdt.png', position: Offset(180, 250), size: 80),
        CoinImage(imagePath: 'assets/images/coin_bonk.png', position: Offset(260, 300), size: 80),
      ],
    ),
    OnboardingPage(
      title: 'Launchpad for Solana tokens',
      description: 'Get early access to promising Solana based projects and participate in ICOs securely.',
      backgroundImagePath: 'assets/images/background.png',
      coins: [
        CoinImage(imagePath: 'assets/images/coin_solana.png', position: Offset(20, 150), size: 80),
        CoinImage(imagePath: 'assets/images/coin_bonk.png', position: Offset(280, 200), size: 80),
        CoinImage(imagePath: 'assets/images/coin_raydium.png', position: Offset(50, 300), size: 80),
        CoinImage(imagePath: 'assets/images/coin_wen.png', position: Offset(250, 350), size: 80),
      ],
    ),
    OnboardingPage(
      title: 'Staking support',
      description: 'Stake your tokens directly within the app, participating in the network\'s security and operations while earning rewards.',
      backgroundImagePath: 'assets/images/background.png',
      coins: [
        CoinImage(imagePath: 'assets/images/coin_solana.png', position: Offset(20, 150), size: 80),
        CoinImage(imagePath: 'assets/images/coin_raydium.png', position: Offset(280, 200), size: 80),
      ],
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          PageView.builder(
            controller: _pageController,
            itemCount: pages.length,
            onPageChanged: (int page) {
              setState(() {
                _currentPage = page;
              });
            },
            itemBuilder: (context, index) {
              return pages[index];
            },
          ),
          Positioned(
            bottom: 20,
            left: 0,
            right: 0,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: List.generate(
                pages.length,
                (index) => buildDot(index: index),
              ),
            ),
          ),
          if (_currentPage == pages.length - 1)
            Positioned(
              bottom: 50,
              left: 20,
              right: 20,
              child: ElevatedButton(
                child: Text('Get Started!'),
                onPressed: () {
                  // Navigate to the main app
                },
                style: ButtonStyle(
                  backgroundColor: MaterialStateProperty.all<Color>(Colors.purple),
                  foregroundColor: MaterialStateProperty.all<Color>(Colors.white),
                  padding: MaterialStateProperty.all<EdgeInsets>(EdgeInsets.symmetric(vertical: 15)),
                  shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                    RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(30),
                    ),
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }

  Widget buildDot({required int index}) {
    return Container(
      margin: EdgeInsets.only(right: 5),
      height: 10,
      width: 10,
      decoration: BoxDecoration(
        color: _currentPage == index ? Colors.purple : Colors.grey,
        borderRadius: BorderRadius.circular(5),
      ),
    );
  }
}

class OnboardingPage extends StatelessWidget {
  final String title;
  final String description;
  final String backgroundImagePath;
  final List<CoinImage> coins;

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
        Image.asset(
          backgroundImagePath,
          fit: BoxFit.cover,
        ),
        ...coins,
        SafeArea(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Spacer(),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 20),
                child: Text(
                  title,
                  style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold, color: Colors.white),
                ),
              ),
              SizedBox(height: 20),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 20),
                child: Text(
                  description,
                  style: TextStyle(fontSize: 16, color: Colors.white70),
                ),
              ),
              SizedBox(height: 50),
            ],
          ),
        ),
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