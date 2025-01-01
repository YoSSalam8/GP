import 'package:flutter/material.dart';
import 'package:graduation_project/ui/Home/calendar_screen.dart';
import 'package:graduation_project/ui/Home/profile_screen.dart';
import 'package:graduation_project/ui/Home/today_screen.dart';
import 'package:graduation_project/ui/Home/employee_profile_screen.dart';
import 'package:graduation_project/ui/Home/vacation_request_screen.dart';
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
  int currentIndex = 0;

  @override
  void initState() {
    super.initState();
  }

  // Method to handle logout
  void _showLogoutDialog() {
    double screenWidth = MediaQuery.of(context).size.width;
    bool isWeb = screenWidth > 600; // Check if it's a web environment

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return Dialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
          child: ConstrainedBox(
            constraints: BoxConstraints(
              maxWidth: isWeb ? 400 : double.infinity, // Limit width for web
            ),
            child: Padding(
              padding: EdgeInsets.all(isWeb ? 30 : 20), // Add more padding for web
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Icon(
                    Icons.logout,
                    size: 60, // Slightly larger icon
                    color: Colors.redAccent,
                  ),
                  const SizedBox(height: 20),
                  Text(
                    "Confirm Logout",
                    style: TextStyle(
                      fontSize: isWeb ? 26 : 22, // Adjust font size for web
                      fontWeight: FontWeight.bold,
                      color: Colors.black87,
                    ),
                  ),
                  const SizedBox(height: 10),
                  Text(
                    "Are you sure you want to logout?",
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: isWeb ? 18 : 16, // Adjust font size for web
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
                          padding: EdgeInsets.symmetric(
                            vertical: isWeb ? 16 : 12, // Larger padding for web
                          ),
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
                          padding: EdgeInsets.symmetric(
                            vertical: isWeb ? 16 : 12, // Larger padding for web
                          ),
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
          ),
        );
      },
    );
  }

  // Method to navigate to the specific screen
  void _navigateTo(int index) {
    setState(() {
      currentIndex = index;
    });
    Navigator.pop(context);  // Close the drawer when an item is clicked
  }

  @override
  Widget build(BuildContext context) {
    screenHeight = MediaQuery.of(context).size.height;
    screenWidth = MediaQuery.of(context).size.width;

    return Scaffold(
      appBar: AppBar(
        title: Text(getPageTitle(currentIndex)), // Dynamic page title
        backgroundColor: Colors.blue.shade900,
        leading: Builder(
          builder: (BuildContext context) {
            return IconButton(
              icon: const Icon(Icons.menu), // Hamburger menu icon
              onPressed: () {
                Scaffold.of(context).openDrawer(); // Opens the drawer when the icon is tapped
              },
            );
          },
        ),
      ),

      // Add the Drawer widget
      drawer: Drawer(
        child: ListView(
          padding: const EdgeInsets.all(0),
          children: [
            UserAccountsDrawerHeader(
              accountName: Text("Employee Name"), // You can customize this with dynamic data
              accountEmail: Text("employee@example.com"), // Similarly, dynamic email can be shown
              currentAccountPicture: CircleAvatar(
                backgroundColor: Colors.white,
                child: Icon(Icons.person, color: Colors.blue),
              ),
            ),
            ListTile(
              leading: Icon(Icons.home),
              title: Text("Today"),
              onTap: () => _navigateTo(0),
            ),
            ListTile(
              leading: Icon(Icons.calendar_month),
              title: Text("Calendar"),
              onTap: () => _navigateTo(1),
            ),
            ListTile(
              leading: Icon(Icons.person),
              title: Text("Employee Details"),
              onTap: () => _navigateTo(2),
            ),
            ListTile(
              leading: Icon(Icons.account_circle),
              title: Text("Edit Profile"),
              onTap: () => _navigateTo(3),
            ),
            ListTile(
              leading: Icon(Icons.request_page),
              title: Text("Vacation Request"),
              onTap: () => _navigateTo(4),
            ),
            Divider(),
            ListTile(
              leading: Icon(Icons.logout),
              title: Text("Logout"),
              onTap: _showLogoutDialog,
            ),
          ],
        ),
      ),

      body: IndexedStack(
        index: currentIndex,
        children: const [
          TodayScreen(),
          CalendarScreen(),
          EmployeeProfileScreen(),
          ProfileScreen(),
          VacationRequestScreen(),
        ],
      ),
    );
  }

  // Function to get the page title dynamically
  String getPageTitle(int index) {
    switch (index) {
      case 0:
        return "Today Attendance";
      case 1:
        return "Monthly Attendance";
      case 2:
        return "Employee Profile";
      case 3:
        return "Profile";
      case 4:
        return "Vacation Request";
      default:
        return "Home";
    }
  }
}
