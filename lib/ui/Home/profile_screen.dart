import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io'; // For mobile/desktop
import 'dart:typed_data'; // For web
import 'package:flutter/foundation.dart'; // For kIsWeb
import 'model/user.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({Key? key}) : super(key: key);

  @override
  _ProfileScreenState createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> with SingleTickerProviderStateMixin {
  Uint8List? webImage; // For web images
  String? imagePath; // For mobile/desktop images

  TextEditingController emailController = TextEditingController();
  TextEditingController phoneController = TextEditingController();
  TextEditingController addressController = TextEditingController();
  String? selectedSupervisor; // Supervisor field
  final List<String> supervisors = ["Alice Johnson", "Bob Williams", "Catherine Smith", "David Brown"];
  bool isHovering = false; // For web hover effect

  @override
  void initState() {
    super.initState();
    emailController.text = User.email;
    phoneController.text = User.phoneNumber ?? "";
    addressController.text = User.address ?? "";
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

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    bool isWeb = screenWidth > 600;

    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [Colors.grey.shade200, Colors.white],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: Center(
          child: SingleChildScrollView(
            padding: EdgeInsets.symmetric(
              horizontal: isWeb ? screenWidth * 0.2 : 20,
              vertical: 30,
            ),
            child: Card(
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
              elevation: isWeb ? 10 : 5,
              child: Padding(
                padding: const EdgeInsets.all(20),
                child: Column(
                  children: [
                    GestureDetector(
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
                    const SizedBox(height: 20),
                    Text(
                      "Employee ${User.employeeId}",
                      style: const TextStyle(
                        fontFamily: "NexaBold",
                        fontSize: 22,
                        color: Color(0xFF133E87),
                      ),
                    ),
                    const SizedBox(height: 24),
                    _buildSectionCard(
                      child: Column(
                        children: [
                          _buildTextField(
                            "Email",
                            "Enter your email",
                            emailController,
                            icon: Icons.email_outlined,
                          ),
                          const SizedBox(height: 16),
                          _buildTextField(
                            "Phone Number",
                            "Enter your phone number",
                            phoneController,
                            icon: Icons.phone_outlined,
                          ),
                          const SizedBox(height: 16),
                          _buildTextField(
                            "Address",
                            "Enter your address",
                            addressController,
                            icon: Icons.location_on_outlined,
                          ),
                          const SizedBox(height: 16),
                          _buildSearchableDropdown(
                            "Select or Edit Supervisor",
                            supervisors,
                                (value) {
                              setState(() {
                                selectedSupervisor = value;
                              });
                            },
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 16),
                    GestureDetector(
                      onTap: _saveProfile,
                      child: Container(
                        height: 50,
                        width: double.infinity,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10),
                          gradient: const LinearGradient(
                            colors: [Color(0xFF608BC1), Color(0xFF133E87)],
                            begin: Alignment.topLeft,
                            end: Alignment.bottomRight,
                          ),
                        ),
                        child: const Center(
                          child: Text(
                            "SAVE DETAILS",
                            style: TextStyle(
                              color: Colors.white,
                              fontFamily: "NexaBold",
                              fontSize: 16,
                            ),
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 16),
                    ElevatedButton.icon(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF133E87),
                        padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 40),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                      ),
                      onPressed: _showPasswordChangeDialog,
                      icon: const Icon(Icons.lock_outline, color: Colors.white),
                      label: const Text(
                        "CHANGE PASSWORD",
                        style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 16),
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

  Widget _buildTextField(String title, String hint, TextEditingController controller, {IconData? icon}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: const TextStyle(
            fontFamily: "NexaBold",
            fontSize: 16,
            color: Color(0xFF133E87),
          ),
        ),
        const SizedBox(height: 8),
        TextFormField(
          controller: controller,
          cursorColor: Colors.black54,
          decoration: InputDecoration(
            hintText: hint,
            prefixIcon: icon != null ? Icon(icon, color: const Color(0xFF608BC1)) : null,
            filled: true,
            fillColor: Colors.grey.shade100,
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10),
              borderSide: BorderSide(color: Colors.grey.shade400),
            ),
            focusedBorder: OutlineInputBorder(
              borderSide: BorderSide(color: const Color(0xFF608BC1), width: 2),
              borderRadius: BorderRadius.circular(10),
            ),
          ),
        ),
        const SizedBox(height: 16),
      ],
    );
  }

  Widget _buildSearchableDropdown(String label, List<String> items, Function(String?) onChanged) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: const TextStyle(
            fontFamily: "NexaBold",
            fontSize: 16,
            color: Color(0xFF133E87),
          ),
        ),
        const SizedBox(height: 8),
        DropdownButtonFormField<String>(
          isExpanded: true,
          decoration: InputDecoration(
            filled: true,
            fillColor: Colors.grey.shade100,
            prefixIcon: const Icon(Icons.search, color: Color(0xFF608BC1)),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10),
              borderSide: const BorderSide(color: Colors.grey),
            ),
          ),
          hint: const Text("Search for a supervisor"),
          items: items.map((item) {
            return DropdownMenuItem<String>(
              value: item,
              child: Text(item),
            );
          }).toList(),
          onChanged: onChanged,
        ),
      ],
    );
  }

  Widget _buildSectionCard({required Widget child}) {
    return Card(
      elevation: 5,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: child,
      ),
    );
  }

  void _saveProfile() {
    setState(() {
      User.email = emailController.text;
      User.phoneNumber = phoneController.text;
      User.address = addressController.text;
    });
    _showSnackBar("Profile updated successfully!");
  }

  void _showPasswordChangeDialog() {
    TextEditingController currentPasswordController = TextEditingController();
    TextEditingController newPasswordController = TextEditingController();
    TextEditingController confirmPasswordController = TextEditingController();

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
                const Text(
                  "Change Password",
                  style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: Colors.black87),
                ),
                const SizedBox(height: 16),
                _buildTextField("Current Password", "Enter current password", currentPasswordController),
                _buildTextField("New Password", "Enter new password", newPasswordController),
                _buildTextField("Confirm New Password", "Re-enter new password", confirmPasswordController),
                const SizedBox(height: 20),
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF608BC1),
                    padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 40),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                  ),
                  onPressed: () {
                    if (newPasswordController.text != confirmPasswordController.text) {
                      _showSnackBar("Passwords do not match!");
                    } else {
                      Navigator.of(context).pop();
                      _showSnackBar("Password changed successfully!");
                    }
                  },
                  child: const Text("CHANGE PASSWORD", style: TextStyle(color: Colors.white)),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  void _showSnackBar(String text) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        behavior: SnackBarBehavior.floating,
        content: Text(text),
        backgroundColor: const Color(0xFF608BC1),
      ),
    );
  }
}
