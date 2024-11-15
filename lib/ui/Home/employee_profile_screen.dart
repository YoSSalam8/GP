import 'package:flutter/material.dart';

class EmployeeProfileScreen extends StatelessWidget {
  const EmployeeProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;

    // Color palette for consistency
    const Color primaryColor = Color(0xFF608BC1);
    const Color accentColor = Color(0xFF133E87);

    return Scaffold(
      appBar: AppBar(
        title: const Text("Employee Profile"),
        backgroundColor: primaryColor,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Center(
              child: CircleAvatar(
                radius: 50,
                backgroundImage: AssetImage("images/logo.png"),
              ),
            ),
            SizedBox(height: screenWidth * 0.1),
            _buildProfileRow("Name:", "Yousef Abdulsalam", screenWidth, accentColor),
            const SizedBox(height: 10),
            _buildProfileRow("Age:", "30", screenWidth, accentColor),
            const SizedBox(height: 10),
            _buildProfileRow("Job Contract:", "Full-Time", screenWidth, accentColor),
            const SizedBox(height: 10),
            _buildProfileRow("Wage:", "\$2000 per month", screenWidth, accentColor),
            const SizedBox(height: 20),
            Text(
              "Additional Details",
              style: TextStyle(
                fontSize: screenWidth / 18,
                color: accentColor,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 10),
            Text(
              "This employee has been working with us for 3 years and has demonstrated exceptional commitment and skill.",
              style: TextStyle(
                fontSize: screenWidth / 22,
                color: Colors.black87,
              ),
            ),
            const SizedBox(height: 20),
            Text(
              "Job Contract",
              style: TextStyle(
                fontSize: screenWidth / 18,
                color: accentColor,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 10),
            Center(
              child: Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(20),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black26,
                      blurRadius: 10,
                      offset: const Offset(2, 2),
                    ),
                  ],
                ),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(20),
                  child: Image.asset(
                    'images/logo.png',
                    fit: BoxFit.cover,
                    width: screenWidth * 0.8,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
      backgroundColor: Colors.white, // Set the background color to white
    );
  }

  Widget _buildProfileRow(
      String label, String value, double screenWidth, Color textColor) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(
          flex: 2,
          child: Text(
            label,
            style: TextStyle(
              fontSize: screenWidth / 20,
              fontWeight: FontWeight.bold,
              color: textColor,
            ),
          ),
        ),
        Expanded(
          flex: 3,
          child: Text(
            value,
            style: TextStyle(
              fontSize: screenWidth / 20,
              color: textColor,
            ),
          ),
        ),
      ],
    );
  }
}
