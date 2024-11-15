import 'package:flutter/material.dart';
import 'admin_today.dart';
import 'admin_monthly.dart';
import 'admin_salary.dart';
import 'admin_absence_vacation.dart';
import 'admin_job_interviews.dart';

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
  ];

  int currentIndex = 0;

  // Define the color palette
  final Color primaryColor = const Color(0xFF133E87);
  final Color activeColor = const Color(0xFF608BC1);
  final Color indicatorColor = const Color(0xFFCBDCEB);

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
                        currentIndex = i;
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
                            if (i == currentIndex)
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
