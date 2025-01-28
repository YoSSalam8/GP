import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
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

  // Controllers for email and password input fields
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

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
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  Future<void> _login(BuildContext context) async {
    final String email = _emailController.text.trim();
    final String password = _passwordController.text.trim();

    if (email.isEmpty || password.isEmpty) {
      _showDialog(context, "Invalid Input", "Please enter both email and password.");
      return;
    }

    const String url = "http://192.168.1.101:8080/api/auth/login";

    try {
      final response = await http.post(
        Uri.parse(url),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({'email': email, 'password': password}),
      );

      if (response.statusCode == 200) {
        final String token = jsonDecode(response.body)['token'];
        print("Token received: $token");

        // Navigate to HomePage and pass the token
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (context) => HomePage(token: token), // Pass the token
          ),
        );
      } else {
        _showDialog(context, "Login Failed", "The email or password is incorrect.");
      }
    } catch (e) {
      print("Error: $e");
      _showDialog(context, "Error", "An error occurred during login. Please try again.");
    }
  }

  void _showDialog(BuildContext context, String title, String message) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20), // Rounded corners
        ),
        title: Row(
          children: [
            Icon(
              title == "Login Failed" ? Icons.error_outline : Icons.info_outline,
              color: title == "Login Failed" ? Colors.redAccent : Colors.blueAccent,
              size: 30,
            ),
            const SizedBox(width: 10),
            Expanded(
              child: Text(
                title,
                style: const TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF133E87),
                ),
              ),
            ),
          ],
        ),
        content: Text(
          message,
          style: const TextStyle(fontSize: 16, color: Colors.black87),
        ),
        actions: <Widget>[
          Center(
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF133E87), // Use backgroundColor instead of primary
                padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              child: const Text(
                "Close",
                style: TextStyle(fontSize: 18, color: Colors.white),
              ),
              onPressed: () {
                Navigator.of(context).pop(); // Close the dialog
              },
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;

    bool isWeb = size.width > 660;

    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color(0xFF133E87),
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () {
            Navigator.pop(context);
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
              horizontal: isWeb ? size.width * 0.1 : 20,
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
                      fontSize: 28,
                      color: Color(0xFF133E87),
                    ),
                  ),
                  SizedBox(height: size.height * 0.03),
                  Image.asset(
                    'images/login.png',
                    height: isWeb ? 300 : size.height * 0.35,
                    fit: BoxFit.contain,
                  ),
                  SizedBox(height: size.height * 0.03),
                  ConstrainedBox(
                    constraints: BoxConstraints(
                      maxWidth: isWeb ? 500 : double.infinity,
                    ),
                    child: RoundedInputField(
                      hintText: "Your Email",
                      onChanged: (value) {},
                      controller: _emailController, // Bind controller
                    ),
                  ),
                  ConstrainedBox(
                    constraints: BoxConstraints(
                      maxWidth: isWeb ? 500 : double.infinity,
                    ),
                    child: RoundedPasswordField(
                      onChanged: (value) {},
                      controller: _passwordController, // Bind controller
                    ),
                  ),
                  SizedBox(height: size.height * 0.03),
                  ConstrainedBox(
                    constraints: BoxConstraints(
                      maxWidth: isWeb ? 500 : double.infinity,
                    ),
                    child: RoundedButton(
                      text: "LOGIN",
                      press: () => _login(context),
                      color: const Color(0xFF608BC1),
                      textColor: Colors.white,
                    ),
                  ),
                  SizedBox(height: size.height * 0.02),
                  ConstrainedBox(
                    constraints: BoxConstraints(
                      maxWidth: isWeb ? 500 : double.infinity,
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
