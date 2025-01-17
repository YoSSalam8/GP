import 'package:flutter/material.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({Key? key}) : super(key: key);

  @override
  _ProfileScreenState createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  TextEditingController searchController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  TextEditingController phoneController = TextEditingController();
  TextEditingController addressController = TextEditingController();
  String? selectedSupervisor;
  String? selectedEmployeeId;

  final List<String> supervisors = ["Alice Johnson", "Bob Williams", "Catherine Smith", "David Brown"];

  final List<Map<String, String>> employees = [
    {"id": "1", "name": "John Doe", "email": "john@example.com", "phone": "123456789", "address": "New York", "supervisor": "Alice Johnson"},
    {"id": "2", "name": "Jane Smith", "email": "jane@example.com", "phone": "987654321", "address": "Los Angeles", "supervisor": "Bob Williams"},
    {"id": "3", "name": "Alice Johnson", "email": "alice@example.com", "phone": "456789123", "address": "Chicago", "supervisor": "Catherine Smith"},
  ];

  List<Map<String, String>> filteredEmployees = [];

  @override
  void initState() {
    super.initState();
    filteredEmployees = employees; // Initially display all employees
  }

  void _filterEmployees(String query) {
    setState(() {
      filteredEmployees = employees.where((employee) {
        final name = employee["name"]!.toLowerCase();
        final email = employee["email"]!.toLowerCase();
        return name.contains(query.toLowerCase()) || email.contains(query.toLowerCase());
      }).toList();
    });
  }

  void _editEmployee(Map<String, String> employee) {
    setState(() {
      selectedEmployeeId = employee["id"];
      emailController.text = employee["email"]!;
      phoneController.text = employee["phone"]!;
      addressController.text = employee["address"]!;
      selectedSupervisor = employee["supervisor"];
    });
  }

  void _saveEmployeeDetails() {
    if (selectedEmployeeId == null) return;
    final index = employees.indexWhere((e) => e["id"] == selectedEmployeeId);
    if (index != -1) {
      setState(() {
        employees[index] = {
          "id": selectedEmployeeId!,
          "name": employees[index]["name"]!,
          "email": emailController.text,
          "phone": phoneController.text,
          "address": addressController.text,
          "supervisor": selectedSupervisor!,
        };
      });
      _showSnackBar("Employee details updated successfully!");
    }
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
          child: ConstrainedBox(
            constraints: BoxConstraints(maxWidth: contentWidth),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Search Bar
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
                // Table to display employees
                Expanded(
                  child: ListView.builder(
                    itemCount: filteredEmployees.length,
                    itemBuilder: (context, index) {
                      final employee = filteredEmployees[index];
                      return Card(
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
                        margin: const EdgeInsets.symmetric(vertical: 8),
                        elevation: 4,
                        child: ListTile(
                          title: Text(
                            employee["name"]!,
                            style: const TextStyle(fontWeight: FontWeight.bold, color: Color(0xFF133E87)),
                          ),
                          subtitle: Text("Supervisor: ${employee["supervisor"]}"),
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
                    },
                  ),
                ),
                const SizedBox(height: 20),
                // Form to edit selected employee details
                if (selectedEmployeeId != null) ...[
                  const Text(
                    "Edit Details",
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Color(0xFF133E87)),
                  ),
                  const SizedBox(height: 10),
                  _buildTextField("Email", "Enter email", emailController),
                  _buildTextField("Phone Number", "Enter phone number", phoneController),
                  _buildTextField("Address", "Enter address", addressController),
                  _buildDropdown("Supervisor", supervisors, selectedSupervisor, (value) {
                    setState(() {
                      selectedSupervisor = value;
                    });
                  }),
                  const SizedBox(height: 20),
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF133E87),
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                    ),
                    onPressed: _saveEmployeeDetails,
                    child: const Center(
                      child: Text(
                        "SAVE CHANGES",
                        style: TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.bold),
                      ),
                    ),
                  ),
                ]
              ],
            ),
          ),
        ),
      ),
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
