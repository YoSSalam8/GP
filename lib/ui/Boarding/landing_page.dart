import 'package:flutter/material.dart';
import 'package:graduation_project/ui/Login/login_page.dart';
import 'package:graduation_project/ui/Signup/signup_page.dart';


class LandingPage extends StatefulWidget {
  const LandingPage({super.key});

  @override
  _LandingPageState createState() => _LandingPageState();
}

class _LandingPageState extends State<LandingPage> with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<Offset> _slideAnimation;
  late Animation<double> _fadeAnimation;

  final GlobalKey aboutKey = GlobalKey();
  final GlobalKey featuresKey = GlobalKey();
  final GlobalKey footerKey = GlobalKey();

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 2),
    )..forward();

    _slideAnimation = Tween<Offset>(
      begin: const Offset(0, 0.3),
      end: Offset.zero,
    ).animate(CurvedAnimation(parent: _controller, curve: Curves.easeInOut));

    _fadeAnimation = Tween<double>(begin: 0, end: 1).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeIn),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
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
            SlideTransition(
              position: _slideAnimation,
              child: const Text(
                "FUSION HR",
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: Colors.black),
              ),
            ),
            if (isWeb)
              Expanded(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center, // Centering the buttons
                  children: [
                    TextButton(
                      onPressed: () => scrollToSection(aboutKey, context),
                      child: const Text("About", style: TextStyle(color: Colors.black)),
                    ),
                    const SizedBox(width: 10), // Space between the buttons
                    TextButton(
                      onPressed: () => scrollToSection(featuresKey, context),
                      child: const Text("Features", style: TextStyle(color: Colors.black)),
                    ),
                  ],
                ),
              ),
            Row(
              children: [
                _buildAnimatedButton(
                  "Login",
                      () {
                    Navigator.push(context, MaterialPageRoute(builder: (context) => const Login()));
                  },
                ),
                const SizedBox(width: 10),
                _buildAnimatedButton(
                  "Sign Up",
                      () {
                    Navigator.push(context, MaterialPageRoute(builder: (context) => const SignupPage()));
                  },
                ),
              ],
            ),
          ],
        ),
        centerTitle: false, // Ensures the title aligns left
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildHeaderSection(size),
            _buildAboutSection(size),
            _buildFeaturesSection(size),
            _buildFooterSection(size),
          ],
        ),
      ),
    );
  }

  Widget _buildAnimatedButton(String label, VoidCallback onPressed) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 400),
      child: ElevatedButton(
        onPressed: onPressed,
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.white,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
        ),
        child: Text(label, style: const TextStyle(color: Color(0xFF133E87))),
      ),
    );
  }

  Widget _buildHeaderSection(Size size) {
    return AnimatedBuilder(
      animation: _controller,
      builder: (context, child) {
        return FadeTransition(
          opacity: _fadeAnimation,
          child: Container(
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
                Image.asset('images/logo_Fusion.png', height: 120),
                const SizedBox(height: 20),
                const AnimatedText(),
                const SizedBox(height: 15),
                const Padding(
                  padding: EdgeInsets.symmetric(horizontal: 40),
                  child: Text(
                    'Effortlessly manage your HR needs with core tools and add-on features.',
                    style: TextStyle(fontSize: 18, color: Colors.white70),
                    textAlign: TextAlign.center,
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildAboutSection(Size size) {
    return Container(
      key: aboutKey,
      height: size.height,
      width: size.width,
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          colors: [Color(0xFFE1D7B7), Color(0xFF608BC1)], // Gradient background
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.all(Radius.circular(20)), // Rounded corners
        boxShadow: [
          BoxShadow(
            color: Colors.black26,
            blurRadius: 8,
            offset: Offset(0, 4), // Subtle shadow for elevation effect
          ),
        ],
      ),
      child: Center(
        child: FadeTransition(
          opacity: _fadeAnimation,
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: size.width * 0.1),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Text(
                  'About Fusion HR',
                  style: TextStyle(
                    fontSize: 28,
                    fontWeight: FontWeight.bold,
                    color: Colors.black,
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 20), // Space between the heading and body text
                const Text(
                  'Fusion HR is designed for companies of all sizes to streamline their HR processes. '
                      'It integrates advanced technology with user-centric design to simplify time tracking, '
                      'payroll management, and compliance monitoring. Our platform is robust yet easy to use, '
                      'ensuring businesses can focus on growth while we handle their HR needs.\n\n'
                      'With Fusion HR, you get a suite of tools that are adaptable, reliable, and innovative. '
                      'Whether you are managing a team of 10 or 10,000, our solutions scale with your needs. '
                      'From employee onboarding to advanced analytics, Fusion HR covers all aspects of human '
                      'resource management.',
                  style: TextStyle(fontSize: 18, color: Colors.black),
                  textAlign: TextAlign.center,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }


  Widget _buildFeaturesSection(Size size) {
    return Container(
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
        children: const [
          Text(
            'Key Features',
            style: TextStyle(fontSize: 30, fontWeight: FontWeight.bold, color: Color(0xFF133E87)),
            textAlign: TextAlign.center,
          ),
          SizedBox(height: 20),
          FeatureCard(
            title: 'Attendance and Leave Management',
            description: 'Track employee attendance and manage leave requests efficiently.',
            icon: Icons.access_time,
          ),
          FeatureCard(
            title: 'Role-Based Access Control',
            description: 'Enhance security with customizable access permissions.',
            icon: Icons.lock,
          ),

          FeatureCard(
            title: 'Performance Analytics',
            description: 'Gain insights into employee performance with real-time data.',
            icon: Icons.analytics,
          ),
          FeatureCard(
            title: 'Employee Self-Service',
            description: 'Empower employees to manage their own profiles and requests.',
            icon: Icons.person,
          ),
        ],
      ),
    );
  }

  Widget _buildFooterSection(Size size) {
    return Container(
      key: footerKey,
      height: 100,
      width: size.width,
      color: const Color(0xFF133E87),
      child: const Center(
        child: Text(
          '© 2025 HR Management System. All Rights Reserved.',
          style: TextStyle(color: Colors.white, fontSize: 14),
        ),
      ),
    );
  }

  void scrollToSection(GlobalKey key, BuildContext context) {
    Scrollable.ensureVisible(
      key.currentContext!,
      duration: const Duration(milliseconds: 500),
      curve: Curves.easeInOut,
    );
  }
}

class AnimatedText extends StatelessWidget {
  const AnimatedText({super.key});

  @override
  Widget build(BuildContext context) {
    return TweenAnimationBuilder<double>(
      duration: const Duration(seconds: 2),
      tween: Tween<double>(begin: 0, end: 1),
      builder: (context, value, child) {
        return Opacity(
          opacity: value,
          child: Text(
            'Welcome to Our HR Management System',
            style: TextStyle(fontSize: 32 * value, fontWeight: FontWeight.bold, color: Colors.white),
            textAlign: TextAlign.center,
          ),
        );
      },
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
