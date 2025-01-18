import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class AddEmployeeScreen extends StatefulWidget {
  final String companyId; // Receive company ID
  const AddEmployeeScreen({super.key, required this.companyId});

  @override
  State<AddEmployeeScreen> createState() => _AddEmployeeScreenState();
}

class _AddEmployeeScreenState extends State<AddEmployeeScreen> {
  final TextEditingController firstNameController = TextEditingController();
  final TextEditingController lastNameController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController phoneNumberController = TextEditingController();
  final TextEditingController employeeIdController = TextEditingController();
  final TextEditingController salaryController = TextEditingController();
  final TextEditingController addressController = TextEditingController();
  final TextEditingController skillsController = TextEditingController();


  List<String> skills = [];
  List<Map<String, dynamic>> departments = []; // List of departments
  List<Map<String, dynamic>> workTitles = []; // List of work titles for the selected department
  String? selectedDepartmentId;
  String? selectedWorkTitleId;
  String? selectedWorkTime;
  String? employeeType;
  bool isOvertimeAllowed = false;

  final List<String> workTimeOptions = ["SUNDAY_TO_THURSDAY", "MONDAY_TO_FRIDAY"];
  final List<String> employeeTypes = ["FULL_TIME", "PART_TIME", "TRAINEE"]; // Add this line


  @override
  void initState() {
    super.initState();
    _fetchCompanyDetails(); // Fetch company details on screen load
  }

  Future<void> _fetchCompanyDetails() async {
    final url = 'http://localhost:8080/api/companies/${widget.companyId}';

    try {
      final response = await http.get(Uri.parse(url));
      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        setState(() {
          departments = (data["departments"] as List).map((dept) {
            return {
              "id": dept["id"],
              "name": dept["name"],
              "workTitles": (dept["workTitles"] as List).map((workTitle) {
                return {
                  "id": workTitle["id"],
                  "name": workTitle["name"],
                  "authorityIds": workTitle["authorityIds"] ?? [],
                };
              }).toList(),
            };
          }).toList();
        });
      } else {
        throw Exception('Failed to load company details. Error: ${response.body}');
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Error: $e')));
    }
  }

  void _onDepartmentSelected(String? departmentName) {
    setState(() {
      final selectedDepartment = departments.firstWhere((dept) => dept["name"] == departmentName);
      selectedDepartmentId = selectedDepartment["id"].toString();
      workTitles = selectedDepartment["workTitles"]; // Update work titles for the selected department
      selectedWorkTitleId = null; // Clear selected work title
    });
  }

  Future<void> _addEmployee() async {
    final url = 'http://localhost:8080/api/employees/invite/${widget.companyId}';
    final employeeId = int.tryParse(employeeIdController.text);
    final salary = double.tryParse(salaryController.text);

    if (employeeId == null || salary == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please enter valid numeric values for Employee ID and Salary.')),
      );
      return;
    }

    final requestBody = {
      "id": employeeId,
      "email": emailController.text.trim(),
      "name": "${firstNameController.text.trim()} ${lastNameController.text.trim()}",
      "phoneNumber": phoneNumberController.text.trim(),
      "address": addressController.text.trim(),
      "salary":salary,
      "skills": skills.join(", "), // Convert skills list to a comma-separated string
      "type": employeeType,
      "departmentId": int.parse(selectedDepartmentId!), // Convert to integer
      "workTitleId": int.parse(selectedWorkTitleId!), // Convert to integer
      "workScheduleType": selectedWorkTime,
      "overtimeAllowed": isOvertimeAllowed,
    };

    try {
      final response = await http.post(
        Uri.parse(url),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode(requestBody),
      );

      if (response.statusCode == 201 || response.statusCode == 200) {
        _showConfirmationDialog();
      } else {
        throw Exception('Failed to add employee. Error: ${response.body}');
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error: $e')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    bool isWeb = screenWidth > 600;

    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [Colors.grey.shade300, Colors.white],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: Center(
          child: SingleChildScrollView(
            padding: EdgeInsets.symmetric(horizontal: isWeb ? screenWidth * 0.2 : 16, vertical: 20),
            child: Card(
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
              elevation: 8,
              child: Padding(
                padding: const EdgeInsets.all(20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Center(
                      child: Text(
                        "Add New Employee",
                        style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold, color: Color(0xFF133E87)),
                      ),
                    ),
                    const SizedBox(height: 20),
                    _buildTextField("Employee ID", employeeIdController, Icons.badge, "Enter the employee's unique ID."),
                    const SizedBox(height: 16),
                    _buildTextField("First Name", firstNameController, Icons.person, "Enter the employee's first name."),
                    const SizedBox(height: 16),
                    _buildTextField("Last Name", lastNameController, Icons.person_outline, "Enter the employee's last name."),
                    const SizedBox(height: 16),
                    _buildTextField("Email", emailController, Icons.email, "Enter a valid email address."),
                    const SizedBox(height: 16),
                    _buildTextField("Phone Number", phoneNumberController, Icons.phone, "Enter the employee's phone number."),
                    const SizedBox(height: 16),
                    _buildTextField("Address", addressController, Icons.location_on, "Enter the employee's address."),
                    const SizedBox(height: 16),
                    _buildTextField("Salary", salaryController, Icons.money, "Enter the employee's salary."),
                    const SizedBox(height: 16),
                    _buildDropdown(
                      "Select Department",
                      departments.map((d) => d["name"] as String).toList(),
                      Icons.apartment,
                      _onDepartmentSelected,
                    ),
                    const SizedBox(height: 16),
                    _buildWorkTitleDropdown(), // Separate work title dropdown widget
                    const SizedBox(height: 16),
                    _buildDropdown("Select Work Time", workTimeOptions, Icons.calendar_today, (value) {
                      setState(() {
                        selectedWorkTime = value;
                      });
                    }),
                    const SizedBox(height: 16),
                    _buildDropdown("Employee Type", employeeTypes, Icons.work, (value) {
                      setState(() {
                        employeeType = value;
                      });
                    }),
                    const SizedBox(height: 16),
                    _buildSkillsField(),
                    const SizedBox(height: 16),
                    Row(
                      children: [
                        const Text(
                          "Overtime Allowed",
                          style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                        ),
                        const Spacer(),
                        Switch(
                          value: isOvertimeAllowed,
                          onChanged: (value) {
                            setState(() {
                              isOvertimeAllowed = value;
                            });
                          },
                        ),
                      ],
                    ),
                    const SizedBox(height: 24),                    Center(
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFF133E87),
                          padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 40),
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                        ),
                        onPressed: () {
                          if (employeeIdController.text.isEmpty ||
                              firstNameController.text.isEmpty ||
                              lastNameController.text.isEmpty ||
                              emailController.text.isEmpty ||
                              phoneNumberController.text.isEmpty ||
                              salaryController.text.isEmpty ||
                              selectedDepartmentId == null ||
                              selectedWorkTitleId == null ||
                              selectedWorkTime == null ||
                              selectedWorkTime == null ||
                              employeeType == null) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(content: Text("Please fill all fields before submitting.")),
                            );
                          } else {
                            _addEmployee();
                          }
                        },
                        child: const Text(
                          "Add Employee",
                          style: TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildSkillsField() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          "Skills",
          style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 10),
        Row(
          children: [
            Expanded(
              child: TextField(
                controller: skillsController,
                decoration: InputDecoration(
                  hintText: "Enter a skill",
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
                  filled: true,
                  fillColor: Colors.grey.shade100,
                ),
              ),
            ),
            const SizedBox(width: 10),
            ElevatedButton(
              style: ElevatedButton.styleFrom(backgroundColor: Colors.teal),
              onPressed: () {
                if (skillsController.text.isNotEmpty) {
                  setState(() {
                    skills.add(skillsController.text.trim());
                    skillsController.clear();
                  });
                }
              },
              child: const Text("Add"),
            ),
          ],
        ),
        const SizedBox(height: 10),
        Wrap(
          spacing: 8,
          children: skills.map((skill) {
            return Chip(
              label: Text(skill),
              deleteIcon: const Icon(Icons.cancel),
              onDeleted: () {
                setState(() {
                  skills.remove(skill);
                });
              },
            );
          }).toList(),
        ),
      ],
    );
  }


  Widget _buildTextField(String label, TextEditingController controller, IconData icon, String helperText) {
    return TextField(
      controller: controller,
      keyboardType: label == "Phone Number" || label == "Salary" ? TextInputType.number : TextInputType.text,
      decoration: InputDecoration(
        labelText: label,
        helperText: helperText,
        prefixIcon: Icon(icon, color: const Color(0xFF133E87)),
        labelStyle: const TextStyle(color: Colors.black87),
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
        filled: true,
        fillColor: Colors.grey.shade100,
      ),
    );
  }

  Widget _buildDropdown(String hint, List<String> items, IconData icon, Function(String?) onChanged) {
    return DropdownButtonFormField<String>(
      decoration: InputDecoration(
        labelText: hint,
        prefixIcon: Icon(icon, color: const Color(0xFF133E87)),
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
        filled: true,
        fillColor: Colors.grey.shade100,
      ),
      hint: Text(hint),
      value: null,
      isExpanded: true,
      items: items.map((item) {
        return DropdownMenuItem<String>(
          value: item,
          child: Text(item),
        );
      }).toList(),
      onChanged: onChanged,
    );
  }

  Widget _buildWorkTitleDropdown() {
    return DropdownButtonFormField<String>(
      decoration: InputDecoration(
        labelText: "Select Work Title",
        prefixIcon: Icon(Icons.work, color: const Color(0xFF133E87)),
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
        filled: true,
        fillColor: Colors.grey.shade100,
      ),
      hint: const Text("Select Work Title"),
      value: selectedWorkTitleId != null
          ? workTitles.firstWhere((t) => t["id"].toString() == selectedWorkTitleId)["name"] as String
          : null,
      isExpanded: true,
      items: workTitles.isNotEmpty
          ? workTitles.map((workTitle) {
        return DropdownMenuItem<String>(
          value: workTitle["name"],
          child: Text(workTitle["name"]),
        );
      }).toList()
          : [],
      onChanged: workTitles.isEmpty
          ? null // Disable the dropdown if there are no work titles
          : (value) {
        setState(() {
          selectedWorkTitleId = workTitles.firstWhere((t) => t["name"] == value)["id"].toString();
        });
      },
    );
  }

  void _showConfirmationDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return Dialog(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
          child: Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Icon(Icons.check_circle, size: 60, color: Colors.green),
                const SizedBox(height: 10),
                const Text(
                  "Success",
                  style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: Colors.black87),
                ),
                const SizedBox(height: 10),
                const Text(
                  "Employee added successfully!",
                  textAlign: TextAlign.center,
                  style: TextStyle(fontSize: 16, color: Colors.black54),
                ),
                const SizedBox(height: 20),
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF133E87),
                    padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 40),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                  ),
                  onPressed: () {
                    Navigator.of(context).pop();
                    _clearFields();
                  },
                  child: const Text("Close", style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  void _clearFields() {
    employeeIdController.clear();
    firstNameController.clear();
    lastNameController.clear();
    emailController.clear();
    phoneNumberController.clear();
    addressController.clear();
    salaryController.clear();
    selectedDepartmentId = null;
    selectedWorkTitleId = null;
    selectedWorkTime = null;
    workTitles = [];
    setState(() {});
  }
}
