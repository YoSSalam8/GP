import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';
import 'package:intl/intl.dart';
import 'model/user.dart'; // Importing the User class

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({Key? key}) : super(key: key);

  @override
  _ProfileScreenState createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  double screenHeight = 0;
  double screenWidth = 0;
  Color primary = Colors.purple.shade500;
  String birth = "Date of birth";

  TextEditingController firstNameController = TextEditingController();
  TextEditingController lastNameController = TextEditingController();
  TextEditingController addressController = TextEditingController();

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
              onTap: () {
                pickUploadProfilePic();
              },
              child: Container(
                margin: const EdgeInsets.only(top: 80, bottom: 24),
                height: 120,
                width: 120,
                alignment: Alignment.center,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(20),
                  color: primary,
                ),
                child: Center(
                  child: User.profilePicLink == " "
                      ? const Icon(
                    Icons.person,
                    color: Colors.white,
                    size: 80,
                  )
                      : ClipRRect(
                    borderRadius: BorderRadius.circular(20),
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
                style: const TextStyle(
                  fontFamily: "NexaBold",
                  fontSize: 18,
                ),
              ),
            ),
            const SizedBox(height: 24),
            User.canEdit
                ? textField("First Name", "First name", firstNameController)
                : field("First Name", User.firstName),
            User.canEdit
                ? textField("Last Name", "Last name", lastNameController)
                : field("Last Name", User.lastName),
            User.canEdit
                ? GestureDetector(
              onTap: () {
                showDatePicker(
                  context: context,
                  initialDate: DateTime.now(),
                  firstDate: DateTime(1950),
                  lastDate: DateTime.now(),
                  builder: (context, child) {
                    return Theme(
                      data: Theme.of(context).copyWith(
                        colorScheme: ColorScheme.light(
                          primary: primary,
                          secondary: primary,
                          onSecondary: Colors.white,
                        ),
                        textButtonTheme: TextButtonThemeData(
                          style: TextButton.styleFrom(
                            foregroundColor: primary,
                          ),
                        ),
                        textTheme: const TextTheme(
                          headlineMedium: TextStyle(
                            fontFamily: "NexaBold",
                          ),
                          labelSmall: TextStyle(
                            fontFamily: "NexaBold",
                          ),
                          labelLarge: TextStyle(
                            fontFamily: "NexaBold",
                          ),
                        ),
                      ),
                      child: child!,
                    );
                  },
                ).then((value) {
                  if (value != null) {
                    setState(() {
                      birth = DateFormat("MM/dd/yyyy").format(value);
                    });
                  }
                });
              },
              child: field("Date of Birth", birth),
            )
                : field("Date of Birth", User.birthDate),
            User.canEdit
                ? textField("Address", "Address", addressController)
                : field("Address", User.address),
            User.canEdit
                ? GestureDetector(
              onTap: () {
                String firstName = firstNameController.text;
                String lastName = lastNameController.text;
                String birthDate = birth;
                String address = addressController.text;

                if (firstName.isEmpty) {
                  showSnackBar("Please enter your first name!");
                } else if (lastName.isEmpty) {
                  showSnackBar("Please enter your last name!");
                } else if (birthDate == "Date of birth") {
                  showSnackBar("Please enter your birth date!");
                } else if (address.isEmpty) {
                  showSnackBar("Please enter your address!");
                } else {
                  setState(() {
                    User.canEdit = false;
                    User.firstName = firstName;
                    User.lastName = lastName;
                    User.birthDate = birthDate;
                    User.address = address;
                  });
                  showSnackBar("Profile updated successfully!");
                }
              },
              child: Container(
                height: kToolbarHeight,
                width: screenWidth,
                margin: const EdgeInsets.only(bottom: 12),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(4),
                  color: primary,
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
            )
                : const SizedBox(),
          ],
        ),
      ),
    );
  }

  Widget field(String title, String text) {
    return Column(
      children: [
        Align(
          alignment: Alignment.centerLeft,
          child: Text(
            title,
            style: const TextStyle(
              fontFamily: "NexaBold",
              color: Colors.black87,
            ),
          ),
        ),
        Container(
          height: kToolbarHeight,
          width: screenWidth,
          margin: const EdgeInsets.only(bottom: 12),
          padding: const EdgeInsets.only(left: 11),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(4),
            border: Border.all(
              color: Colors.black54,
            ),
          ),
          child: Align(
            alignment: Alignment.centerLeft,
            child: Text(
              text,
              style: const TextStyle(
                color: Colors.black54,
                fontFamily: "NexaBold",
                fontSize: 16,
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget textField(String title, String hint, TextEditingController controller) {
    return Column(
      children: [
        Align(
          alignment: Alignment.centerLeft,
          child: Text(
            title,
            style: const TextStyle(
              fontFamily: "NexaBold",
              color: Colors.black87,
            ),
          ),
        ),
        Container(
          margin: const EdgeInsets.only(bottom: 12),
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
              enabledBorder: const OutlineInputBorder(
                borderSide: BorderSide(
                  color: Colors.black54,
                ),
              ),
              focusedBorder: const OutlineInputBorder(
                borderSide: BorderSide(
                  color: Colors.black54,
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }

  void showSnackBar(String text) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        behavior: SnackBarBehavior.floating,
        content: Text(
          text,
        ),
      ),
    );
  }
}
