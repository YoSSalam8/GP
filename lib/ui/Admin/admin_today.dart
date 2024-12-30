import 'package:flutter/material.dart';

class AdminTodayAttendancePage extends StatefulWidget {
  const AdminTodayAttendancePage({super.key});

  @override
  State<AdminTodayAttendancePage> createState() =>
      _AdminTodayAttendancePageState();
}

class _AdminTodayAttendancePageState extends State<AdminTodayAttendancePage> {
  final List<Map<String, dynamic>> todayAttendance = [
    {'name': 'Yousef AbdulSalam', 'checkIn': '09:00 AM', 'checkOut': '05:00 PM'},
    {'name': 'Mohammad Aker', 'checkIn': '09:30 AM', 'checkOut': '--/--'},
    {'name': 'Sara Smith', 'checkIn': '--/--', 'checkOut': '--/--'}, // Absent
    {'name': 'Khaled Yaish', 'checkIn': '10:00 AM', 'checkOut': '06:00 PM'}, // Active
    {'name': 'Nour Tamer', 'checkIn': '08:45 AM', 'checkOut': '04:30 PM'}, // Active
    {'name': 'Lina Ali', 'checkIn': '09:10 AM', 'checkOut': '--/--'}, // Active
    {'name': 'Ahmad Fadel', 'checkIn': '--/--', 'checkOut': '--/--'}, // Absent
    {'name': 'Maya Hassan', 'checkIn': '09:00 AM', 'checkOut': '05:15 PM'}, // Active
  ];

  final Color primaryColor = const Color(0xFF133E87);
  final Color accentColor = const Color(0xFF608BC1);
  final Color backgroundColor = Colors.white;

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    bool isWeb = screenWidth > 600; // Check if it's a web environment

    return Scaffold(
      backgroundColor: backgroundColor,

      body: SafeArea(
        child: SingleChildScrollView(
          child: Center(
            child: ConstrainedBox(
              constraints: BoxConstraints(
                maxWidth: isWeb ? 800 : double.infinity, // Constrain width on web
              ),
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                child: Column(
                  children: [
                    ListView.builder(
                      shrinkWrap: true, // Makes ListView take only necessary space
                      physics: const NeverScrollableScrollPhysics(),
                      itemCount: todayAttendance.length,
                      itemBuilder: (context, index) {
                        final employee = todayAttendance[index];

                        // Determine the icon color based on check-in and check-out status
                        Color iconColor;
                        IconData icon;
                        if (employee['checkIn'] == '--/--' &&
                            employee['checkOut'] == '--/--') {
                          // Employee is absent
                          iconColor = Colors.yellow;
                          icon = Icons.help_outline; // Question mark for absent
                        } else if (employee['checkOut'] == '--/--') {
                          // Employee checked in but not checked out (Active)
                          iconColor = Colors.green;
                          icon = Icons.check_circle; // Checkmark for active
                        } else {
                          // Employee checked in and checked out
                          iconColor = Colors.red;
                          icon = Icons.remove_circle_outline; // Cross for inactive
                        }

                        return Card(
                          margin: const EdgeInsets.only(bottom: 8), // Adjust spacing
                          elevation: isWeb ? 8 : 4, // Higher elevation for web
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(16),
                          ),
                          child: Container(
                            padding: const EdgeInsets.all(16),
                            height: isWeb ? 130 : 112, // Adjusted card height for web
                            child: Row(
                              children: [
                                CircleAvatar(
                                  radius: isWeb ? 45 : 40, // Larger avatar for web
                                  backgroundColor: accentColor,
                                  child: Text(
                                    employee['name'][0], // First letter of the name
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontSize: isWeb ? 28 : 24, // Larger font for web
                                    ),
                                  ),
                                ),
                                const SizedBox(width: 16),
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Text(
                                        employee['name'],
                                        style: TextStyle(
                                          color: primaryColor,
                                          fontWeight: FontWeight.bold,
                                          fontSize:
                                          isWeb ? 20 : 18, // Larger font for web
                                        ),
                                      ),
                                      const SizedBox(height: 8),
                                      Text(
                                        'Check In: ${employee['checkIn']}',
                                        style: TextStyle(
                                          color: Colors.black54,
                                          fontSize:
                                          isWeb ? 18 : 16, // Larger font for web
                                        ),
                                      ),
                                      Text(
                                        'Check Out: ${employee['checkOut']}',
                                        style: TextStyle(
                                          color: Colors.black54,
                                          fontSize:
                                          isWeb ? 18 : 16, // Larger font for web
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                const SizedBox(width: 16),
                                // Display circle icon based on status
                                CircleAvatar(
                                  radius: isWeb ? 25 : 20, // Circle size for web
                                  backgroundColor: iconColor, // Set color based on status
                                  child: Icon(
                                    icon, // Icon based on status
                                    color: Colors.white,
                                    size: isWeb ? 28 : 24, // Icon size for web
                                  ),
                                ),
                              ],
                            ),
                          ),
                        );
                      },
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
