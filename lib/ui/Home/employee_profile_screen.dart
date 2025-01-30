import 'dart:convert';
import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class EmployeeProfileScreen extends StatefulWidget {
  final String employeeId;
  final String email;
  final String token;
  final String companyId;

  const EmployeeProfileScreen({
    super.key,
    required this.employeeId,
    required this.email,
    required this.token, required this.companyId,
  });

  @override
  _EmployeeProfileScreenState createState() => _EmployeeProfileScreenState();
}

class _EmployeeProfileScreenState extends State<EmployeeProfileScreen> with TickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _fadeInAnimation;

  // Variables to store fetched data
  String name = '';
  String email = '';
  String phoneNumber = '';
  String address = '';
  String skills = '';
  String type = '';
  String departmentName = '';
  String workTitleName = '';
  String companyName = '';
  bool overtimeAllowed = false;
  String workScheduleType = '';
  Uint8List? profilePicture; // Add variable for profile picture
  List<String> supervisedEmployees = []; // Stores supervised employees' emails

  bool isLoading = true; // Track loading state

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 800),
    );
    _fadeInAnimation = CurvedAnimation(parent: _animationController, curve: Curves.easeIn);
    _animationController.forward(); // Start animation when screen opens

    // Fetch employee data
    _fetchEmployeeData();
    fetchProfilePicture(); // Fetch profile picture
    _fetchSupervisedEmployees();
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  Future<void> _fetchEmployeeData() async {
    final url = 'http://192.168.68.107:8080/api/employees/${widget.employeeId}/${widget.email}';
    try {
      final response = await http.get(
        Uri.parse(url),
        headers: {
          'Authorization': 'Bearer ${widget.token}',
          'Content-Type': 'application/json',
        },
      );
      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        setState(() {
          name = data['name'] ?? '';
          email = data['email'] ?? '';
          phoneNumber = data['phoneNumber'] ?? 'N/A';
          address = data['address'] ?? 'N/A';
          skills = data['skills'] ?? 'N/A';
          type = data['type'] ?? 'N/A';
          departmentName = data['departmentName'] ?? 'N/A';
          workTitleName = data['workTitleName'] ?? 'N/A';
          companyName = data['companyName'] ?? 'N/A';
          overtimeAllowed = data['overtimeAllowed'] ?? false;
          workScheduleType = data['workScheduleType'] ?? 'N/A';
          isLoading = false; // Set loading to false after fetching data
        });
      } else {
        throw Exception('Failed to fetch employee data: ${response.body}');
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error: $e')),
      );
    }
  }

  Future<void> _fetchSupervisedEmployees() async {
    final url = 'http://localhost:8080/api/employees/company/${widget.companyId}/employees';
    try {
      final response = await http.get(
        Uri.parse(url),
        headers: {
          'Authorization': 'Bearer ${widget.token}',
          'Content-Type': 'application/json',
        },
      );

      if (response.statusCode == 200) {
        List<dynamic> employees = jsonDecode(response.body);
        List<String> supervisedEmails = [];

        for (var employee in employees) {
          String employeeId = employee['id'].toString();
          String employeeEmail = employee['email'];

          final detailsResponse = await http.get(
            Uri.parse('http://localhost:8080/api/employees/$employeeId/$employeeEmail'),
            headers: {
              'Authorization': 'Bearer ${widget.token}',
              'Content-Type': 'application/json',
            },
          );

          if (detailsResponse.statusCode == 200) {
            final employeeDetails = jsonDecode(detailsResponse.body);
            if (employeeDetails['supervisorId'] != null &&
                employeeDetails['supervisorId'].toString() == widget.employeeId) {
              supervisedEmails.add(employeeDetails['email']);
            }
          }
        }

        setState(() {
          supervisedEmployees = supervisedEmails;
        });
      }
    } catch (e) {
      print("Error fetching supervised employees: $e");
    }
  }

  Future<void> fetchProfilePicture() async {
    final url = 'http://192.168.68.107:8080/api/employees/${widget.employeeId}/${widget.email}/picture';
    try {
      final response = await http.get(Uri.parse(url));
      if (response.statusCode == 200) {
        setState(() {
          profilePicture = response.bodyBytes; // Set profile picture bytes
        });
      } else {
        print("Failed to fetch profile picture: ${response.body}");
      }
    } catch (e) {
      print("Error fetching profile picture: $e");
    }
  }
  Future<void> _refreshData() async {
    setState(() {
      isLoading = true; // Show loading indicator while refreshing
    });
    await _fetchEmployeeData();
    await fetchProfilePicture();
    setState(() {
      isLoading = false; // Hide loading indicator after refreshing
    });
  }
  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    bool isWeb = screenWidth > 600;

    const Color primaryColor = Color(0xFF608BC1);
    const Color accentColor = Color(0xFF133E87);
    const Color textColor = Color(0xFF2D2D2D); // Dark grey for readability

    return Scaffold(
      appBar: AppBar(
        title: const Text(""),
        backgroundColor: primaryColor,
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: _refreshData, // Call refresh method
          ),
        ],
      ),
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : Container(
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
                      _buildIconRow(Icons.badge, "Name:", name, textColor),
                      _buildIconRow(Icons.email, "Email:", email, textColor),
                      _buildIconRow(Icons.phone, "Phone Number:", phoneNumber, textColor),
                      _buildIconRow(Icons.location_on, "Address:", address, textColor),
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
                      _buildIconRow(Icons.work, "Job Type:", type, textColor),
                      _buildIconRow(Icons.business, "Company Name:", companyName, textColor),
                      _buildIconRow(Icons.group_work, "Department Name:", departmentName, textColor),
                      _buildIconRow(Icons.title, "Work Title Name:", workTitleName, textColor),
                      _buildIconRow(Icons.calendar_today, "Work Schedule Type:", workScheduleType, textColor),
                      _buildIconRow(Icons.access_time, "Overtime Allowed:", overtimeAllowed ? "Yes" : "No", textColor),
                      _buildIconRow(Icons.info, "Skills:", skills, textColor),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 20),
              _buildCreativeCardSection(title: "Supervised Employees", content: Column(
                children: supervisedEmployees.isNotEmpty
                    ? supervisedEmployees.map((email) => _buildIconRow(Icons.supervisor_account, "Email:", email, Colors.black)).toList()
                    : [const Center(child: Text("No supervised employees."))],
              )),
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
              child: profilePicture != null
                  ? ClipOval(
                child: Image.memory(
                  profilePicture!,
                  fit: BoxFit.cover,
                  width: 120,
                  height: 120,
                ),
              )
                  : const CircleAvatar(
                radius: 60,

              ),
            ),
            const SizedBox(height: 10),
            Text(
              name,
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: accentColor,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              workTitleName,
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
