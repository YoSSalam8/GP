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
  ];

  final Color primaryColor = const Color(0xFF133E87);
  final Color accentColor = const Color(0xFF608BC1);
  final Color backgroundColor = Colors.white;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: backgroundColor,
      appBar: AppBar(
        title: const Text("Today's Attendance"),
        backgroundColor: primaryColor,
      ),
      body: ListView.builder(
        padding: const EdgeInsets.all(16),
        itemCount: todayAttendance.length,
        itemBuilder: (context, index) {
          final employee = todayAttendance[index];
          return Card(
            margin: const EdgeInsets.only(bottom: 16),
            elevation: 6,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16),
            ),
            child: Container(
              padding: const EdgeInsets.all(16),
              height: 112, // Adjusted card height
              child: Row(
                children: [
                  CircleAvatar(
                    radius: 40, // Larger avatar
                    backgroundColor: accentColor,
                    child: Text(
                      employee['name'][0], // First letter of the name
                      style: const TextStyle(color: Colors.white, fontSize: 24),
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
                            fontSize: 18,
                          ),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          'Check In: ${employee['checkIn']}',
                          style: const TextStyle(
                            color: Colors.black54,
                            fontSize: 16,
                          ),
                        ),
                        Text(
                          'Check Out: ${employee['checkOut']}',
                          style: const TextStyle(
                            color: Colors.black54,
                            fontSize: 16,
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(width: 16),
                  employee['checkOut'] == '--/--'
                      ? const Icon(Icons.thumb_down, color: Colors.redAccent, size: 30)
                      : const Icon(Icons.thumb_up, color: Colors.green, size: 30),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
