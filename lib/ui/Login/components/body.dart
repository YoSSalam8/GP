import 'package:flutter/material.dart';
import 'package:graduation_project/ui/Boarding//landing_page.dart';
import 'package:graduation_project/ui/Admin/admin_home.dart';
import 'package:graduation_project/ui/Home/home_page.dart';
import 'package:graduation_project/ui/Login/components/already_have_an_account_check.dart';
import 'package:graduation_project/ui/Login/components/background.dart';
import 'package:graduation_project/ui/Login/components/rounded_button.dart';
import 'package:graduation_project/ui/Login/components/rounded_input_field.dart';
import 'package:graduation_project/ui/Login/components/rounded_password_field.dart';
import 'package:graduation_project/ui/Signup/signup_page.dart';

class Body extends StatefulWidget {
  const Body({super.key});

  @override
  _BodyState createState() => _BodyState();
}

class _BodyState extends State<Body> with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<Offset> _slideAnimation;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 800),
      vsync: this,
    );
    _slideAnimation = Tween<Offset>(
      begin: const Offset(0.0, 1.0),
      end: Offset.zero,
    ).animate(
      CurvedAnimation(
        parent: _animationController,
        curve: Curves.easeOut,
      ),
    );
    _animationController.forward();
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }



  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;

    // Determine if the device is a web screen or mobile
    bool isWeb = size.width > 660;

    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color(0xFF133E87),
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () {
            Navigator.pop(context); // Navigate back to the landing page
          },
        ),
        title: const Text(
          "Login",
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        ),
      ),
      body: Background(
        child: Center(
          child: SingleChildScrollView(
            padding: EdgeInsets.symmetric(
              horizontal: isWeb ? size.width * 0.1 : 20, // Adjust padding for web
            ),
            child: SlideTransition(
              position: _slideAnimation,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  const Text(
                    "LOGIN",
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 28, // Slightly larger for web
                      color: Color(0xFF133E87),
                    ),
                  ),
                  SizedBox(height: size.height * 0.03),
                  Image.asset(
                    'images/login.png',
                    height: isWeb ? 300 : size.height * 0.35, // Adjust image size for web
                    fit: BoxFit.contain,
                  ),
                  SizedBox(height: size.height * 0.03),
                  ConstrainedBox(
                    constraints: BoxConstraints(
                      maxWidth: isWeb ? 500 : double.infinity, // Constrain width for web
                    ),
                    child: RoundedInputField(
                      hintText: "Your Email",
                      onChanged: (value) {},
                    ),
                  ),
                  ConstrainedBox(
                    constraints: BoxConstraints(
                      maxWidth: isWeb ? 500 : double.infinity, // Constrain width for web
                    ),
                    child: RoundedPasswordField(
                      onChanged: (value) {},
                    ),
                  ),
                  SizedBox(height: size.height * 0.03),
                  ConstrainedBox(
                    constraints: BoxConstraints(
                      maxWidth: isWeb ? 500 : double.infinity, // Constrain width for web
                    ),
                    child: RoundedButton(
                      text: "LOGIN",
                      press: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) {
                              return const HomePage();
                            },
                          ),
                        );
                      },
                      color: const Color(0xFF608BC1),
                      textColor: Colors.white,
                    ),
                  ),
                  SizedBox(height: size.height * 0.02),
                  ConstrainedBox(
                    constraints: BoxConstraints(
                      maxWidth: isWeb ? 500 : double.infinity, // Constrain width for web
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Flexible(
                          child: ElevatedButton.icon(
                            onPressed: () {
                              // Add Gmail login functionality here
                            },
                            icon: Image.asset(
                              'images/gmail_icon1.jpeg', // Path to Gmail logo
                              height: 80,
                              width: 80,
                            ),
                            label: const Text("Login with Gmail"),
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.white,
                              foregroundColor: Colors.red,
                              side: const BorderSide(color: Colors.red),
                            ),
                          ),
                        ),
                        SizedBox(width: 20), // Increased spacing between buttons
                        Flexible(
                          child: ElevatedButton.icon(
                            onPressed: () {
                              // Add Microsoft login functionality here
                            },
                            icon: Image.asset(
                              'images/microsoft_icon1.jpg', // Path to Microsoft logo
                              height: 80,
                              width: 80,
                            ),
                            label: const Text("Login with Microsoft"),
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.white,
                              foregroundColor: Color(0xFF00A4EF), // Microsoft blue
                              side: const BorderSide(color: Color(0xFF00A4EF)),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(height: size.height * 0.02),
                  ConstrainedBox(
                    constraints: BoxConstraints(
                      maxWidth: isWeb ? 500 : double.infinity, // Constrain width for web
                    ),
                    child: AlreadyHaveAnAccountCheck(
                      press: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) {
                              return const SignupPage();
                            },
                          ),
                        );
                      },
                      login: true,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
