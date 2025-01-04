import 'package:flutter/material.dart';

class AddEmployeeScreen extends StatefulWidget {
  const AddEmployeeScreen({super.key});

  @override
  State<AddEmployeeScreen> createState() => _AddEmployeeScreenState();
}

class _AddEmployeeScreenState extends State<AddEmployeeScreen> with SingleTickerProviderStateMixin {
  final TextEditingController firstNameController = TextEditingController();
  final TextEditingController lastNameController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController employeeIdController = TextEditingController(); // New input for Employee ID
  String? selectedDepartment;
  String? selectedWorkTitle;

  final List<String> departments = ["Human Resources", "Finance", "IT", "Marketing"];
  final List<String> workTitles = ["Manager", "Engineer", "Assistant", "Intern"];

  late AnimationController _animationController;
  late Animation<Offset> _slideAnimation;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 800),
      vsync: this,
    );
    _slideAnimation = Tween<Offset>(begin: const Offset(0, 1), end: Offset.zero).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.easeInOut),
    );
    _animationController.forward(); // Start the animation when the screen opens
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
            child: SlideTransition(
              position: _slideAnimation,
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
                      _buildTextField("Employee ID", employeeIdController, Icons.badge, "Enter the employee's unique ID."), // New Employee ID input
                      const SizedBox(height: 16),
                      _buildTextField("First Name", firstNameController, Icons.person, "Enter the employee's first name."),
                      const SizedBox(height: 16), // Small space between fields
                      _buildTextField("Last Name", lastNameController, Icons.person_outline, "Enter the employee's last name."),
                      const SizedBox(height: 16),
                      _buildTextField("Email", emailController, Icons.email, "Enter a valid email address."),
                      const SizedBox(height: 16),
                      _buildDropdown("Select Department", departments, Icons.apartment, (value) {
                        setState(() {
                          selectedDepartment = value;
                        });
                      }),
                      const SizedBox(height: 16),
                      _buildDropdown("Select Work Title", workTitles, Icons.work, (value) {
                        setState(() {
                          selectedWorkTitle = value;
                        });
                      }),
                      const SizedBox(height: 24), // Larger space before the button
                      Center(
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
                                selectedDepartment == null ||
                                selectedWorkTitle == null) {
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(content: Text("Please fill all fields before submitting.")),
                              );
                            } else {
                              _showConfirmationDialog();
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
      ),
    );
  }

  Widget _buildTextField(String label, TextEditingController controller, IconData icon, String helperText) {
    return TextField(
      controller: controller,
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

  // Confirmation dialog
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

  // Clear fields after successful submission
  void _clearFields() {
    employeeIdController.clear(); // Clear Employee ID
    firstNameController.clear();
    lastNameController.clear();
    emailController.clear();
    selectedDepartment = null;
    selectedWorkTitle = null;
    setState(() {});
  }
}
