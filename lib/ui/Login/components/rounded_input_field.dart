import 'package:flutter/material.dart';
import 'package:graduation_project/ui/Login/components/text_field_container.dart';

class RoundedInputField extends StatelessWidget {
  final String hintText;
  final IconData icon;
  final ValueChanged<String> onChanged;

  const RoundedInputField({
    super.key,
    required this.hintText,
    this.icon = Icons.person,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return TextFieldContainer(
      child: TextField(
        onChanged: onChanged,
        decoration: InputDecoration(
          border: InputBorder.none,
          hintText: hintText,
          hintStyle: const TextStyle(
            color: Colors.black38, // Subtle hint color
          ),
          icon: Icon(
            icon,
            color: const Color(0xFF608BC1), // Matches your palette
          ),
        ),
      ),
    );
  }
}
