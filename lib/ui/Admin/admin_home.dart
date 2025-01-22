import 'package:flutter/material.dart';
import 'admin_today.dart';
import 'admin_monthly.dart';
import 'admin_salary.dart';
import 'admin_absence_vacation.dart';
import 'admin_job_interviews.dart';
import 'admin_requests.dart'; // Import the new AdminRequestsPage
import 'admin_check_in_out.dart.dart'; // Correct import for the Admin Check-In/Out page
import 'package:graduation_project/ui/Login/login_page.dart';

class AdminHomePage extends StatefulWidget {
  const AdminHomePage({super.key});

  @override
  State<AdminHomePage> createState() => _AdminHomePageState();
}

class _AdminHomePageState extends State<AdminHomePage> {
  int currentIndex = 0;

  // Define the pages for the Drawer to navigate to
  final List<Widget> pages = const [
    AdminCheckInOutScreen(),
    AdminTodayAttendancePage(),
    AdminMonthlyAttendancePage(),
    AdminSalaryCalculationPage(),
    AdminAbsenceVacationPage(),
    AdminJobInterviewsPage(),

    // Add the Admin Check-In/Out page here
  ];

  final List<String> pageLabels = [
  "Admin Check-In/Out",
    "Today's Attendance",
    "Monthly Attendance",
    "Salary Calculation",
    "Absence & Vacation",
    "Job Interviews",
    "Requests",
     // Add the label for Admin Check-In/Out
  ];

  final List<IconData> pageIcons = [
    Icons.access_alarm,
    Icons.today,
    Icons.search,
    Icons.attach_money,
    Icons.group_off,
    Icons.event,
    Icons.inbox,
     // You can choose an icon for Check-In/Out
  ];

  // Function to get page title based on index
  String getPageTitle(int index) {
    switch (index) {
      case 0:
        return "Admin Check-In/Out";
      case 1:
        return "Today's Attendance";
      case 2:
        return "Monthly Attendance";
      case 3:
        return "Salary Calculation";
      case 4:
        return "Absence & Vacation";
      case 5:
        return "Job Interviews";
      case 6:
        return "Requests";
       // Return the title for Admin Check-In/Out
      default:
        return "Admin Dashboard";
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(getPageTitle(currentIndex),style: TextStyle(color: Colors.white),), // Dynamically set the title
        backgroundColor: const Color(0xFF133E87),
      ),
      body: pages[currentIndex], // Display the selected page
      drawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: [
            // Header section
            UserAccountsDrawerHeader(
              decoration: BoxDecoration(color: const Color(0xFF133E87)),
              accountName: const Text(
                'Admin Name', // Replace with actual admin name
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              accountEmail: const Text('admin@example.com'), // Replace with email
              currentAccountPicture: const CircleAvatar(
                backgroundColor: Colors.white,
                child: Icon(Icons.admin_panel_settings, color: Color(0xFF133E87)),
              ),
            ),
            // Drawer items
            for (int i = 0; i < pageLabels.length; i++)
              ListTile(
                leading: Icon(pageIcons[i], color: const Color(0xFF133E87)),
                title: Text(pageLabels[i], style: TextStyle(color: const Color(0xFF133E87))),
                onTap: () {
                  setState(() {
                    currentIndex = i; // Update the current page
                  });
                  Navigator.pop(context); // Close the drawer
                },
              ),
            const Divider(),
            // Logout option
            ListTile(
              leading: const Icon(Icons.logout, color: Colors.red),
              title: const Text("Logout", style: TextStyle(color: Colors.red)),
              onTap: () {
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(builder: (context) => const Login()), // Navigate to Login page
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
