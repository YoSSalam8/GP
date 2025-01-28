import 'package:flutter/material.dart';
import 'package:graduation_project/ui/Login/components/text_field_container.dart';

class RoundedPasswordField extends StatefulWidget {
  final ValueChanged<String> onChanged;
  final TextEditingController controller;

  const RoundedPasswordField({
    super.key,
    required this.onChanged,
    required this.controller,
  });

  @override
  State<RoundedPasswordField> createState() => _RoundedPasswordFieldState();
}

class _RoundedPasswordFieldState extends State<RoundedPasswordField> {
  bool _isObscured = true; // State to manage password visibility

  void _toggleVisibility() {
    setState(() {
      _isObscured = !_isObscured; // Toggle visibility
    });
  }

  @override
  Widget build(BuildContext context) {
    return TextFieldContainer(
      child: TextField(
        controller: widget.controller, // Bind controller to password field
        onChanged: widget.onChanged,
        obscureText: _isObscured, // Use the state to control visibility
        decoration: InputDecoration(
          hintText: "Password",
          hintStyle: const TextStyle(color: Colors.black38),
          icon: const Icon(Icons.lock, color: Color(0xFF608BC1)),
          suffixIcon: IconButton(
            icon: Icon(
              _isObscured ? Icons.visibility : Icons.visibility_off,
              color: const Color(0xFF608BC1),
            ),
            onPressed: _toggleVisibility, // Toggle password visibility
          ),
          border: InputBorder.none,
        ),
      ),
    );
  }
}
