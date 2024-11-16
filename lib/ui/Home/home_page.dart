import 'package:flutter/material.dart';
import 'package:graduation_project/ui/Home/calendar_screen.dart';
import 'package:graduation_project/ui/Home/profile_screen.dart';
import 'package:graduation_project/ui/Home/services/location_service.dart';
import 'package:graduation_project/ui/Home/today_screen.dart';
import 'package:graduation_project/ui/Home/employee_profile_screen.dart'; // Import the Employee Profile Screen
import 'package:graduation_project/ui/Home/vacation_request_screen.dart'; // Import the new page
import 'package:graduation_project/ui/Login/login_page.dart';

import 'model/user.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  double screenHeight = 0;
  double screenWidth = 0;

  String id = '';

  List<IconData> navigationIcons = [
    Icons.home, // Today screen
    Icons.calendar_month, // Calendar screen
    Icons.person, // Employee Profile screen
    Icons.account_circle, // Profile screen
    Icons.request_page, // Vacation request screen
    Icons.logout, // Logout icon
  ];
  int currentIndex = 0;

  @override
  void initState() {
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

  void _showLogoutDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return Dialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
          child: Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Icon(
                  Icons.logout,
                  size: 50,
                  color: Colors.redAccent,
                ),
                const SizedBox(height: 20),
                const Text(
                  "Confirm Logout",
                  style: TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                    color: Colors.black87,
                  ),
                ),
                const SizedBox(height: 10),
                Text(
                  "Are you sure you want to logout?",
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 16,
                    color: Colors.grey[700],
                  ),
                ),
                const SizedBox(height: 25),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.grey[300],
                        foregroundColor: Colors.black,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                      onPressed: () {
                        Navigator.of(context).pop(); // Close the dialog
                      },
                      child: const Text("Cancel"),
                    ),
                    ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.redAccent,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                      onPressed: () {
                        Navigator.of(context).pop(); // Close the dialog
                        Navigator.of(context).pushReplacement(
                          MaterialPageRoute(
                            builder: (context) => const Login(),
                          ),
                        );
                      },
                      child: const Text(
                        "Logout",
                        style: TextStyle(color: Colors.white),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    screenHeight = MediaQuery.of(context).size.height;
    screenWidth = MediaQuery.of(context).size.width;

    return Scaffold(
      body: IndexedStack(
        index: currentIndex,
        children: const [
          TodayScreen(), // Today Screen
          CalendarScreen(), // Calendar Screen
          EmployeeProfileScreen(), // Employee Profile Screen
          ProfileScreen(), // Profile Screen
          VacationRequestScreen(), // Vacation Request Screen
        ],
      ),
      bottomNavigationBar: Container(
        height: 70,
        margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
        decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.all(Radius.circular(40)),
          boxShadow: [
            BoxShadow(
              color: Colors.black26,
              blurRadius: 10,
              offset: Offset(2, 2),
            ),
          ],
        ),
        child: ClipRRect(
          borderRadius: const BorderRadius.all(Radius.circular(40)),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              for (int i = 0; i < navigationIcons.length; i++)
                Expanded(
                  child: GestureDetector(
                    onTap: () {
                      setState(() {
                        if (i == navigationIcons.length - 1) {
                          _showLogoutDialog(); // Show logout dialog
                        } else {
                          currentIndex = i; // Switch to the selected tab
                        }
                      });
                    },
                    child: Container(
                      color: Colors.white,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            navigationIcons[i],
                            color: i == currentIndex
                                ? const Color(0xFF608BC1)
                                : Colors.black54,
                            size: i == currentIndex ? 40 : 30,
                          ),
                          if (i == currentIndex && i != navigationIcons.length - 1)
                            Container(
                              margin: const EdgeInsets.only(top: 6),
                              height: 3,
                              width: 22,
                              decoration: BoxDecoration(
                                borderRadius: const BorderRadius.all(Radius.circular(40)),
                                color: const Color(0xFF608BC1),
                              ),
                            ),
                        ],
                      ),
                    ),
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }
}
