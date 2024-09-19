import 'package:flutter/material.dart';

class GradientBorderButton extends StatelessWidget {
  final String text;
  final VoidCallback onPressed;

  const GradientBorderButton({
    Key? key,
    required this.text,
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
        borderRadius: BorderRadius.circular(20), // Updated border radius
      ),
      child: Container(
        margin: EdgeInsets.all(2), // Creates the border effect
        decoration: BoxDecoration(
          color: Colors.transparent, // Transparent body
          borderRadius: BorderRadius.circular(18), // Adjusted to match outer radius minus margin
        ),
        child: ElevatedButton(
          onPressed: onPressed,
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.transparent, // Transparent button background
            foregroundColor: Colors.white, // White text color
            elevation: 0,
            padding: EdgeInsets.symmetric(vertical: 16),
            minimumSize: Size(double.infinity, 60),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(18), // Match inner container radius
            ),
          ),
          child: Center(
            child: Text(
              text,
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Colors.white, // Ensures text is white
              ),
              textAlign: TextAlign.center, // Centers the text
            ),
          ),
        ),
      ),
    );
  }
}
