import 'package:flutter/material.dart';

class Background extends StatelessWidget {
  final Widget child;
  const Background({
    super.key,
    required this.child,
  });

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;

    // Determine if the device is a web screen or mobile
    bool isWeb = size.width > 600;

    return Container(
      width: double.infinity,
      height: size.height,
      child: Stack(
        alignment: Alignment.center,
        children: <Widget>[
          if (!isWeb) // Show these images only on mobile
            Positioned(
              top: 0,
              left: 0,
              child: Image.asset(
                'images/login_top.png',
                width: size.width * 0.35,
              ),
            ),
          if (!isWeb) // Show these images only on mobile
            Positioned(
              bottom: 0,
              right: 0,
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
