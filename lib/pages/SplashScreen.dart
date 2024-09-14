import 'package:flutter/material.dart';

class LeftToRightClipper extends CustomClipper<Rect> {
  final double progress;

  LeftToRightClipper(this.progress);

  @override
  Rect getClip(Size size) {
    return Rect.fromLTRB(0, 0, size.width * progress, size.height);
  }

  @override
  bool shouldReclip(LeftToRightClipper oldClipper) {
    return progress != oldClipper.progress;
  }
}

class SplashScreen extends StatefulWidget {
  const SplashScreen({Key? key}) : super(key: key);

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _blackScreenFadeAnimation;
  late Animation<double> _diagonalRevealAnimation;
  late Animation<Offset> _logoSlideAnimation;
  late Animation<double> _logoFadeAnimation;
  late Animation<double> _logoScaleAnimation; // Add scale animation
  late Animation<double> _textFadeAnimation;
  late Animation<double> _textRevealAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(seconds: 3),
      vsync: this,
    );

    _blackScreenFadeAnimation = Tween<double>(begin: 1.0, end: 0.0).animate(
      CurvedAnimation(
        parent: _controller,
        curve: const Interval(0.0, 0.3, curve: Curves.easeInOut),
      ),
    );

    // Diagonal reveal animation
    _diagonalRevealAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _controller,
        curve: const Interval(0.0, 0.3, curve: Curves.easeInOut),
      ),
    );

    // Logo sliding left while fading out
    _logoSlideAnimation = Tween<Offset>(
      begin: Offset.zero,
      end: const Offset(-0.5, 0),
    ).animate(
      CurvedAnimation(
        parent: _controller,
        curve: const Interval(0.3, 0.6, curve: Curves.easeInOut),
      ),
    );

    _logoFadeAnimation = Tween<double>(begin: 1.0, end: 0.0).animate(
      CurvedAnimation(
        parent: _controller,
        curve: const Interval(0.3, 0.6, curve: Curves.easeInOut),
      ),
    );

    // Logo scaling down as it slides out
    _logoScaleAnimation = Tween<double>(
      begin: 1.0, // Start at full size
      end: 0.5, // Scale down to 50% of the original size
    ).animate(
      CurvedAnimation(
        parent: _controller,
        curve: const Interval(0.3, 0.6, curve: Curves.easeInOut),
      ),
    );

    // Text sliding in from left to right and fading in
    _textRevealAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _controller,
        curve: const Interval(0.39, 0.69, curve: Curves.easeInOut),
      ),
    );

    _textFadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _controller,
        curve: const Interval(0.39, 0.69, curve: Curves.easeInOut),
      ),
    );

    // Start the animation
    _controller.forward();

    Future.delayed(Duration(seconds: 3), () {
      Navigator.pushReplacementNamed(context, '/onboarding');
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          // Splash screen background
          Image.asset(
            'assets/images/background.png',
            fit: BoxFit.cover,
            width: double.infinity,
            height: double.infinity,
          ),

          // Fading black screen
          FadeTransition(
            opacity: _blackScreenFadeAnimation,
            child: Container(
              color: Colors.black,
              width: double.infinity,
              height: double.infinity,
            ),
          ),

          // Logo sliding left, scaling down, and fading out
          SlideTransition(
            position: _logoSlideAnimation,
            child: FadeTransition(
              opacity: _logoFadeAnimation,
              child: ScaleTransition(
                scale: _logoScaleAnimation, // Apply the scaling transition
                child: Center(
                  child: Image.asset(
                    'assets/images/solgate-logo-main.png',
                    width: 200,
                    height: 200,
                  ),
                ),
              ),
            ),
          ),

          // Text sliding in and fading in
          AnimatedBuilder(
            animation: _textRevealAnimation,
            builder: (context, child) {
              return ClipRect(
                clipper: LeftToRightClipper(_textRevealAnimation.value),
                child: FadeTransition(
                  opacity: _textFadeAnimation,
                  child: Center(
                    child: Image.asset(
                      'assets/images/splash-text.png',
                      width: 300,
                      height: 100,
                    ),
                  ),
                ),
              );
            },
          ),
        ],
      ),
    );
  }
}