import 'package:flutter/material.dart';
import 'package:graduation_project/ui/Login/components/text_field_container.dart';

class RoundedPasswordField extends StatelessWidget {
  final ValueChanged<String> onChanged;

  const RoundedPasswordField({
    super.key,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return TextFieldContainer(
      child: TextField(
        onChanged: onChanged,
        obscureText: true,
        decoration: InputDecoration(
          hintText: "Password",
          hintStyle: const TextStyle(
            color: Colors.black38, // Subtle hint text color
          ),
          icon: const Icon(
            Icons.lock,
            color: Color(0xFF608BC1), // Matches the palette
          ),
          suffixIcon: const Icon(
            Icons.visibility,
            color: Color(0xFF608BC1), // Matches the palette
          ),
          border: InputBorder.none,
        ),
      ),
    );
  }
}
