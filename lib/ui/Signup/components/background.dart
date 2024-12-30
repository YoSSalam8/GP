import 'package:flutter/material.dart';

class Background extends StatelessWidget {
  final Widget child;
  final bool showBackgroundImages; // Define the new parameter

  const Background({
    super.key,
    required this.child,
    this.showBackgroundImages = true, // Default to showing images
  });

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;

    return Container(
      height: size.height,
      width: double.infinity,
      child: Stack(
        alignment: Alignment.center,
        children: <Widget>[
          if (showBackgroundImages) // Conditionally show background images
            Positioned(
              top: 0,
              left: 0,
              child: Image.asset(
                'images/login_top.png',
                width: size.width * 0.35,
              ),
            ),
          if (showBackgroundImages) // Conditionally show background images
            Positioned(
              right: 0,
              bottom: 0,
              child: Image.asset(
                'images/login_bottom.png',
                width: size.width * 0.4,
              ),
            ),
          child,
        ],
      ),
    );
  }
}
