import 'package:flutter/material.dart';

// This widget was created to reduce the amount of clutter in login_screen.dart
// You can make a Login Form simply by doing LoginFormField(errorText, label)
// errorText is what will be shown if a user tries to submit without typing
// Label is the label that gets shown on the screen
class LoginFormField extends StatefulWidget {
  const LoginFormField({Key? key, required this.errorText, required this.label}) : super(key: key);
  final String errorText;
  final String label;

  @override
  State<LoginFormField> createState() => _LoginFormFieldState();
}

class _LoginFormFieldState extends State<LoginFormField> {
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(10),
      child: TextFormField(
        validator: (value) {
          if (value == null || value.isEmpty) {
            return widget.errorText;
          }
        },
        decoration: InputDecoration(
          border: const OutlineInputBorder(),
          labelText: widget.label,
        ),
      ),
    );
  }
}
