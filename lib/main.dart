import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'ui/Boarding/onboarding_screen.dart';

void main(){
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      title: 'Onboaring Screen',
      home: OnboardingScreen(),
      debugShowCheckedModeBanner: false,
    );
  }
}
