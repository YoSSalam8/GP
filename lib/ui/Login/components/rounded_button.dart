import 'package:flutter/material.dart';

class RoundedButton extends StatelessWidget {
  final String text;
  final VoidCallback press;
  final Color color, textColor;

  const RoundedButton({
    super.key,
    required this.text,
    required this.press,
    required this.color,
    required this.textColor,
  });

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;

    // Set responsive width and height
    double buttonWidth = size.width < 600 ? size.width * 0.9 : 300; // Full width on mobile, fixed width on web
    double buttonHeight = size.width < 600 ? size.width * 0.15 : 50; // Proportional on mobile, fixed height on web

    return Container(
      width: buttonWidth,
      height: buttonHeight,
      child: ClipRRect(
        borderRadius: BorderRadius.circular(29),
        child: TextButton(
          onPressed: press,
          style: TextButton.styleFrom(
            backgroundColor: color,
            padding: size.width < 600
                ? const EdgeInsets.symmetric(vertical: 20, horizontal: 40)
                : const EdgeInsets.symmetric(vertical: 15, horizontal: 20), // Adjust padding for web
          ),
          child: Text(
            text,
            style: TextStyle(
              color: textColor,
              fontSize: size.width < 600 ? 16 : 18, // Slightly larger font size for web
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      ),
    );
  }
}
