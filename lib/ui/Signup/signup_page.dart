import 'package:flutter/material.dart';
import 'package:graduation_project/ui/Signup/components/body.dart';

class SignupPage extends StatelessWidget {
  const SignupPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: const Body(), // No need to pass a child since Body doesn't expect it
    );
  }
}
