  import 'package:flutter/material.dart';
import 'package:graduation_project/ui/Admin/create_project.dart';
import 'package:graduation_project/ui/Home/add_CV.dart';
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
  import 'package:http/http.dart' as http;
  import 'package:http_parser/http_parser.dart';
  import 'package:graduation_project/ui/Admin/view_project.dart'; // Import EditCompanyScreen
  import'package:graduation_project/ui/Home/ViewCVScreen.dart';
  import 'package:graduation_project/ui/Home/add_CV.dart';




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
    List<String> userAuthorities = [];
    Uint8List? webImage; // For web images
    String? imagePath; // For mobile/desktop images

    String id = '';
    String empId = '';
    String email = '';
    int currentIndex = 0;
    File? _profileImage; // To store the selected image file
    bool isHovering = false; // Added this variable to fix the error
    Uint8List? profilePicture;



    final List<String> orderedAuthorities = [
      "ATTENDANCE",
      "VIEW_MONTHLY_ATTENDANCE",
      "VIEW_PROFILE",
      "EDIT_PROFILE",
      "ADD_EMPLOYEE",
      "EDIT_EMPLOYEE",
      "EDIT_COMPANY",
      "CREATE_ANNOUNCEMENT",
      "VIEW_ANNOUNCEMENTS",
      "PAYROLL",
      "REQUEST_LEAVE",
      "APPROVE_REJECT_LEAVES",
      "VIEW_LEAVE",
      "VIEW_ORGANIZATION_TREE",
      "CREATE_PROJECT",
      "VIEW_PROJECT",
      "VIEW_CV",
      "VIEW_CV_SUMMARY",
      "ADD_CV",
    ];

    final Map<String, Map<String, dynamic>> authorityToMenu = {
      "ATTENDANCE": {
        "title": "Today",
        "icon": Icons.home,
        "page": (String empId, String email, String id, String token) =>
            TodayScreen(employeeId: empId, email: email, token:token),
      },
      "VIEW_MONTHLY_ATTENDANCE": {
        "title": "Calendar",
        "icon": Icons.calendar_month,
        "page": (String empId, String email, String id, String token) =>
            CalendarScreen(employeeId: empId, email: email , token:token),
      },
      "VIEW_PROFILE": {
        "title": "Employee Details",
        "icon": Icons.person,
        "page": (String empId, String email, String id, String token) =>
            EmployeeProfileScreen(employeeId: empId, email: email , token:token ),
      },
      "EDIT_PROFILE": {
        "title": "Edit Profile",
        "icon": Icons.edit,
        "page": (String empId, String email, String id, String token) =>
            ProfileScreen(companyId: id, token:token),
      },
      "ADD_EMPLOYEE": {
        "title": "Add Employee",
        "icon": Icons.person_add,
        "page": (String empId, String email, String id, String token) =>
            AddEmployeeScreen(companyId: id, token:token),
      },
      "EDIT_COMPANY": {
        "title": "Edit Company",
        "icon": Icons.business,
        "page": (String empId, String email, String id, String token) =>
            EditCompanyScreen(companyId: id, token:token),
      },
      "CREATE_ANNOUNCEMENT": {
        "title": "Create Announcement",
        "icon": Icons.campaign,
        "page": (String empId, String email, String id, String token) =>
            CreateAnnouncementScreen(
                employeeId: empId, employeeEmail: email, companyId: id, token:token),
      },
      "VIEW_ANNOUNCEMENTS": {
        "title": "Announcements",
        "icon": Icons.announcement,
        "page": (String empId, String email, String id, String token) =>
            AnnouncementsScreen(companyId: id, token:token),
      },
      "REQUEST_LEAVE": {
        "title": "Vacation Request",
        "icon": Icons.request_page,
        "page": (String empId, String email, String id, String token) =>
            VacationRequestScreen(
                employeeId: empId, employeeEmail: email, companyId: id, token:token),
      },
      "APPROVE_REJECT_LEAVES": {
        "title": "Vacation Approval",
        "icon": Icons.approval,
        "page": (String empId, String email, String id, String token) => AdminRequestsPage(
            companyId: id, approverId: empId, approverEmail: email, token:token),
      },
      "VIEW_LEAVE": {
        "title": "View Vacation Request",
        "icon": Icons.visibility,
        "page": (String empId, String email, String id, String token) =>
            VacationViewScreen(employeeId: empId, employeeEmail: email, token:token),
      },
      "VIEW_ORGANIZATION_TREE": {
        "title": "Organizations",
        "icon": Icons.account_tree,
        "page": (String empId, String email, String id, String token) =>
            OrganizationTreeScreen(companyId: id, token:token),
      },
      "CREATE_PROJECT": {
        "title": "Create Project",
        "icon": Icons.create,
        "page": (String empId, String email, String id, String token) =>
            CreateProject(employeeId: empId, employeeEmail: email, companyId: id, token:token),
      },

      "VIEW_PROJECT":{
        "title": "View Project",
        "icon": Icons.visibility,
        "page": (String empId, String email, String id, String token) =>
            ViewProject(employeeId: empId, employeeEmail: email, companyId: id, token:token),
      },

      "VIEW_CV":{
        "title": "View CVs",
        "icon": Icons.visibility,
        "page": (String empId, String email, String id, String token) =>
            ViewCVScreen(employeeId: empId, employeeEmail: email, companyId: id, token:token),
      },

      "VIEW_CV_SUMMARY":{
        "title": "View CV Summary",
        "icon": Icons.visibility,
        "page": (String empId, String email, String id, String token) =>
            ViewProject(employeeId: empId, employeeEmail: email, companyId: id, token:token),
      },

      "ADD_CV":{
        "title": "Add CV",
        "icon": Icons.visibility,
        "page": (String empId, String email, String id, String token) =>
            AddCVScreen(employeeId: empId, employeeEmail: email, companyId: id, token:token),
      }
    };




    @override
    void initState() {
      super.initState();
      print("Token in HomePage: ${widget.token}");
      decodeAndPrintToken(widget.token);
      fetchProfilePicture(); // Fetch the profile picture when the app starts

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
          userAuthorities = List<String>.from(payloadMap['authorities']);

        });
      } catch (e) {
        print("Error decoding token: $e");
      }
    }
    Future<void> fetchProfilePicture() async {
      final url = 'http://192.168.68.111:8080/api/employees/$empId/$email/picture';
      try {
        final response = await http.get(Uri.parse(url));
        if (response.statusCode == 200) {
          setState(() {
            profilePicture = response.bodyBytes;
          });
        } else {
          print("Failed to fetch profile picture: ${response.body}");
        }
      } catch (e) {
        print("Error fetching profile picture: $e");
      }
    }
    List<Widget> _buildMenuItems() {
      final bool isWeb = kIsWeb; // Check if running on web

      // Determine which authorities to use based on the platform
      final allowedAuthorities = isWeb
          ? orderedAuthorities // Full set for web
          : ["ATTENDANCE", "VIEW_MONTHLY_ATTENDANCE", "VIEW_PROFILE"]; // Limited set for mobile

      // Filter and create menu items
      final filteredAuthorities = allowedAuthorities
          .where((auth) => userAuthorities.contains(auth) && authorityToMenu.containsKey(auth))
          .toList();

      return List.generate(filteredAuthorities.length, (index) {
        final authority = filteredAuthorities[index];
        final menu = authorityToMenu[authority]!;
        return ListTile(
          leading: Icon(menu["icon"]),
          title: Text(menu["title"]),
          onTap: () {
            if (currentIndex != index) {
              setState(() {
                currentIndex = index;
              });
            }
            Navigator.pop(context); // Close the drawer
          },
        );
      });
    }



    List<Widget> _buildPages() {
      final bool isWeb = kIsWeb; // Check if running on web

      // Determine which authorities to use based on the platform
      final allowedAuthorities = isWeb
          ? orderedAuthorities // Full set for web
          : ["ATTENDANCE", "VIEW_MONTHLY_ATTENDANCE", "VIEW_PROFILE"]; // Limited set for mobile

      // Filter and create pages
      final filteredAuthorities = allowedAuthorities
          .where((auth) => userAuthorities.contains(auth) && authorityToMenu.containsKey(auth))
          .toList();

      return filteredAuthorities.map((authority) {
        final pageFactory =
        authorityToMenu[authority]!["page"] as Widget Function(String, String, String, String);
        return pageFactory(empId, email, id, widget.token); // Pass token here
      }).toList();
    }




    Future<void> pickUploadProfilePic() async {
      final picker = ImagePicker();
      final XFile? image = await picker.pickImage(
        source: ImageSource.gallery,
        maxHeight: 512,
        maxWidth: 512,
        imageQuality: 90,
      );

      if (image != null) {
        if (kIsWeb) {
          final Uint8List imageData = await image.readAsBytes();
          uploadProfilePicture(imageData);
        } else {
          uploadProfilePicture(File(image.path).readAsBytesSync());
        }
      }
    }


    Future<void> uploadProfilePicture(Uint8List imageData) async {
      final url = 'http://192.168.68.111:8080/api/employees/$empId/$email/upload-picture';
      final request = http.MultipartRequest('POST', Uri.parse(url))
        ..fields['employeeId'] = empId
        ..files.add(
          http.MultipartFile.fromBytes(
            'picture',
            imageData,
            filename: 'profile_pic.png',
            contentType: MediaType('image', 'png'),
          ),
        );

      try {
        final response = await request.send();
        if (response.statusCode == 200) {
          setState(() {
            profilePicture = imageData;
          });
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text("Profile picture updated successfully!")),
          );
        } else {
          print("Failed to upload profile picture. Status: ${response.statusCode}");
        }
      } catch (e) {
        print("Error uploading profile picture: $e");
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
          title: Text(
            authorityToMenu[
            orderedAuthorities.where((auth) => userAuthorities.contains(auth)).toList()[currentIndex]
            ]?["title"] ?? "Home", // Fallback to "Home" if null
          ),
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
                accountName: Text(""),
                accountEmail: Text(email),
                currentAccountPicture: GestureDetector(
                  onTap: pickUploadProfilePic, // Open file picker to upload profile picture
                  child: MouseRegion(
                    onEnter: (_) => setState(() => isHovering = true), // On hover, increase size
                    onExit: (_) => setState(() => isHovering = false), // On exit, reset size
                    child: AnimatedContainer(
                      duration: const Duration(milliseconds: 300), // Smooth size transition
                      height: isHovering ? 170 : 160,
                      width: isHovering ? 170 : 160,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        gradient: const LinearGradient(
                          colors: [Color(0xFF608BC1), Color(0xFF133E87)], // Gradient background
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                        ),
                        boxShadow: const [
                          BoxShadow(
                            color: Colors.black26, // Subtle shadow
                            blurRadius: 12,
                            offset: Offset(4, 4),
                          ),
                        ],
                      ),
                      child: ClipOval(
                        child: _buildProfileImage(), // Display profile picture or placeholder
                      ),
                    ),
                  ),
                ),
              ),

              ..._buildMenuItems(),
              const Divider(),
              ListTile(
                leading: const Icon(Icons.logout),
                title: const Text("Logout"),
                onTap: () {
                  Navigator.pushReplacement(
                      context, MaterialPageRoute(builder: (_) => const Login()));
                },
              ),
            ],
          ),
        ),
        body: IndexedStack(index: currentIndex, children: _buildPages()),
      );
    }

    // Function to get the page title dynamically
    String getPageTitle(int index) {
      final filteredAuthorities = orderedAuthorities
          .where((auth) => userAuthorities.contains(auth) && authorityToMenu.containsKey(auth))
          .toList();

      if (index < filteredAuthorities.length) {
        return authorityToMenu[filteredAuthorities[index]]?["title"] ?? "Home";
      }
      return "Home"; // Fallback title
    }



    Widget _buildProfileImage() {
      if (profilePicture != null) {
        return Image.memory(
          profilePicture!,
          fit: BoxFit.cover,
          width: 160,
          height: 160,
        );
      }

      // Fallback for web
      if (kIsWeb && webImage != null) {
        return Image.memory(
          webImage!,
          fit: BoxFit.cover,
          width: 160,
          height: 160,
        );
      }

      // Fallback for mobile/desktop
      if (!kIsWeb && imagePath != null) {
        return Image.file(
          File(imagePath!),
          fit: BoxFit.cover,
          width: 160,
          height: 160,
        );
      }

      // Default placeholder
      return const Icon(Icons.person, color: Colors.white, size: 80);
    }

  }
