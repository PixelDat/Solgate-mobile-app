import 'package:flutter/material.dart';

class GradientBorderButton extends StatelessWidget {
  final Widget child;
  final VoidCallback onPressed;

  const GradientBorderButton({
    Key? key,
    required this.child,
    required this.onPressed,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            Color.fromARGB(255, 185, 68, 235),
            Color(0xFF4EADFF),
            Color(0xFF5EEBC7),
          ],
          stops: [0.2, 0.7, 1.0],
          begin: Alignment.centerLeft,
          end: Alignment.centerRight,
        ),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Container(
        margin: EdgeInsets.all(2), // This creates the border effect
        decoration: BoxDecoration(
          color: Colors.black, // Match this with your background color
          borderRadius: BorderRadius.circular(18),
        ),
        child: ElevatedButton(
          child: child,
          onPressed: onPressed,
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.transparent,
            foregroundColor: Colors.white,
            elevation: 0,
            padding: EdgeInsets.symmetric(vertical: 16),
            minimumSize: Size(double.infinity, 60),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(18),
            ),
          ),
        ),
      ),
    );
  }
}
