import 'package:flutter/material.dart';
import 'package:graduation_project/ui/Admin/admin_home.dart';
import 'package:graduation_project/ui/Login/components/already_have_an_account_check.dart';
import 'package:graduation_project/ui/Login/components/rounded_button.dart';
import 'package:graduation_project/ui/Login/components/rounded_input_field.dart';
import 'package:graduation_project/ui/Login/components/rounded_password_field.dart';
import 'package:graduation_project/ui/Login/login_page.dart';
import 'package:graduation_project/ui/Signup/components/background.dart';

class Body extends StatelessWidget {
  const Body({super.key});

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    bool isWeb = size.width > 600; // Determine if the device is web

    return Background(
      showBackgroundImages: !isWeb, // Hide background images on web
      child: Center(
        child: SingleChildScrollView(
          padding: EdgeInsets.symmetric(
            horizontal: isWeb ? size.width * 0.2 : 16, // Add side margins for web
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              SizedBox(height: isWeb ? 50 : 100), // Adjust spacing for web
              Text(
                "SIGNUP",
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: isWeb ? 32 : 24, // Larger font for web
                  color: const Color(0xFF133E87),
                ),
              ),
              SizedBox(height: size.height * 0.03),
              Image.asset(
                'images/signup.png', // Ensure the image remains on both web and mobile
                height: isWeb ? 250 : size.height * 0.35, // Adjust size for web
                fit: BoxFit.contain,
              ),
              SizedBox(height: size.height * 0.03),
              RoundedInputField(
                hintText: "Your Email",
                onChanged: (value) {},
              ),
              RoundedPasswordField(
                onChanged: (value) {},
              ),
              RoundedPasswordField(
                onChanged: (value) {},
              ),
              RoundedInputField(
                hintText: "Access Code",
                onChanged: (value) {},
              ),
              RoundedButton(
                text: "SIGNUP",
                press: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) {
                        return const AdminHomePage();
                      },
                    ),
                  );
                },
                color: const Color(0xFF608BC1),
                textColor: Colors.white,
              ),
              SizedBox(height: size.height * 0.03),
              AlreadyHaveAnAccountCheck(
                login: false,
                press: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) {
                        return const Login();
                      },
                    ),
                  );
                },
              ),
              SizedBox(height: isWeb ? 20 : size.height * 0.1), // Adjust spacing for web
            ],
          ),
        ),
      ),
    );
  }
}
