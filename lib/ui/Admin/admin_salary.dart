import 'package:flutter/material.dart';

class AdminSalaryCalculationPage extends StatefulWidget {
  const AdminSalaryCalculationPage({super.key});

  @override
  State<AdminSalaryCalculationPage> createState() => _AdminSalaryCalculationPageState();
}

class _AdminSalaryCalculationPageState extends State<AdminSalaryCalculationPage> {
  List<Map<String, dynamic>> employeeAttendance = [
    {'name': 'John Doe', 'daysAttended': 22, 'dailyRate': 100},
    {'name': 'Jane Smith', 'daysAttended': 20, 'dailyRate': 100},
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Salary Calculation'),
        backgroundColor: Colors.purple.shade500,
      ),
      body: ListView.builder(
        padding: const EdgeInsets.all(16),
        itemCount: employeeAttendance.length,
        itemBuilder: (context, index) {
          final employee = employeeAttendance[index];
          int salary = employee['daysAttended'] * employee['dailyRate'];
          return Card(
            margin: const EdgeInsets.only(bottom: 12),
            child: ListTile(
              title: Text(employee['name']),
              subtitle: Text('Days Attended: ${employee['daysAttended']}'),
              trailing: Text('\$${salary.toString()}'),
            ),
          );
        },
      ),
    );
  }
}
