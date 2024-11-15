import 'package:flutter/material.dart';

class AdminSalaryCalculationPage extends StatefulWidget {
  const AdminSalaryCalculationPage({super.key});

  @override
  State<AdminSalaryCalculationPage> createState() =>
      _AdminSalaryCalculationPageState();
}

class _AdminSalaryCalculationPageState
    extends State<AdminSalaryCalculationPage> {
  final List<Map<String, dynamic>> employeeAttendance = [
    {'name': 'Yousef AbdulSalam', 'daysAttended': 22, 'dailyRate': 100},
    {'name': 'Mohammad Aker', 'daysAttended': 20, 'dailyRate': 100},
  ];

  final Color primaryColor = const Color(0xFF133E87);
  final Color accentColor = const Color(0xFF608BC1);
  final Color cardBackgroundColor = const Color(0xFFF5F5F5);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text('Salary Calculation'),
        backgroundColor: primaryColor,
      ),
      body: ListView.builder(
        padding: const EdgeInsets.all(16),
        itemCount: employeeAttendance.length,
        itemBuilder: (context, index) {
          final employee = employeeAttendance[index];
          int salary = employee['daysAttended'] * employee['dailyRate'];

          return Card(
            color: cardBackgroundColor,
            margin: const EdgeInsets.only(bottom: 12),
            elevation: 4,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Row(
                children: [
                  CircleAvatar(
                    radius: 35, // Avatar size
                    backgroundColor: accentColor,
                    child: Text(
                      employee['name'][0], // First letter of name
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 22,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          employee['name'],
                          style: TextStyle(
                            color: primaryColor,
                            fontWeight: FontWeight.bold,
                            fontSize: 20,
                          ),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          'Days Attended: ${employee['daysAttended']}',
                          style: const TextStyle(
                            color: Colors.black87,
                            fontSize: 16,
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(width: 16),
                  Text(
                    '\$${salary.toString()}',
                    style: TextStyle(
                      color: primaryColor,
                      fontWeight: FontWeight.bold,
                      fontSize: 20,
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
