import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class EditProfilePage extends StatefulWidget {
  final String companyId;
  final String employeeId;
  final String employeeEmail;
  final String token;

  const EditProfilePage({
    super.key,
    required this.companyId,
    required this.employeeId,
    required this.employeeEmail,
    required this.token,
  });

  @override
  State<EditProfilePage> createState() => _EditProfilePageState();
}

class _EditProfilePageState extends State<EditProfilePage> {
  final _formKey = GlobalKey<FormState>();
  bool _isSaving = false;
  bool _isLoading = true;

  // Controllers
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();
  final TextEditingController _addressController = TextEditingController();
  final TextEditingController _skillsController = TextEditingController();

  // Dropdown selections
  String? selectedJobType;
  String? selectedWorkSchedule;
  List<String> jobTypes = ["FULL_TIME", "PART_TIME", "CONTRACT", "INTERN"];
  List<String> workSchedules = ["SUNDAY_TO_THURSDAY", "FLEXIBLE", "ROTATIONAL"];

  final Color primaryColor = const Color(0xFF133E87);
  final Color accentColor = const Color(0xFF608BC1);
  final Color cardBackgroundColor = Colors.white;

  @override
  void initState() {
    super.initState();
    _fetchEmployeeDetails();
  }

  Future<void> _fetchEmployeeDetails() async {
    final url = 'http://localhost:8080/api/employees/${widget.employeeId}/${widget.employeeEmail}';

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
          _nameController.text = data['name'] ?? '';
          _phoneController.text = data['phoneNumber'] ?? '';
          _addressController.text = data['address'] ?? '';
          _skillsController.text = data['skills'] ?? '';
          selectedJobType = data['type'] ?? jobTypes.first;
          selectedWorkSchedule = data['workScheduleType'] ?? workSchedules.first;
          _isLoading = false;
        });
      } else {
        throw Exception('Failed to fetch employee details. Status: ${response.statusCode}');
      }
    } catch (e) {
      _showDialog("Error", "Failed to fetch employee details: $e");
    }
  }

  Future<void> _saveEmployeeDetails() async {
    if (!_formKey.currentState!.validate()) return;

    final url = 'http://localhost:8080/api/employees/update/${widget.employeeId}/${widget.employeeEmail}';

    final Map<String, dynamic> updatedDetails = {
      "name": _nameController.text,
      "phoneNumber": _phoneController.text,
      "address": _addressController.text,
      "skills": _skillsController.text,
      "type": selectedJobType ?? "FULL_TIME",
      "workScheduleType": selectedWorkSchedule ?? "SUNDAY_TO_THURSDAY",
    };

    try {
      setState(() {
        _isSaving = true;
      });

      final response = await http.put(
        Uri.parse(url),
        headers: {
          "Authorization": "Bearer ${widget.token}",
          "Content-Type": "application/json",
        },
        body: jsonEncode(updatedDetails),
      );

      if (response.statusCode == 200) {
        _showDialog("Success", "Profile updated successfully!");
      } else {
        final message = jsonDecode(response.body)['message'] ?? "Unexpected Error";
        _showDialog("Error", "Failed to update profile: $message");
      }
    } catch (e) {
      _showDialog("Error", "An unexpected error occurred: $e");
    } finally {
      setState(() {
        _isSaving = false;
      });
    }
  }

  void _showDialog(String title, String message) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text(title, style: GoogleFonts.poppins(fontWeight: FontWeight.bold)),
          content: Text(message, style: GoogleFonts.poppins()),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text("OK"),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[200],
      appBar: AppBar(
        title: Text(
          "Edit Profile",
          style: GoogleFonts.poppins(fontSize: 22, fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
        flexibleSpace: Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              colors: [Color(0xFF133E87), Color(0xFF608BC1)],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
          ),
        ),
        elevation: 6,
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : Center(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Card(
            color: cardBackgroundColor,
            elevation: 8,
            shadowColor: Colors.grey.withOpacity(0.4),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16),
            ),
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 24),
              child: Form(
                key: _formKey,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Animate(effects: [FadeEffect(duration: 300.ms)], child: _buildTextField("Full Name", Icons.person, _nameController)),
                    const SizedBox(height: 16),
                    Animate(effects: [FadeEffect(duration: 400.ms)], child: _buildTextField("Phone Number", Icons.phone, _phoneController, isPhone: true)),
                    const SizedBox(height: 16),
                    Animate(effects: [FadeEffect(duration: 500.ms)], child: _buildTextField("Address", Icons.location_on, _addressController)),
                    const SizedBox(height: 16),
                    Animate(effects: [FadeEffect(duration: 600.ms)], child: _buildReadOnlyTextField("Job Type", selectedJobType ?? "FULL_TIME")),
                    const SizedBox(height: 16),
                    Animate(effects: [FadeEffect(duration: 700.ms)], child: _buildReadOnlyTextField("Work Schedule", selectedWorkSchedule ?? "SUNDAY_TO_THURSDAY")),
                    const SizedBox(height: 24),
                    _buildSaveButton(),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildTextField(String label, IconData icon, TextEditingController controller, {bool isPhone = false}) {
    return TextFormField(
      controller: controller,
      keyboardType: isPhone ? TextInputType.phone : TextInputType.text,
      decoration: InputDecoration(
        labelText: label,
        prefixIcon: Icon(icon, color: accentColor),
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
        filled: true,
        fillColor: Colors.grey[100],
      ),
      validator: (value) => value == null || value.isEmpty ? "This field cannot be empty" : null,
    );
  }

  Widget _buildDropdown(String label, List<String> options, String? selected, Function(String?) onChanged) {
    return DropdownButtonFormField<String>(
      value: selected,
      decoration: InputDecoration(labelText: label, border: OutlineInputBorder(borderRadius: BorderRadius.circular(12))),
      items: options.map((option) => DropdownMenuItem(value: option, child: Text(option))).toList(),
      onChanged: onChanged,
    );
  }

  Widget _buildReadOnlyTextField(String label, String value) {
    return TextFormField(
      readOnly: true, // 🔹 Read-Only Field
      decoration: InputDecoration(
        labelText: label,
        prefixIcon: const Icon(Icons.lock, color: Colors.grey),
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
        filled: true,
        fillColor: Colors.grey[300],
      ),
      initialValue: value, // ✅ Use the provided value
    );
  }

  Widget _buildSaveButton() {
    return ElevatedButton(
      onPressed: _isSaving ? null : _saveEmployeeDetails,
      child: _isSaving ? const CircularProgressIndicator(color: Colors.white) : const Text("Save Changes"),
    );
  }
}
