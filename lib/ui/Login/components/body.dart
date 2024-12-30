import 'package:flutter/material.dart';
import 'package:graduation_project/ui/Admin/admin_home.dart';
import 'package:graduation_project/ui/Home/home_page.dart';
import 'package:graduation_project/ui/Login/components/already_have_an_account_check.dart';
import 'package:graduation_project/ui/Login/components/background.dart';
import 'package:graduation_project/ui/Login/components/rounded_button.dart';
import 'package:graduation_project/ui/Login/components/rounded_input_field.dart';
import 'package:graduation_project/ui/Login/components/rounded_password_field.dart';
import 'package:graduation_project/ui/Signup/signup_page.dart';

class Body extends StatelessWidget {
  const Body({super.key});

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;

    // Determine if the device is a web screen or mobile
    bool isWeb = size.width > 600;

    return Background(
      child: Center(
        child: SingleChildScrollView(
          padding: EdgeInsets.symmetric(
            horizontal: isWeb ? size.width * 0.2 : 20, // Add side margins for web
          ),
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
                height: isWeb ? 250 : size.height * 0.35, // Adjust image size for web
                fit: BoxFit.contain,
              ),
              SizedBox(height: size.height * 0.03),
              ConstrainedBox(
                constraints: BoxConstraints(
                  maxWidth: isWeb ? 400 : double.infinity, // Constrain width for web
                ),
                child: RoundedInputField(
                  hintText: "Your Email",
                  onChanged: (value) {},
                ),
              ),
              ConstrainedBox(
                constraints: BoxConstraints(
                  maxWidth: isWeb ? 400 : double.infinity, // Constrain width for web
                ),
                child: RoundedPasswordField(
                  onChanged: (value) {},
                ),
              ),
              SizedBox(height: size.height * 0.03),
              ConstrainedBox(
                constraints: BoxConstraints(
                  maxWidth: isWeb ? 400 : double.infinity, // Constrain width for web
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
                  maxWidth: isWeb ? 400 : double.infinity, // Constrain width for web
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
    );
  }
}
