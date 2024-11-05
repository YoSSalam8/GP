import 'package:flutter/material.dart';

class AlreadyHaveAnAccountCheck extends StatelessWidget {
  final bool login;
  final VoidCallback press;
  const AlreadyHaveAnAccountCheck({
    super.key,  this.login=true, required this.press,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        Text(
          login ? "Don't Have An Account? " : "Already Have An Account ? ", style: TextStyle(color: Colors.purple.shade500),),
        GestureDetector(
            onTap: press,
            child: Text(
              login ? "Sign Up" : "Sign In",
              style: TextStyle(
                  color: Colors.purple.shade500,
                  fontWeight: FontWeight.bold),))
      ],
    );
  }
}
