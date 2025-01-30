import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter_animate/flutter_animate.dart';

class AdminSalaryCalculationPage extends StatefulWidget {
  final String companyId;
  final String employeeId;
  final String employeeEmail;
  final String token;

  const AdminSalaryCalculationPage({
    super.key,
    required this.companyId,
    required this.employeeId,
    required this.employeeEmail,
    required this.token,
  });

  @override
  State<AdminSalaryCalculationPage> createState() =>
      _AdminSalaryCalculationPageState();
}

class _AdminSalaryCalculationPageState
    extends State<AdminSalaryCalculationPage> with TickerProviderStateMixin {
  final List<Map<String, dynamic>> employeeAttendance = [
    {'name': 'Yousef AbdulSalam', 'dailyRate': 100, 'daysAttended': 22},
    {'name': 'Mohammad Aker', 'dailyRate': 100, 'daysAttended': 20},
  ];

  final Color primaryColor = const Color(0xFF133E87);
  final Color accentColor = const Color(0xFF608BC1);
  final Color cardBackgroundColor = Colors.white;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[200], // Light grey background

      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: SizedBox(
            width: 1000, // ⬅️ Adjusted width for better balance
            child: ListView.builder(
              itemCount: employeeAttendance.length,
              itemBuilder: (context, index) {
                final employee = employeeAttendance[index];
                int salary = employee['daysAttended'] * employee['dailyRate'];

                return _buildEmployeeCard(
                  employee['name'],
                  salary,
                ).animate().fade(duration: 500.ms).scale(duration: 300.ms);
              },
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildEmployeeCard(String name, int salary) {
    return TweenAnimationBuilder<double>(
      duration: const Duration(milliseconds: 500),
      tween: Tween(begin: 0, end: 1),
      builder: (context, value, child) {
        return Transform.scale(
          scale: value,
          child: Card(
            color: cardBackgroundColor,
            margin: const EdgeInsets.only(bottom: 16),
            elevation: 6,
            shadowColor: Colors.grey.withOpacity(0.4),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16),
            ),
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 20),
              child: Row(
                children: [
                  CircleAvatar(
                    radius: 35,
                    backgroundColor: accentColor,
                    child: Text(
                      name[0], // First letter of name
                      style: GoogleFonts.poppins(
                        color: Colors.white,
                        fontSize: 22,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  const SizedBox(width: 18),
                  Expanded(
                    child: Text(
                      name,
                      style: GoogleFonts.poppins(
                        color: primaryColor,
                        fontWeight: FontWeight.bold,
                        fontSize: 18,
                      ),
                    ),
                  ),
                  _buildAnimatedSalary(salary),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildAnimatedSalary(int salary) {
    return TweenAnimationBuilder<int>(
      duration: const Duration(milliseconds: 700),
      tween: IntTween(begin: 0, end: salary),
      builder: (context, value, child) {
        return Column(
          children: [
            const Icon(Icons.attach_money, color: Colors.green, size: 24),
            const SizedBox(height: 4),
            Text(
              '\$$value',
              style: GoogleFonts.poppins(
                color: Colors.green.shade700,
                fontWeight: FontWeight.bold,
                fontSize: 18,
              ),
            ),
          ],
        );
      },
    );
  }
}
