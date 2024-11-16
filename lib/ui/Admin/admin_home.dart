import 'package:flutter/material.dart';
import 'admin_today.dart';
import 'admin_monthly.dart';
import 'admin_salary.dart';
import 'admin_absence_vacation.dart';
import 'admin_job_interviews.dart';
import 'admin_requests.dart'; // Import the new AdminRequestsPage
import 'package:graduation_project/ui/Login/login_page.dart';

class AdminHomePage extends StatefulWidget {
  const AdminHomePage({super.key});

  @override
  State<AdminHomePage> createState() => _AdminHomePageState();
}

class _AdminHomePageState extends State<AdminHomePage> {
  double screenHeight = 0;
  double screenWidth = 0;

  // Define the navigation icons
  final List<IconData> navigationIcons = [
    Icons.today, // Today's Attendance
    Icons.search, // Monthly Attendance Search
    Icons.attach_money, // Salary Calculation
    Icons.group_off, // Absence/Vacation Page
    Icons.event, // Job Interviews Page
    Icons.inbox, // Requests Page
    Icons.logout, // Logout icon
  ];

  int currentIndex = 0;

  // Define the color palette
  final Color primaryColor = const Color(0xFF133E87);
  final Color activeColor = const Color(0xFF608BC1);
  final Color indicatorColor = const Color(0xFFCBDCEB);

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
                            builder: (context) => const Login(), // Navigate to Login page
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
      backgroundColor: Colors.white, // White background
      body: IndexedStack(
        index: currentIndex,
        children: const [
          AdminTodayAttendancePage(),
          AdminMonthlyAttendancePage(),
          AdminSalaryCalculationPage(),
          AdminAbsenceVacationPage(),
          AdminJobInterviewsPage(),
          AdminRequestsPage(), // New requests page
        ],
      ),
      bottomNavigationBar: Container(
        height: 70,
        margin: const EdgeInsets.only(left: 12, right: 12, bottom: 24),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: const BorderRadius.all(Radius.circular(40)),
          boxShadow: [
            BoxShadow(
              color: Colors.black26,
              blurRadius: 10,
              offset: const Offset(2, 2),
            ),
          ],
        ),
        child: ClipRRect(
          borderRadius: const BorderRadius.all(Radius.circular(40)),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              for (int i = 0; i < navigationIcons.length; i++) ...<Expanded>{
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
                      height: screenHeight,
                      width: screenWidth,
                      color: Colors.white,
                      child: Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(
                              navigationIcons[i],
                              color: i == currentIndex
                                  ? activeColor // Active icon color
                                  : Colors.black54, // Inactive icon color
                              size: i == currentIndex ? 40 : 30,
                            ),
                            if (i == currentIndex && i != navigationIcons.length - 1)
                              Container(
                                margin: const EdgeInsets.only(top: 6),
                                height: 3,
                                width: 22,
                                decoration: BoxDecoration(
                                  borderRadius: const BorderRadius.all(Radius.circular(40)),
                                  color: indicatorColor, // Indicator color
                                ),
                              ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              }
            ],
          ),
        ),
      ),
    );
  }
}
