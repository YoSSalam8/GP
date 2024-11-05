import 'package:flutter/material.dart';
import 'package:graduation_project/ui/Login/components/text_field_container.dart';

class RoundedPasswordField extends StatelessWidget {
  final ValueChanged<String> onChanged;
  const RoundedPasswordField({
    super.key, required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return TextFieldContainer(
        child: TextField(
          onChanged: onChanged,
          obscureText: true,
          decoration: InputDecoration(
            hintText: "Password",
            icon: Icon(Icons.lock,
              color: Colors.purple.shade200,),
            suffixIcon: Icon(
              Icons.visibility,
              color: Colors.purple.shade200,
            ),
            border: InputBorder.none,

          ),
        )
    );
  }
}
