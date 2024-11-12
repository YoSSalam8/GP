import 'package:flutter/material.dart';
import 'package:graduation_project/ui/Login/components/already_have_an_account_check.dart';
import 'package:graduation_project/ui/Login/components/rounded_button.dart';
import 'package:graduation_project/ui/Login/components/rounded_input_field.dart';
import 'package:graduation_project/ui/Login/components/rounded_password_field.dart';
import 'package:graduation_project/ui/Login/login_page.dart';
import 'package:graduation_project/ui/Signup/components/background.dart';

class Body extends StatelessWidget {
  final Widget child;
  const Body({super.key, required this.child});

  @override
  Widget build(BuildContext context) {
    Size size=MediaQuery.of(context).size;

    return Background(child:
    SingleChildScrollView(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Text("SIGNUP",style: TextStyle(fontWeight: FontWeight.bold),),
          SizedBox(height: size.height*0.03,),
          Image.asset('images/signup.png',height:size.height*0.35,),
          SizedBox(height: size.height*0.03,),
          RoundedInputField(hintText: "Your Email", onChanged: (value) {},),
          RoundedPasswordField(onChanged: (value){}),
          RoundedPasswordField(onChanged: (value){}),
          RoundedInputField(hintText: "Access Code", onChanged: (value) {},),
          RoundedButton(text:"SIGNUP", press: (){}, color: Colors.purple.shade500, textColor: Colors.white),
          SizedBox(height: size.height*0.03,),
          AlreadyHaveAnAccountCheck(login: false,press:(){Navigator.push(context, MaterialPageRoute(builder: (context){return Login();},),);} ,),
        ],
      
      ),
    ),);
  }
}

