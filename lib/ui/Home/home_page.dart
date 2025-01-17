  import 'package:flutter/material.dart';
  import 'package:graduation_project/ui/Home/calendar_screen.dart';
  import 'package:graduation_project/ui/Home/profile_screen.dart';
  import 'package:graduation_project/ui/Home/today_screen.dart';
  import 'package:graduation_project/ui/Home/employee_profile_screen.dart';
  import 'package:graduation_project/ui/Home/vacation_request_screen.dart';
  import 'package:graduation_project/ui/Login/login_page.dart';
  import 'package:graduation_project/ui/Home/add_employee_screen.dart';
  import 'package:graduation_project/ui/Admin/edit_company_screen.dart'; // Import EditCompanyScreen
  import 'package:graduation_project/ui/Home/announcements_screen.dart';
  import 'package:graduation_project/ui/Home/create_announcement_screen.dart';
  import 'package:graduation_project/ui/Home/department_tree_screen.dart';
  import 'dart:convert'; // For base64 encoding/decoding and JSON parsing
  import 'dart:io'; // Required for File usage
  import 'package:image_picker/image_picker.dart';
  import 'dart:typed_data'; // For web
  import 'package:flutter/foundation.dart'; // For kIsWeb
  import 'model/user.dart';
  import 'package:graduation_project/ui/Home/view_vacation_request.dart';
  import 'package:graduation_project/ui/Admin/admin_requests.dart';
  import 'package:graduation_project/ui/Admin/admin_absence_vacation.dart';



  import 'model/user.dart';

  class HomePage extends StatefulWidget {
    final String token;
    const HomePage({super.key,required this.token});

    @override
    State<HomePage> createState() => _HomePageState();
  }

  class _HomePageState extends State<HomePage> {
    double screenHeight = 0;
    double screenWidth = 0;
    Uint8List? webImage; // For web images
    String? imagePath; // For mobile/desktop images

    String id = '';
    String empId = '';
    String email = '';
    int currentIndex = 0;
    File? _profileImage; // To store the selected image file
    bool isHovering = false; // Added this variable to fix the error


    @override
    void initState() {
      super.initState();
      print("Token in HomePage: ${widget.token}");
      decodeAndPrintToken(widget.token);
    }
    void decodeAndPrintToken(String token) {
      try {
        final parts = token.split('.');
        if (parts.length != 3) {
          throw Exception("Invalid token");
        }

        final String payloadBase64 = parts[1];
        final String normalizedPayload = base64.normalize(payloadBase64);
        final String decodedPayload = utf8.decode(base64Url.decode(normalizedPayload));
        final Map<String, dynamic> payloadMap = jsonDecode(decodedPayload);

        // Extracting fields
        final companyId = payloadMap['companyId'];
        final employeeId = payloadMap['employeeId'];
        final authorities = payloadMap['authorities'];
        final sub = payloadMap['sub'];

        // Printing to console
        print('Decoded Token:');
        print('"companyId": $companyId');
        print('"employeeId": $employeeId');
        print('"authorities": $authorities');
        print('"sub": $sub');

        // Setting state if necessary
        setState(() {
          id = companyId.toString(); // Use the companyId in your app if needed
          empId = payloadMap['employeeId'].toString();
          email = payloadMap['sub'].toString();
        });
      } catch (e) {
        print("Error decoding token: $e");
      }
    }

    Future<void> pickUploadProfilePic() async {
      final ImagePicker picker = ImagePicker();
      final XFile? image = await picker.pickImage(
        source: ImageSource.gallery,
        maxHeight: 512,
        maxWidth: 512,
        imageQuality: 90,
      );

      if (image != null) {
        if (kIsWeb) {
          final Uint8List imageData = await image.readAsBytes(); // Read bytes for web
          setState(() {
            webImage = imageData;
          });
        } else {
          setState(() {
            imagePath = image.path; // File path for mobile
          });
        }
      }
    }
    // Method to handle logout
    void _showLogoutDialog() {
      double screenWidth = MediaQuery.of(context).size.width;
      bool isWeb = screenWidth > 600; // Check if it's a web environment

      showDialog(
        context: context,
        builder: (BuildContext context) {
          return Dialog(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(20),
            ),
            child: ConstrainedBox(
              constraints: BoxConstraints(
                maxWidth: isWeb ? 400 : double.infinity, // Limit width for web
              ),
              child: Padding(
                padding: EdgeInsets.all(isWeb ? 30 : 20), // Add more padding for web
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Icon(
                      Icons.logout,
                      size: 60, // Slightly larger icon
                      color: Colors.redAccent,
                    ),
                    const SizedBox(height: 20),
                    Text(
                      "Confirm Logout",
                      style: TextStyle(
                        fontSize: isWeb ? 26 : 22, // Adjust font size for web
                        fontWeight: FontWeight.bold,
                        color: Colors.black87,
                      ),
                    ),
                    const SizedBox(height: 10),
                    Text(
                      "Are you sure you want to logout?",
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: isWeb ? 18 : 16, // Adjust font size for web
                        color: Colors.grey[700],
                      ),
                    ),
                    const SizedBox(height: 25),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.grey[300],
                            foregroundColor: Colors.black,
                            padding: EdgeInsets.symmetric(
                              vertical: isWeb ? 16 : 12, // Larger padding for web
                            ),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10),
                            ),
                          ),
                          onPressed: () {
                            Navigator.of(context).pop(); // Close the dialog
                          },
                          child: const Text("Cancel"),
                        ),
                        ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.redAccent,
                            padding: EdgeInsets.symmetric(
                              vertical: isWeb ? 16 : 12, // Larger padding for web
                            ),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10),
                            ),
                          ),
                          onPressed: () {
                            Navigator.of(context).pop(); // Close the dialog
                            Navigator.of(context).pushReplacement(
                              MaterialPageRoute(
                                builder: (context) => const Login(),
                              ),
                            );
                          },
                          child: const Text(
                            "Logout",
                            style: TextStyle(color: Colors.white),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          );
        },
      );
    }

    // Method to navigate to the specific screen
    void _navigateTo(int index) {
      setState(() {
        currentIndex = index;
      });
      Navigator.pop(context);  // Close the drawer when an item is clicked
    }

    @override
    Widget build(BuildContext context) {
      screenHeight = MediaQuery.of(context).size.height;
      screenWidth = MediaQuery.of(context).size.width;

      return Scaffold(
        appBar: AppBar(
          title: Text(getPageTitle(currentIndex)), // Dynamic page title
          backgroundColor: Colors.blue.shade900,
          leading: Builder(
            builder: (BuildContext context) {
              return IconButton(
                icon: const Icon(Icons.menu), // Hamburger menu icon
                onPressed: () {
                  Scaffold.of(context).openDrawer(); // Opens the drawer when the icon is tapped
                },
              );
            },
          ),
        ),

        // Add the Drawer widget
        drawer: Drawer(
          child: ListView(
            padding: const EdgeInsets.all(0),
            children: [
              UserAccountsDrawerHeader(
                accountName: Text("Employee Name"),
                accountEmail: Text("employee@example.com"),
                currentAccountPicture: GestureDetector(
                  onTap: pickUploadProfilePic,
                  child: MouseRegion(
                    onEnter: (_) => setState(() => isHovering = true),
                    onExit: (_) => setState(() => isHovering = false),
                    child: AnimatedContainer(
                      duration: const Duration(milliseconds: 300),
                      height: isHovering ? 170 : 160,
                      width: isHovering ? 170 : 160,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        gradient: const LinearGradient(
                          colors: [Color(0xFF608BC1), Color(0xFF133E87)],
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                        ),
                        boxShadow: const [
                          BoxShadow(
                            color: Colors.black26,
                            blurRadius: 12,
                            offset: Offset(4, 4),
                          ),
                        ],
                      ),
                      child: ClipOval(
                        child: _buildProfileImage(),
                      ),
                    ),
                  ),
                ),
              ),
              ListTile(
                leading: Icon(Icons.home),
                title: Text("Today"),
                onTap: () => _navigateTo(0),
              ),
              ListTile(
                leading: Icon(Icons.calendar_month),
                title: Text("Calendar"),
                onTap: () => _navigateTo(1),
              ),
              ListTile(
                leading: Icon(Icons.person),
                title: Text("Employee Details"),
                onTap: () => _navigateTo(2),
              ),
              ListTile(
                leading: Icon(Icons.account_circle),
                title: Text("Edit Profile"),
                onTap: () => _navigateTo(3),
              ),
              ListTile(
                leading: Icon(Icons.request_page),
                title: Text("Vacation Request"),
                onTap: () => _navigateTo(4),
              ),
              ListTile(leading: const Icon(Icons.person_add), title: const Text("Add Employee"), onTap: () => _navigateTo(5)),
              ListTile(
                leading: const Icon(Icons.edit),
                title: const Text("Edit Company"),
                onTap: () {
                  Navigator.pop(context);
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => EditCompanyScreen(companyId: id), // Pass companyId
                    ),
                  );
                },
              ),            ListTile(
                leading: const Icon(Icons.announcement),
                title: const Text("Announcements"),
                onTap: () => _navigateTo(7), // Add a new index for Announcements
              ),
              ListTile(
                leading: const Icon(Icons.campaign),
                title: const Text("Create Announcement"),
                onTap: () => _navigateTo(8), // New index for Create Announcement screen
              ),
              ListTile(
                leading: const Icon(Icons.account_tree_outlined),
                title: const Text("Organization"),
                onTap: () => _navigateTo(9), // New index for Department Tree page
              ),
              ListTile(
                leading: const Icon(Icons.request_page),
                title: const Text("View Vacation Request"),
                onTap: () => _navigateTo(10), // New index for Department Tree page
              ),
              ListTile(
                leading: const Icon(Icons.request_page),
                title: const Text(" Vacation Approval"),
                onTap: () => _navigateTo(11), // New index for Department Tree page
              ),

              ListTile(
                leading: const Icon(Icons.person),
                title: const Text(" Check Employee Attendance"),
                onTap: () => _navigateTo(12), // New index for Department Tree page
              ),


              Divider(),
              ListTile(
                leading: Icon(Icons.logout),
                title: Text("Logout"),
                onTap: _showLogoutDialog,
              ),
            ],
          ),
        ),

        body: IndexedStack(
          index: currentIndex,
          children:  [
            TodayScreen(employeeId: empId, email: email,),
            CalendarScreen(employeeId: empId, email: email,),
            EmployeeProfileScreen(),
            ProfileScreen(),
            VacationRequestScreen(),
            AddEmployeeScreen(companyId: id),
            EditCompanyScreen(companyId: id),
            AnnouncementsScreen(),
            CreateAnnouncementScreen(),
            DepartmentTreeScreen(companyId: id),
            VacationViewScreen(),
            AdminRequestsPage(),
            AdminAbsenceVacationPage(),
          ],
        ),
      );
    }

    // Function to get the page title dynamically
    String getPageTitle(int index) {
      switch (index) {
        case 0:
          return "Today Attendance";
        case 1:
          return "Monthly Attendance";
        case 2:
          return "Employee Profile";
        case 3:
          return "Profile";
        case 4:
          return "Vacation Request";
        case 5:
          return "Add Employee";
        case 6:
          return "Edit Company";
        case 7:
          return "Announcements";
        case 8:
          return "Create Announcement";
        case 9:
          return "Organization";
        case 10:
          return "View Vacation Request";
        case 11:
          return"Vacation Approval";
        case 12:
          return"Check Employee Attendance";

        default:
          return "Home";
      }
    }

    Widget _buildProfileImage() {
      if (kIsWeb) {
        return webImage != null
            ? Image.memory(
          webImage!,
          fit: BoxFit.cover,
          width: 160,
          height: 160,
        )
            : const Icon(Icons.person, color: Colors.white, size: 80);
      } else {
        return imagePath != null
            ? Image.file(
          File(imagePath!),
          fit: BoxFit.cover,
          width: 160,
          height: 160,
        )
            : const Icon(Icons.person, color: Colors.white, size: 80);
      }
    }
  }
