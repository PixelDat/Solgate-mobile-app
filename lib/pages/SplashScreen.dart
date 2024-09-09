import 'package:flutter/material.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({Key? key}) : super(key: key);

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<Offset> _blackScreenTopLeftAnimation;
  late Animation<Offset> _blackScreenBottomRightAnimation;
  late Animation<Offset> _logoSlideAnimation;
  late Animation<double> _logoFadeAnimation;
  late Animation<Offset> _textSlideAnimation;
  late Animation<double> _textFadeAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(seconds: 3),
      vsync: this,
    );

    // Black screen opening animation
    _blackScreenTopLeftAnimation = Tween<Offset>(
      begin: Offset.zero,
      end: const Offset(-1.0, -1.0),
    ).animate(
      CurvedAnimation(
        parent: _controller,
        curve: const Interval(0.0, 0.3, curve: Curves.easeInOut),
      ),
    );

    _blackScreenBottomRightAnimation = Tween<Offset>(
      begin: Offset.zero,
      end: const Offset(1.0, 1.0),
    ).animate(
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

    // Text sliding in from left to right and fading in
    _textSlideAnimation = Tween<Offset>(
      begin: const Offset(-1, 0),
      end: Offset.zero,
    ).animate(
      CurvedAnimation(
        parent: _controller,
        curve: const Interval(0.6, 1.0, curve: Curves.easeInOut),
      ),
    );

    _textFadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _controller,
        curve: const Interval(0.6, 1.0, curve: Curves.easeInOut),
      ),
    );

    // Start the animation
    _controller.forward();

    Future.delayed(const Duration(seconds: 4), () {
      Navigator.pushReplacementNamed(context, '/home');
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

          // Black screen opening from middle
          SlideTransition(
            position: _blackScreenTopLeftAnimation,
            child: Container(color: Colors.black, width: double.infinity, height: double.infinity),
          ),
          SlideTransition(
            position: _blackScreenBottomRightAnimation,
            child: Container(color: Colors.black, width: double.infinity, height: double.infinity),
          ),

          // Logo sliding left and fading out
          SlideTransition(
            position: _logoSlideAnimation,
            child: FadeTransition(
              opacity: _logoFadeAnimation,
              child: Center(
                child: Image.asset(
                  'assets/images/solgate-logo-main.png',
                  width: 200,
                  height: 200,
                ),
              ),
            ),
          ),

          // Text sliding in and fading in
          SlideTransition(
            position: _textSlideAnimation,
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
          ),
        ],
      ),
    );
  }
}