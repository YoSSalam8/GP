import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:graduation_project/ui/Home/calendar_screen.dart';
import 'package:graduation_project/ui/Home/profile_screen.dart';
import 'package:graduation_project/ui/Home/services/location_service.dart';
import 'package:graduation_project/ui/Home/today_screen.dart';

import 'model/user.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  double screenHeight=0;
  double screenWidth=0;

  String id ='';

  List<IconData> navigationIcons=[
    Icons.home,
    Icons.calendar_month,
    Icons.person,
  ];
  int currentIndex=0;

  void initstate(){
    super.initState();
    _startLocationService();
  }


  void _startLocationService() async {
    LocationService().initialize();

    LocationService().getLongitude().then((value) {
      setState(() {
        User.long = value!;
      });
      LocationService().getLatitude().then((value) {
        setState(() {
          User.lat = value!;
        });
      });
    });
  }


  @override
  Widget build(BuildContext context) {
    screenHeight=MediaQuery.of(context).size.height;
    screenWidth=MediaQuery.of(context).size.width;

    return Scaffold(
      body: IndexedStack(
        index: currentIndex,
        children: const [
          TodayScreen(),
          CalendarScreen(),
          ProfileScreen(),
        ],
      ),

      bottomNavigationBar: Container(
        height: 70,
        margin: EdgeInsets.only(
          left: 12,
          right: 12,
          bottom: 24,
        ),
        decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.all(Radius.circular(40)),
          boxShadow: [
            BoxShadow(
              color: Colors.black26,
              blurRadius: 10,
              offset: Offset(2, 2),
            )
          ]
        ),
        child: ClipRRect(
          borderRadius: const BorderRadius.all(Radius.circular(40)),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              for(int i=0; i<navigationIcons.length;i++)...<Expanded>{
                Expanded(child: GestureDetector(
                  onTap: (){
                    setState(() {
                      currentIndex=i;
                    });
                  },
                  child: Container(
                    height: screenHeight,
                    width: screenWidth,
                    color: Colors.white,
                    child: Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(navigationIcons[i],
                            color: i== currentIndex? Colors.purple.shade700 : Colors.black54,
                            size: i== currentIndex? 40 : 30,),
                            i == currentIndex ? Container(
                            margin: EdgeInsets.only(top: 6),
                            height: 3,
                            width: 22,
                            decoration: BoxDecoration(
                              borderRadius: const BorderRadius.all(Radius.circular(40)),
                              color: Colors.purple.shade700,
                            ),

                          ) : const SizedBox(),
                        ],
                      ),
                    ),
                  ),
                ))
              }

            ],
          ),
        ),
      ),
    );
  }
}

