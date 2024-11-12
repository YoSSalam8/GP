import 'package:flutter/material.dart';

class EmployeeProfileScreen extends StatelessWidget {
  const EmployeeProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;

    return Scaffold(
      appBar: AppBar(
        title: const Text("Employee Profile"),
        backgroundColor: Colors.purple.shade500,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const CircleAvatar(
              radius: 50,
              backgroundImage: AssetImage("images/logo.png"),
            ),
            SizedBox(height: screenWidth * 0.1),
            Text(
              "Name: John Doe",
              style: TextStyle(
                fontSize: screenWidth / 18,
                color: Colors.purple.shade700,
              ),
            ),
            const SizedBox(height: 10),
            Text(
              "Age: 30",
              style: TextStyle(
                fontSize: screenWidth / 20,
                color: Colors.black87,
              ),
            ),
            const SizedBox(height: 10),
            Text(
              "Job Contract: Full-Time",
              style: TextStyle(
                fontSize: screenWidth / 20,
                color: Colors.black87,
              ),
            ),
            const SizedBox(height: 10),
            Text(
              "Wage: \$2000 per month",
              style: TextStyle(
                fontSize: screenWidth / 20,
                color: Colors.black87,
              ),
            ),
            const SizedBox(height: 20),
            Text(
              "Additional Details",
              style: TextStyle(
                fontSize: screenWidth / 18,
                color: Colors.purple.shade700,
              ),
            ),
            const SizedBox(height: 10),
            Text(
              "This employee has been working with us for 3 years and has demonstrated exceptional commitment and skill.",
              style: TextStyle(
                fontSize: screenWidth / 22,
                color: Colors.black54,
              ),
            ),
            const SizedBox(height: 20),
            Text(
              "Job Contract",
              style: TextStyle(
                fontSize: screenWidth / 18,
                color: Colors.purple.shade700,
              ),
            ),
            const SizedBox(height: 10),
            Center(
              child: Image.asset(
                'images/logo.png',
                fit: BoxFit.cover,
                width: screenWidth * 0.8,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
