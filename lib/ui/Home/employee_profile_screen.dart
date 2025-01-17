import 'package:flutter/material.dart';

class EmployeeProfileScreen extends StatefulWidget {
  const EmployeeProfileScreen({super.key});

  @override
  _EmployeeProfileScreenState createState() => _EmployeeProfileScreenState();
}

class _EmployeeProfileScreenState extends State<EmployeeProfileScreen> with TickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _fadeInAnimation;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 800),
    );
    _fadeInAnimation = CurvedAnimation(parent: _animationController, curve: Curves.easeIn);
    _animationController.forward(); // Start animation when screen opens
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    bool isWeb = screenWidth > 600;

    const Color primaryColor = Color(0xFF608BC1);
    const Color accentColor = Color(0xFF133E87);
    const Color textColor = Color(0xFF2D2D2D); // Dark grey for readability

    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [Colors.grey.shade300, Colors.grey.shade100], // Matching gradient background
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: SingleChildScrollView(
          padding: EdgeInsets.symmetric(
            vertical: 20,
            horizontal: isWeb ? screenWidth * 0.15 : 20,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildAnimatedProfileHeader(accentColor, primaryColor),
              const SizedBox(height: 30),
              FadeTransition(
                opacity: _fadeInAnimation,
                child: _buildCreativeCardSection(
                  title: "Basic Information",
                  content: Column(
                    children: [
                      _buildIconRow(Icons.badge, "Employee ID:", "EMP12345", textColor),
                      _buildIconRow(Icons.email, "Email:", "yousef.abdulsalam@example.com", textColor),
                      _buildIconRow(Icons.phone, "Phone Number:", "+123 456 7890", textColor),
                      _buildIconRow(Icons.person, "Supervisor:", "John Doe", textColor),
                      _buildIconRow(Icons.location_on, "Address:", "123 Tech Street, Silicon Valley", textColor),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 20),
              SlideTransition(
                position: Tween<Offset>(begin: const Offset(1, 0), end: Offset.zero).animate(_fadeInAnimation),
                child: _buildCreativeCardSection(
                  title: "Job Details",
                  content: Column(
                    children: [
                      _buildIconRow(Icons.work, "Job Contract:", "Full-Time", textColor),
                      _buildIconRow(Icons.attach_money, "Wage:", "\$2000 per month", textColor),
                      _buildIconRow(Icons.timeline, "Years of Service:", "3 years", textColor),
                      _buildIconRow(Icons.info, "Additional Info:", "Dedicated and skilled team player", textColor),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildAnimatedProfileHeader(Color accentColor, Color primaryColor) {
    return FadeTransition(
      opacity: _fadeInAnimation,
      child: Center(
        child: Column(
          children: [
            Container(
              width: 120,
              height: 120,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                gradient: const LinearGradient(
                  colors: [Color(0xFFCBDCEB), Color(0xFF608BC1)],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                boxShadow: const [
                  BoxShadow(
                    color: Colors.black26,
                    blurRadius: 8,
                    offset: Offset(2, 2),
                  ),
                ],
              ),
              child: const CircleAvatar(
                radius: 60,
                backgroundImage: AssetImage("images/logo.png"),
              ),
            ),
            const SizedBox(height: 10),
            Text(
              "Yousef Abdulsalam",
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: accentColor,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              "Senior Software Engineer",
              style: TextStyle(
                fontSize: 18,
                color: primaryColor,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCreativeCardSection({required String title, required Widget content}) {
    return Card(
      color: Colors.white,
      elevation: 5,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(15),
      ),
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(Icons.star, color: const Color(0xFF133E87)),
                const SizedBox(width: 10),
                Text(
                  title,
                  style: const TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF133E87),
                  ),
                ),
              ],
            ),
            const Divider(thickness: 1, height: 20),
            content,
          ],
        ),
      ),
    );
  }

  Widget _buildIconRow(IconData icon, String label, String value, Color textColor) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10),
      child: Row(
        children: [
          Icon(icon, color: textColor),
          const SizedBox(width: 10),
          Expanded(
            flex: 2,
            child: Text(
              label,
              style: const TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 18,
              ),
            ),
          ),
          Expanded(
            flex: 3,
            child: Text(
              value,
              style: const TextStyle(fontSize: 16),
            ),
          ),
        ],
      ),
    );
  }
}
