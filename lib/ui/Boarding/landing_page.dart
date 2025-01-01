import 'package:flutter/material.dart';
import 'package:graduation_project/ui/Login/login_page.dart';
import 'package:graduation_project/ui/Signup/signup_page.dart';

class LandingPage extends StatelessWidget {
  LandingPage({super.key});

  final GlobalKey aboutKey = GlobalKey();
  final GlobalKey featuresKey = GlobalKey();
  final GlobalKey footerKey = GlobalKey();

  void scrollToSection(GlobalKey key, BuildContext context) {
    Scrollable.ensureVisible(
      key.currentContext!,
      duration: const Duration(milliseconds: 500),
      curve: Curves.easeInOut,
    );
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    bool isWeb = size.width > 600;

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        title: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const Text(
              "FUSION HR",
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            if (isWeb)
              Row(
                children: [
                  TextButton(
                    onPressed: () => scrollToSection(aboutKey, context),
                    child: const Text(
                      "About",
                      style: TextStyle(color: Colors.black, fontSize: 16),
                    ),
                  ),
                  TextButton(
                    onPressed: () => scrollToSection(featuresKey, context),
                    child: const Text(
                      "Features",
                      style: TextStyle(color: Colors.black, fontSize: 16),
                    ),
                  ),
                ],
              ),
            Row(
              children: [
                ElevatedButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => const Login()),
                    );
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20),
                    ),
                  ),
                  child: const Text(
                    "Login",
                    style: TextStyle(color: Color(0xFF133E87)),
                  ),
                ),
                const SizedBox(width: 10),
                ElevatedButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => const SignupPage()),
                    );
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20),
                    ),
                  ),
                  child: const Text(
                    "Sign Up",
                    style: TextStyle(color: Color(0xFF133E87)),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header Section
            Container(
              height: size.height,
              width: size.width,
              decoration: const BoxDecoration(
                gradient: LinearGradient(
                  colors: [Color(0xFF133E87), Color(0xFF608BC1)],
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                ),
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Image.asset(
                    'images/logo_fusion.png',
                    height: 120,
                  ),
                  const SizedBox(height: 20),
                  const Text(
                    'Welcome to Our HR Management System',
                    style: TextStyle(
                      fontSize: 32,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 15),
                  const Padding(
                    padding: EdgeInsets.symmetric(horizontal: 40),
                    child: Text(
                      'Effortlessly manage your HR needs with core tools and add-on features.',
                      style: TextStyle(
                        fontSize: 18,
                        color: Colors.white70,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ),
                ],
              ),
            ),

            // About Section
            Container(
              key: aboutKey,
              height: size.height,
              width: size.width,
              decoration: const BoxDecoration(
                image: DecorationImage(
                  image: AssetImage('images/about_background.png'),
                  fit: BoxFit.cover,
                  opacity: 0.9,
                ),
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text(
                    'About the Project',
                    style: TextStyle(
                      fontSize: 30,
                      fontWeight: FontWeight.bold,
                      color: Colors.black,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 20),
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: size.width * 0.1),
                    child: const Text(
                      'Fusion HR is designed for companies of all sizes to streamline their HR processes. '
                          'It integrates advanced technology with user-centric design to simplify time tracking, '
                          'payroll management, and compliance monitoring. Our platform is robust yet easy to use, '
                          'ensuring businesses can focus on growth while we handle their HR needs.',
                      style: TextStyle(fontSize: 18, color: Colors.black),
                      textAlign: TextAlign.center,
                    ),
                  ),
                  const SizedBox(height: 15),
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: size.width * 0.1),
                    child: const Text(
                      'With Fusion HR, you get a suite of tools that are adaptable, reliable, and innovative. '
                          'Whether you are managing a team of 10 or 10,000, our solutions scale with your needs. '
                          'From employee onboarding to advanced analytics, Fusion HR covers all aspects of human '
                          'resource management.',
                      style: TextStyle(fontSize: 18, color: Colors.black),
                      textAlign: TextAlign.center,
                    ),
                  ),
                ],
              ),
            ),

            // Features Section
            Container(
              key: featuresKey,
              height: size.height,
              width: size.width,
              decoration: const BoxDecoration(
                gradient: RadialGradient(
                  colors: [Color(0xFFF7F9FC), Color(0xFFCBDCEB)],
                  center: Alignment.center,
                  radius: 1.2,
                ),
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text(
                    'Key Features',
                    style: TextStyle(
                      fontSize: 30,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF133E87),
                    ),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 20),
                  FeatureCard(
                    title: 'Attendance and Leave Management',
                    description:
                    'Track employee attendance and manage leave requests efficiently with a user-friendly dashboard.',
                    icon: Icons.access_time,
                  ),
                  FeatureCard(
                    title: 'Role-Based Access Control',
                    description:
                    'Enhance security with customizable access permissions for employees and administrators.',
                    icon: Icons.lock,
                  ),
                  FeatureCard(
                    title: 'Payroll Management',
                    description:
                    'Streamline payroll processing with automated tax deductions and benefit tracking.',
                    icon: Icons.money,
                  ),
                  FeatureCard(
                    title: 'Performance Analytics',
                    description:
                    'Gain insights into employee performance with real-time data and actionable analytics.',
                    icon: Icons.analytics,
                  ),
                  FeatureCard(
                    title: 'Employee Self-Service',
                    description:
                    'Empower employees to manage their own profiles, view payslips, and request leaves.',
                    icon: Icons.person,
                  ),
                ],
              ),
            ),

            // Footer Section
            Container(
              key: footerKey,
              height: 100,
              width: size.width,
              color: const Color(0xFF133E87),
              child: const Center(
                child: Text(
                  '© 2025 HR Management System. All Rights Reserved.',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 14,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class FeatureCard extends StatefulWidget {
  final String title;
  final String description;
  final IconData icon;

  const FeatureCard({
    super.key,
    required this.title,
    required this.description,
    required this.icon,
  });

  @override
  State<FeatureCard> createState() => _FeatureCardState();
}

class _FeatureCardState extends State<FeatureCard> {
  bool isHovered = false;

  @override
  Widget build(BuildContext context) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 300),
      padding: const EdgeInsets.all(20),
      margin: const EdgeInsets.symmetric(vertical: 10, horizontal: 20),
      decoration: BoxDecoration(
        color: isHovered ? Colors.blue.shade50 : Colors.white,
        borderRadius: BorderRadius.circular(15),
        boxShadow: [
          BoxShadow(
            color: isHovered ? Colors.blue.shade200 : Colors.grey.shade200,
            blurRadius: 10,
            spreadRadius: 2,
          ),
        ],
      ),
      child: InkWell(
        onHover: (hovering) {
          setState(() {
            isHovered = hovering;
          });
        },
        child: Row(
          children: [
            Icon(widget.icon, size: 40, color: const Color(0xFF133E87)),
            const SizedBox(width: 20),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    widget.title,
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF133E87),
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    widget.description,
                    style: const TextStyle(fontSize: 16),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
