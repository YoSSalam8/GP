import 'package:flutter/material.dart';
import 'package:graduation_project/ui/Signup/components/multi_stage_signup.dart';

class SignupPage extends StatelessWidget {
  const SignupPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: const MultiStageSignUp(),
    );
  }
}
