import 'package:flutter/material.dart';
import 'package:graduation_project/ui/Login/components/text_field_container.dart';

class RoundedPasswordField extends StatelessWidget {
  final ValueChanged<String> onChanged;
  final TextEditingController controller; // Add controller

  const RoundedPasswordField({
    super.key,
    required this.onChanged,
    required this.controller, // Make controller required
  });

  @override
  Widget build(BuildContext context) {
    return TextFieldContainer(
      child: TextField(
        controller: controller, // Bind controller to password field
        onChanged: onChanged,
        obscureText: true,
        decoration: const InputDecoration(
          hintText: "Password",
          hintStyle: TextStyle(color: Colors.black38),
          icon: Icon(Icons.lock, color: Color(0xFF608BC1)),
          suffixIcon: Icon(Icons.visibility, color: Color(0xFF608BC1)),
          border: InputBorder.none,
        ),
      ),
    );
  }
}
