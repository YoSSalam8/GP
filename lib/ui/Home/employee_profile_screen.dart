import 'package:flutter/material.dart';

class EmployeeProfileScreen extends StatelessWidget {
  const EmployeeProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;

    // Determine if the device is web
    bool isWeb = screenWidth > 600;

    // Color palette for consistency
    const Color primaryColor = Color(0xFF608BC1);
    const Color accentColor = Color(0xFF133E87);

    return Scaffold(
      body: SingleChildScrollView(
        padding: EdgeInsets.symmetric(
          vertical: 20,
          horizontal: isWeb ? screenWidth * 0.2 : 20, // Add margins for web
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Center(
              child: CircleAvatar(
                radius: 60,
                backgroundImage: AssetImage("images/logo.png"), // Profile image
              ),
            ),
            SizedBox(height: screenWidth * 0.05),
            _buildProfileRow("Name:", "Yousef Abdulsalam", screenWidth, accentColor),
            const SizedBox(height: 10),
            _buildProfileRow("Age:", "30", screenWidth, accentColor),
            const SizedBox(height: 10),
            _buildProfileRow("Job Contract:", "Full-Time", screenWidth, accentColor),
            const SizedBox(height: 10),
            _buildProfileRow("Wage:", "\$2000 per month", screenWidth, accentColor),
            const SizedBox(height: 20),
            _buildSectionTitle("Additional Details", screenWidth, accentColor),
            const SizedBox(height: 10),
            Text(
              "This employee has been working with us for 3 years and has demonstrated exceptional commitment and skill.",
              style: TextStyle(
                fontSize: isWeb ? 18 : screenWidth / 22,
                color: Colors.black87,
              ),
            ),
            const SizedBox(height: 20),
            _buildSectionTitle("Job Contract", screenWidth, accentColor),
            const SizedBox(height: 10),
            Center(
              child: Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(20),
                  boxShadow: const [
                    BoxShadow(
                      color: Colors.black26,
                      blurRadius: 10,
                      offset: Offset(2, 2),
                    ),
                  ],
                ),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(20),
                  child: Image.asset(
                    'images/logo.png', // Job contract image
                    fit: BoxFit.cover,
                    width: isWeb ? screenWidth * 0.6 : screenWidth * 0.8, // Adjust for web
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
      backgroundColor: Colors.white,
    );
  }

  Widget _buildProfileRow(String label, String value, double screenWidth, Color textColor) {
    bool isWeb = screenWidth > 600;

    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(
          flex: 2,
          child: Text(
            label,
            style: TextStyle(
              fontSize: isWeb ? 18 : screenWidth / 20, // Adjust font size for web
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
              fontSize: isWeb ? 18 : screenWidth / 20, // Adjust font size for web
              color: textColor,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildSectionTitle(String title, double screenWidth, Color textColor) {
    bool isWeb = screenWidth > 600;

    return Text(
      title,
      style: TextStyle(
        fontSize: isWeb ? 22 : screenWidth / 18, // Adjust font size for web
        fontWeight: FontWeight.bold,
        color: textColor,
      ),
    );
  }
}
