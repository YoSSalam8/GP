import 'package:flutter/material.dart';

class AdminTodayAttendancePage extends StatefulWidget {
  const AdminTodayAttendancePage({super.key});

  @override
  State<AdminTodayAttendancePage> createState() => _AdminTodayAttendancePageState();
}

class _AdminTodayAttendancePageState extends State<AdminTodayAttendancePage> {
  List<Map<String, dynamic>> todayAttendance = [
    {'name': 'John Doe', 'checkIn': '09:00 AM', 'checkOut': '05:00 PM'},
    {'name': 'Jane Smith', 'checkIn': '09:30 AM', 'checkOut': '--/--'},
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Today\'s Attendance'),
        backgroundColor: Colors.purple.shade500,
      ),
      body: ListView.builder(
        padding: const EdgeInsets.all(16),
        itemCount: todayAttendance.length,
        itemBuilder: (context, index) {
          final employee = todayAttendance[index];
          return Card(
            margin: const EdgeInsets.only(bottom: 12),
            child: ListTile(
              title: Text(employee['name']),
              subtitle: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text('Check In: ${employee['checkIn']}'),
                  Text('Check Out: ${employee['checkOut']}'),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
