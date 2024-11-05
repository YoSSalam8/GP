import 'package:flutter/material.dart';

class RoundedButton extends StatelessWidget {
  final String text;
  final VoidCallback press;
  final Color color,textColor;
  const RoundedButton({super.key, required this.text, required this.press, required this.color, required this.textColor});

  @override
  Widget build(BuildContext context) {
    Size size=MediaQuery.of(context).size;
    return Container(
      width: size.width*0.9,
      height: size.width*0.2,
      child: ClipRRect(
        borderRadius: BorderRadius.circular(29),
        child: Padding(
          padding:EdgeInsets.symmetric(vertical: 20,horizontal: 40),
          child: TextButton(
              onPressed: press,
            style: TextButton.styleFrom(
              backgroundColor: color // Set background color to purple
            ),
              child: Text(
                text,
                style: TextStyle(color: textColor),
              ),
          ),
        ),
      ),
    );
  }
}
