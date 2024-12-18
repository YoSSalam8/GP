import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';
import 'model/user.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({Key? key}) : super(key: key);

  @override
  _ProfileScreenState createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  double screenHeight = 0;
  double screenWidth = 0;

  final Color primaryColor = const Color(0xFF608BC1);
  final Color accentColor = const Color(0xFF133E87);

  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();

  void pickUploadProfilePic() async {
    final image = await ImagePicker().pickImage(
      source: ImageSource.gallery,
      maxHeight: 512,
      maxWidth: 512,
      imageQuality: 90,
    );

    if (image != null) {
      setState(() {
        User.profilePicLink = image.path; // Using local path for demonstration
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    screenHeight = MediaQuery.of(context).size.height;
    screenWidth = MediaQuery.of(context).size.width;

    return Scaffold(
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            GestureDetector(
              onTap: pickUploadProfilePic,
              child: Container(
                margin: const EdgeInsets.only(top: 40, bottom: 24),
                height: 120,
                width: 120,
                alignment: Alignment.center,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(70),
                  color: accentColor,
                  boxShadow: const [
                    BoxShadow(
                      color: Colors.black26,
                      blurRadius: 10,
                      offset: Offset(2, 2),
                    ),
                  ],
                ),
                child: Center(
                  child: User.profilePicLink == " "
                      ? const Icon(
                    Icons.person,
                    color: Colors.white,
                    size: 80,
                  )
                      : ClipRRect(
                    borderRadius: BorderRadius.circular(60),
                    child: Image.file(
                      File(User.profilePicLink),
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
              ),
            ),
            Align(
              alignment: Alignment.center,
              child: Text(
                "Employee ${User.employeeId}",
                style: TextStyle(
                  fontFamily: "NexaBold",
                  fontSize: 18,
                  color: accentColor,
                ),
              ),
            ),
            const SizedBox(height: 24),
            _buildTextField("Email", "Enter your email", emailController),
            _buildTextField("Password", "Enter your password", passwordController),
            const SizedBox(height: 16),
            GestureDetector(
              onTap: _saveProfile,
              child: Container(
                height: kToolbarHeight,
                width: screenWidth,
                margin: const EdgeInsets.only(bottom: 12),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(8),
                  color: primaryColor,
                ),
                child: const Center(
                  child: Text(
                    "SAVE",
                    style: TextStyle(
                      color: Colors.white,
                      fontFamily: "NexaBold",
                      fontSize: 16,
                    ),
                  ),
                ),
              ),
            ),
          ],
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
          style: TextStyle(
            fontFamily: "NexaBold",
            color: accentColor,
            fontSize: 16,
          ),
        ),
        const SizedBox(height: 8),
        Container(
          margin: const EdgeInsets.only(bottom: 16),
          child: TextFormField(
            controller: controller,
            cursorColor: Colors.black54,
            maxLines: 1,
            decoration: InputDecoration(
              hintText: hint,
              hintStyle: const TextStyle(
                color: Colors.black54,
                fontFamily: "NexaBold",
              ),
              enabledBorder: OutlineInputBorder(
                borderSide: BorderSide(
                  color: accentColor.withOpacity(0.7),
                ),
                borderRadius: BorderRadius.circular(8),
              ),
              focusedBorder: OutlineInputBorder(
                borderSide: BorderSide(
                  color: primaryColor,
                  width: 2,
                ),
                borderRadius: BorderRadius.circular(8),
              ),
            ),
          ),
        ),
      ],
    );
  }

  void _saveProfile() {
    String email = emailController.text;
    String password = passwordController.text;

    if (email.isEmpty) {
      _showSnackBar("Please enter your email!");
    } else if (password.isEmpty) {
      _showSnackBar("Please enter your password!");
    } else {
      setState(() {
        User.email = email;
        User.password = password;
      });
      _showSnackBar("Profile updated successfully!");
    }
  }

  void _showSnackBar(String text) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        behavior: SnackBarBehavior.floating,
        content: Text(text),
        backgroundColor: primaryColor,
      ),
    );
  }
}
