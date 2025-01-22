import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class ProfileScreen extends StatefulWidget {
  final String companyId; // Add companyId parameter
  const ProfileScreen({Key? key, required this.companyId}) : super(key: key);

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
// Fetch employees on screen load
  }

  Future<void> _fetchEmployees() async {
    final url = 'http://localhost:8080/api/employees/company/${widget.companyId}/employees';

    try {
      final response = await http.get(Uri.parse(url));
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
      final response = await http.get(Uri.parse(url));
      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        setState(() {
          departments = List<Map<String, dynamic>>.from(data['departments'] ?? []);
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
      final response = await http.get(Uri.parse(url));
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
      final response = await http.get(Uri.parse(url));
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
      final response = await http.get(Uri.parse(url));
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
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Error fetching supervisors: $e')));
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
      nameController.text = ''; // Clear until fetched
      phoneController.text = ''; // Clear until fetched
      addressController.text = ''; // Clear until fetched
      selectedJobType = employee["type"] ?? jobTypes.first;
      selectedWorkTime = employee["workScheduleType"] ?? workTimes.first;

      selectedDepartment = departments.firstWhere(
            (dept) => dept["id"].toString() == (employee["departmentId"]?.toString() ?? ""),
        orElse: () => {},
      )["name"];

      selectedWorkTitle = workTitles.firstWhere(
            (title) => title["id"].toString() == (employee["workTitleId"]?.toString() ?? ""),
        orElse: () => {},
      )["name"];
    });

    // Fetch detailed info for the selected employee
    _fetchEmployeeDetails(employee["id"].toString(), employee["email"]);
  }


  void _saveEmployeeDetails() async {
    if (selectedEmployeeId == null) {
      _showSnackBar("No employee selected for editing.");
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
        headers: {"Content-Type": "application/json"},
        body: jsonEncode(updatedDetails),
      );

      if (response.statusCode == 200) {
        _showSnackBar("Employee details updated successfully!");
        // Optionally, refresh the employee list to reflect changes
        _fetchEmployees();
      } else {
        throw Exception('Failed to update employee. Status: ${response.statusCode}');
      }
    } catch (e) {
      _showSnackBar("Error updating employee details: $e");
    }
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

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    bool isWeb = screenWidth > 600;
    double contentWidth = isWeb ? screenWidth * 0.5 : screenWidth * 0.9;

    return Scaffold(
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
                      departments.map<String>((dept) => dept["name"]?.toString() ?? "").toList(),
                      selectedDepartment,
                          (value) {
                        setState(() {
                          selectedDepartment = value;
                          workTitles = List<Map<String, dynamic>>.from(
                              departments.firstWhere((dept) => dept["name"] == value)["workTitles"]
                          );
                          selectedWorkTitle = null;
                        });
                      },
                    ),
                    _buildDropdown(
                      "Work Title",
                      workTitles.map<String>((title) => title["name"]?.toString() ?? "").toList(),
                      selectedWorkTitle,
                          (value) {
                        setState(() {
                          selectedWorkTitle = value;
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
