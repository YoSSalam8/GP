import 'package:flutter/material.dart';

import 'constants.dart';
import '../Login/login_page.dart';



class OnboardingScreen extends StatefulWidget {
  const OnboardingScreen({super.key});

  @override
  State<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> {

  final PageController _pageController=PageController(initialPage: 0);
  int currentIndex=0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0.0,
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 20,left: 20),
            child: const Text('Skip',style: TextStyle(
              color: Colors.black54,
              fontSize: 18.0,
              fontWeight: FontWeight.w500,
            ),),
          )
        ],
      ),
      body: Stack(
        alignment: Alignment.bottomCenter,
        children: [
          PageView(
            onPageChanged: (int page){
              setState(() {
                currentIndex=page;
              });
            },
            controller: _pageController,
            children: [
              createPage(image: 'images/HR_LOGO.png',
              title: Constants.titleOne,
              description: Constants.descOne,),

              createPage(image: 'images/HR_LOGO2.jpg',
                title: Constants.titleTwo,
                description: Constants.descTwo,),

              createPage(image: 'images/Lets_start_logo.jpg',
                title: Constants.titleThree,
                description: Constants.descThree,),
            ],
          ),
          Positioned(
            bottom: 80,
            left: 30,
            child: Row(
              children: _buildIndicator(),
            ),
          ),
          Positioned(
            bottom: 60,
            right: 30,
            child: Container(
              child: IconButton(
                  onPressed: (){
                    setState(() {
                      if(currentIndex <2){
                        currentIndex++;
                        if(currentIndex<3){
                          _pageController.nextPage(duration: Duration(microseconds: 300), curve: Curves.easeIn);
                          }
                        }
                      else{
                        Navigator.pushReplacement(context, MaterialPageRoute(builder: (_)=> const Login()));
                      }
                      }
                  );
                  }, icon: const Icon(Icons.arrow_forward_ios, size: 24, color: Colors.white,)),
              padding: const EdgeInsets.all(4),
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: Colors.purple.shade700,
              ),
              ),
            ),
        ],
      ),
    );
  }


  // Extra Widgets
  Widget _indicator(bool isActive){
    return AnimatedContainer(
      duration: const Duration(microseconds: 300),
      height: 10.0,
      width: isActive ? 20:8,
      margin: const EdgeInsets.only(right: 5.0),
      decoration: BoxDecoration(
        color: Colors.purple.shade700,
        borderRadius: BorderRadius.circular(5),
      ),
    );
  }
  List <Widget> _buildIndicator(){
    List <Widget> indicators=[];

    for(int i=0 ; i<3; i++){
      if(currentIndex==i){
        indicators.add(_indicator(true));
      }
      else{
        indicators.add(_indicator(false));
      }
    }
    return indicators;
  }
}

class createPage extends StatelessWidget {
  final String image;
  final String title;
  final String description;

  const createPage({
    super.key, required this.image, required this.title, required this.description,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.only(left: 50,right: 50,bottom: 80),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          SizedBox(height: 250, child: Image.asset(image),),
          SizedBox(height: 5,),
          Text(
            title,
            textAlign: TextAlign.center,
            style: TextStyle(
              color: Colors.purple.shade700,
              fontSize: 30,
              fontWeight: FontWeight.bold
            ),
          ),
          SizedBox(height: 20,),
          Text(
            description,
            textAlign: TextAlign.center,
            style: const TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.w400,
              color: Colors.black54,
            ),
          )



        ],
      ),
    );
  }
}

