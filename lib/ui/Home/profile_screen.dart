import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class ProfileScreen extends StatefulWidget {
  final String companyId; // Add companyId parameter
  final String token; // Add token parameter

  const ProfileScreen({Key? key, required this.companyId,required this.token}) : super(key: key);

  @override
  _ProfileScreenState createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  TextEditingController searchController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  TextEditingController phoneController = TextEditingController();
  TextEditingController addressController = TextEditingController();
  TextEditingController nameController = TextEditingController();
  TextEditingController skillsController = TextEditingController();
  TextEditingController typeController = TextEditingController();
  TextEditingController departmentIdController = TextEditingController();
  TextEditingController workTitleIdController = TextEditingController();
  TextEditingController workScheduleController = TextEditingController();
  TextEditingController departmentController = TextEditingController(); // Added
  TextEditingController workTitleController = TextEditingController(); // Added
  TextEditingController supervisorIdController = TextEditingController();
  TextEditingController supervisorEmailController = TextEditingController();

  String? selectedSupervisor;
  String? selectedDepartment;
  String? selectedWorkTitle;
  String? selectedJobType;
  String? selectedWorkTime;

  String? selectedEmployeeId;

  final List<String> jobTypes = ["FULL_TIME", "PART_TIME", "TRAINEE"];
  final List<String> workTimes = ["SUNDAY_TO_THURSDAY", "MONDAY_TO_FRIDAY"];
  List<Map<String, dynamic>> supervisors = [];
  List<Map<String, dynamic>> filteredSupervisors = [];

  List<Map<String, dynamic>> employees = [];
  List<Map<String, dynamic>> filteredEmployees = [];
  List<Map<String, dynamic>> departments = [];
  List<Map<String, dynamic>> workTitles = [];


  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    _fetchEmployees();
    _fetchCompanyDetails();
    _fetchSupervisors();
    if (departments.isNotEmpty) {
      _fetchDepartmentDetails(departments.first['id']); // Use the first department's ID as an example
    }
// Fetch employees on screen load
  }

  Future<void> _fetchEmployees() async {
    final url = 'http://localhost:8080/api/employees/company/${widget.companyId}/employees';

    try {
      final response = await http.get(
        Uri.parse(url),
        headers: {
          'Authorization': 'Bearer ${widget.token}', // Include the token
          'Content-Type': 'application/json',
        },
      );
      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        setState(() {
          employees = List<Map<String, dynamic>>.from(data);
          filteredEmployees = employees;
          isLoading = false;
        });
      } else {
        throw Exception('Failed to fetch employees. Status: ${response.statusCode}');
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error fetching employees: $e')),
      );
    }
  }


  Future<void> _fetchCompanyDetails() async {
    final url = 'http://localhost:8080/api/companies/${widget.companyId}';

    try {
      final response = await http.get(
        Uri.parse(url),
        headers: {
          'Authorization': 'Bearer ${widget.token}', // Include the token
          'Content-Type': 'application/json',
        },
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);

        setState(() {
          // Parse departments
          departments = List<Map<String, dynamic>>.from(data['departments'] ?? []);
          if (departments.isNotEmpty) {
            // Auto-select the first department
            final firstDepartment = departments.first;
            selectedDepartment = firstDepartment['name'];
            departmentController.text = selectedDepartment ?? ''; // Set the text field value

            // Parse work titles from the first department
            workTitles = List<Map<String, dynamic>>.from(firstDepartment['workTitles'] ?? []);
            if (workTitles.isNotEmpty) {
              // Auto-select the first work title
              selectedWorkTitle = workTitles.first['name'];
              workTitleController.text = selectedWorkTitle ?? ''; // Set the text field value
            }
          }
        });
      } else {
        throw Exception('Failed to fetch company details. Status: ${response.statusCode}');
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error fetching company details: $e')),
      );
    }
  }





  Future<void> _fetchEmployeeDetails(String employeeId, String email) async {
    final url = 'http://localhost:8080/api/employees/$employeeId/$email';

    try {
      final response = await http.get(
        Uri.parse(url),
        headers: {
          'Authorization': 'Bearer ${widget.token}', // Include the token
          'Content-Type': 'application/json',
        },
      );
      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        setState(() {
          nameController.text = data['name'] ?? 'N/A';
          phoneController.text = data['phoneNumber'] ?? 'N/A';
          addressController.text = data['address'] ?? 'N/A';
          skillsController.text = data['skills'] ?? 'N/A';

          // Update dropdown selections
          selectedJobType = data['type'] ?? jobTypes.first;
          selectedWorkTime = data['workScheduleType'] ?? workTimes.first;

          // Update department and work title
          selectedDepartment = departments.firstWhere(
                (dept) => dept["id"].toString() == data['departmentId']?.toString(),
            orElse: () => {"name": null},
          )["name"];

          workTitles = List<Map<String, dynamic>>.from(
            departments.firstWhere(
                  (dept) => dept["name"] == selectedDepartment,
              orElse: () => {"workTitles": []},
            )["workTitles"] ?? [],
          );

          selectedWorkTitle = workTitles.firstWhere(
                (title) => title["id"].toString() == data['workTitleId']?.toString(),
            orElse: () => {"name": null},
          )["name"];
        });
      } else {
        throw Exception('Failed to fetch employee details. Status: ${response.statusCode}');
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error fetching employee details: $e')),
      );
    }
  }


  Future<void> _fetchDepartmentDetails(int departmentId) async {
    final url = 'http://localhost:8080/api/departments/details/$departmentId';

    try {
      final response = await http.get(
        Uri.parse(url),
        headers: {
          'Authorization': 'Bearer ${widget.token}', // Include the token
          'Content-Type': 'application/json',
        },
      );
      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        setState(() {
          departmentController.text = data['name'] ?? 'N/A';
        });
      } else {
        throw Exception('Failed to fetch department details. Status: ${response.statusCode}');
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error fetching department details: $e')),
      );
    }
  }


  Future<void> _fetchSupervisors() async {
    final url = 'http://localhost:8080/api/employees/company/${widget.companyId}/employees';

    try {
      final response = await http.get(
        Uri.parse(url),
        headers: {
          'Authorization': 'Bearer ${widget.token}', // Include the token as a bearer token
          'Content-Type': 'application/json', // Optional, specify content type
        },
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        setState(() {
          supervisors = List<Map<String, dynamic>>.from(data);
          filteredSupervisors = supervisors;
        });
      } else {
        throw Exception('Failed to fetch supervisors. Status: ${response.statusCode}');
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error fetching supervisors: $e')),
      );
    }
  }


  void _filterSupervisors(String query) {
    setState(() {
      if (query.isEmpty) {
        filteredSupervisors = supervisors;
      } else {
        filteredSupervisors = supervisors.where((supervisor) {
          final name = supervisor['name'].toLowerCase();
          final id = supervisor['id'].toString();
          return name.contains(query.toLowerCase()) || id.contains(query);
        }).toList();
      }
    });
  }

  void _selectSupervisor(Map<String, dynamic> supervisor) {
    setState(() {
      supervisorIdController.text = supervisor['id'].toString();
      supervisorEmailController.text = supervisor['email'];
      filteredSupervisors = supervisors;
    });
  }

  void _editEmployee(Map<String, dynamic> employee) {
    setState(() {
      selectedEmployeeId = employee["id"].toString();
      emailController.text = employee["email"] ?? '';
      nameController.text = employee["name"] ?? '';
      phoneController.text = employee["phoneNumber"] ?? '';
      addressController.text = employee["address"] ?? '';
      skillsController.text = employee["skills"] ?? '';
      selectedJobType = employee["type"] ?? jobTypes.first;
      selectedWorkTime = employee["workScheduleType"] ?? workTimes.first;

      // Auto-fill department based on employee's departmentId
      final department = departments.firstWhere(
            (dept) => dept["id"].toString() == (employee["departmentId"]?.toString() ?? ""),
        orElse: () => {},
      );

      selectedDepartment = department["name"];
      departmentController.text = selectedDepartment ?? '';

      // Update work titles and auto-select if available
      workTitles = List<Map<String, dynamic>>.from(department["workTitles"] ?? []);
      selectedWorkTitle = workTitles.firstWhere(
            (title) => title["id"].toString() == (employee["workTitleId"]?.toString() ?? ""),
        orElse: () => {},
      )["name"];
    });

    _fetchEmployeeDetails(employee["id"].toString(), employee["email"]);
  }



  void _saveEmployeeDetails() async {
    if (selectedEmployeeId == null) {
      _showDialog("Error", "No employee selected for editing.");
      return;
    }

    final url = 'http://localhost:8080/api/employees/update/$selectedEmployeeId/${emailController.text}';

    final Map<String, dynamic> updatedDetails = {
      "name": nameController.text,
      "phoneNumber": phoneController.text,
      "address": addressController.text,
      "skills": skillsController.text,
      "type": selectedJobType ?? "FULL_TIME",
      "departmentId": departments.firstWhere(
            (dept) => dept["name"] == selectedDepartment,
        orElse: () => {"id": null},
      )["id"],
      "workTitleId": workTitles.firstWhere(
            (title) => title["name"] == selectedWorkTitle,
        orElse: () => {"id": null},
      )["id"],
      "workScheduleType": selectedWorkTime ?? "SUNDAY_TO_THURSDAY",
      "supervisorId": {
        "id": int.tryParse(supervisorIdController.text),
        "email": supervisorEmailController.text,
      },
    };

    try {
      final response = await http.put(
        Uri.parse(url),
        headers: {
          "Authorization": "Bearer ${widget.token}",
          "Content-Type": "application/json",
        },
        body: jsonEncode(updatedDetails),
      );

      if (response.statusCode == 200) {
        // Success dialog
        _showDialog("Success", "Employee details updated successfully!");
        _fetchEmployees(); // Refresh the employee list
      } else if (response.statusCode == 500) {
        // Show error dialog with response body (if available)
        final message = jsonDecode(response.body)['message'] ?? "Internal Server Error";
        _showDialog("Server Error", "Error 500: $message");
      } else {
        // Generic error dialog for other status codes
        final message = jsonDecode(response.body)['message'] ?? "Unexpected Error";
        _showDialog("Error", "Failed to update employee details. Status: ${response.statusCode}\n$message");
      }
    } catch (e) {
      // Show dialog for network or other exceptions
      _showDialog("Error", "An unexpected error occurred: $e");
    }
  }

  Widget _buildSectionTitle(String title) {
    return Padding(
      padding: const EdgeInsets.only(top: 16, bottom: 8),
      child: Text(
        title,
        style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Color(0xFF133E87)),
      ),
    );
  }

  Widget _buildCard(String title, Widget child) {
    return Card(
      elevation: 4,
      margin: const EdgeInsets.symmetric(vertical: 8),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              title,
              style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.black87),
            ),
            const SizedBox(height: 8),
            child,
          ],
        ),
      ),
    );
  }



  void _filterEmployees(String query) {
    setState(() {
      filteredEmployees = employees.where((employee) {
        final name = employee["name"]?.toLowerCase() ?? '';
        final email = employee["email"]?.toLowerCase() ?? '';
        return name.contains(query.toLowerCase()) || email.contains(query.toLowerCase());
      }).toList();
    });
  }

  Future<void> _refreshData() async {
    setState(() {
      isLoading = true; // Show loading indicator during refresh
    });
    await Future.wait([
      _fetchEmployees(),
      _fetchCompanyDetails(),
      _fetchSupervisors(),
    ]);
    setState(() {
      isLoading = false; // Hide loading indicator after refresh
    });
  }
  void _showDialog(String title, String content) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return Dialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
          child: Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(
                  title == "Success" ? Icons.check_circle : Icons.error,
                  color: title == "Success" ? Colors.green : Colors.red,
                  size: 60,
                ),
                const SizedBox(height: 10),
                Text(
                  title,
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: title == "Success" ? Colors.green : Colors.red,
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 15),
                Text(
                  content,
                  style: const TextStyle(
                    fontSize: 16,
                    color: Colors.black87,
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 20),
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.blue.shade900,
                    padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 12),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                  onPressed: () => Navigator.of(context).pop(),
                  child: const Text(
                    "OK",
                    style: TextStyle(
                      fontSize: 16,
                      color: Colors.white,
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }


  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    bool isWeb = screenWidth > 600;
    double contentWidth = isWeb ? screenWidth * 0.5 : screenWidth * 0.9;

    return Scaffold(
      appBar: AppBar(
        title: const Text(""),
        backgroundColor: const Color(0xFF133E87),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: _refreshData, // Call refresh function
          ),
        ],
      ),
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [Colors.grey.shade200, Colors.white],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        padding: const EdgeInsets.all(16),
        child: Center(
          child: isLoading
              ? const CircularProgressIndicator()
              : ConstrainedBox(
            constraints: BoxConstraints(maxWidth: contentWidth),
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Center(
                    child: Image.asset(
                      'images/logo_Fusion.png', // Path to your logo
                      height: 100,
                      width: 100,
                      fit: BoxFit.contain,
                    ),
                  ),
                  const SizedBox(height: 20),
                  TextField(
                    controller: searchController,
                    onChanged: _filterEmployees,
                    decoration: InputDecoration(
                      hintText: "Search employee by name or email",
                      prefixIcon: const Icon(Icons.search, color: Color(0xFF133E87)),
                      border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
                      filled: true,
                      fillColor: Colors.grey.shade100,
                    ),
                  ),
                  const SizedBox(height: 20),
                  ...filteredEmployees.map((employee) {
                    return Card(
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
                      margin: const EdgeInsets.symmetric(vertical: 8),
                      elevation: 4,
                      child: ListTile(
                        title: Text(
                          employee["name"] ?? 'Unknown',
                          style: const TextStyle(fontWeight: FontWeight.bold, color: Color(0xFF133E87)),
                        ),
                        subtitle: Text("Department: ${employee["departmentName"] ?? 'N/A'}"),
                        trailing: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: const Color(0xFF608BC1),
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                          ),
                          onPressed: () => _editEmployee(employee),
                          child: const Text("Edit"),
                        ),
                      ),
                    );
                  }).toList(),
                  const SizedBox(height: 20),
                  if (selectedEmployeeId != null) ...[
                    _buildTextField("Name", "Enter name", nameController),
                    _buildTextField("Email", "Enter email", emailController),
                    _buildTextField("Phone Number", "Enter phone number", phoneController),
                    _buildTextField("Address", "Enter address", addressController),
                    _buildDropdown(
                      "Department",
                      departments.map<String>((dept) => dept["name"] ?? "").toList(),
                      selectedDepartment,
                          (value) {
                        setState(() {
                          selectedDepartment = value;
                          departmentController.text = value ?? ''; // Update the text field value
                          // Update work titles when department changes
                          workTitles = List<Map<String, dynamic>>.from(
                              departments.firstWhere((dept) => dept["name"] == value, orElse: () => {})["workTitles"] ?? []);
                          // Reset work title selection
                          selectedWorkTitle = workTitles.isNotEmpty ? workTitles.first['name'] : null;
                          workTitleController.text = selectedWorkTitle ?? ''; // Update the text field value
                        });
                      },
                    ),




                    _buildDropdown(
                      "Work Title",
                      workTitles.map<String>((title) => title["name"] ?? "").toList(),
                      selectedWorkTitle,
                          (value) {
                        setState(() {
                          selectedWorkTitle = value;
                          workTitleController.text = value ?? ''; // Update the text field value
                        });
                      },
                    ),



                    _buildDropdown("Job Type", jobTypes, selectedJobType, (value) {
                      setState(() {
                        selectedJobType = value;
                      });
                    }),
                    _buildDropdown("Work Time", workTimes, selectedWorkTime, (value) {
                      setState(() {
                        selectedWorkTime = value;
                      });
                    }),

                    _buildSupervisorIdField(),
                    const SizedBox(height: 16),
                    _buildSupervisorEmailField(),
                    const SizedBox(height: 16),
                    const SizedBox(height: 20),
                    ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF133E87),
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                      ),
                      onPressed: _saveEmployeeDetails, // Directly call the function
                      child: const Center(
                        child: Text(
                          "SAVE CHANGES",
                          style: TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.bold),
                        ),
                      ),
                    ),

                  ],
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
  Widget _buildSupervisorIdField() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text("Supervisor ID", style: TextStyle(fontWeight: FontWeight.bold)),
        const SizedBox(height: 8),
        TextField(
          controller: supervisorIdController,
          decoration: InputDecoration(
            hintText: "Enter or search Supervisor ID",
            border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
          ),
          onChanged: _filterSupervisors,
        ),
        const SizedBox(height: 8),
        if (filteredSupervisors.isNotEmpty)
          Container(
            height: 150,
            decoration: BoxDecoration(border: Border.all(color: Colors.grey), borderRadius: BorderRadius.circular(8)),
            child: ListView.builder(
              itemCount: filteredSupervisors.length,
              itemBuilder: (context, index) {
                final supervisor = filteredSupervisors[index];
                return ListTile(
                  title: Text(supervisor['name']),
                  subtitle: Text(supervisor['email']),
                  onTap: () => _selectSupervisor(supervisor),
                );
              },
            ),
          ),
      ],
    );
  }

  Widget _buildSupervisorEmailField() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text("Supervisor Email", style: TextStyle(fontWeight: FontWeight.bold)),
        const SizedBox(height: 8),
        TextField(
          controller: supervisorEmailController,
          readOnly: true,
          decoration: InputDecoration(
            hintText: "Supervisor Email",
            border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
          ),
        ),
      ],
    );
  }

  Widget _buildTextField(String title, String hint, TextEditingController controller) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16, color: Color(0xFF133E87)),
        ),
        const SizedBox(height: 8),
        TextField(
          controller: controller,
          decoration: InputDecoration(
            hintText: hint,
            border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
            filled: true,
            fillColor: Colors.grey.shade100,
          ),
        ),
        const SizedBox(height: 16),
      ],
    );
  }

  Widget _buildDropdown(String title, List<String> items, String? selectedItem, Function(String?) onChanged) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16, color: Color(0xFF133E87)),
        ),
        const SizedBox(height: 8),
        DropdownButtonFormField<String>(
          value: selectedItem,
          items: items.map((item) {
            return DropdownMenuItem<String>(
              value: item,
              child: Text(item),
            );
          }).toList(),
          onChanged: onChanged,
          decoration: InputDecoration(
            filled: true,
            fillColor: Colors.grey.shade100,
            border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
          ),
        ),
        const SizedBox(height: 16),
      ],
    );
  }

  void _showSnackBar(String text) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        behavior: SnackBarBehavior.floating,
        content: Text(text),
        backgroundColor: const Color(0xFF133E87),
      ),
    );
  }
}
