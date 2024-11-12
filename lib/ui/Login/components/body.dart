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
  const Body({
    super.key,

  });



  @override
  Widget build(BuildContext context) {
    Size size=MediaQuery.of(context).size;
    return Background(child: SingleChildScrollView(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Text("LOGIN",
            style: TextStyle(
                fontWeight: FontWeight.bold
            ),
          ),
          SizedBox(height: size.height*0.03,),
          Image.asset('images/login.png',height: size.height*0.35,),
          SizedBox(height: size.height*0.03,),
          RoundedInputField(hintText: "Your Email",
          onChanged: (value) {},),
          RoundedPasswordField(
            onChanged: (value){},
          ),
          SizedBox(height: size.height*0.03,),
          RoundedButton(text: "LOGIN", press: (){Navigator.push(context,MaterialPageRoute(builder: (context) {return HomePage();},),);}, color: Colors.purple.shade700, textColor: Colors.white),
          AlreadyHaveAnAccountCheck(press: (){Navigator.push(context,MaterialPageRoute(builder: (context) {return SignupPage();},),);},
          ),
        ],
      ),
    ),);
  }
}





