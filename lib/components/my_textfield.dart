import 'package:flutter/material.dart';

class MyTextField extends StatelessWidget {
  final TextEditingController controller;
  final String hintText;
  final bool obscureText;
  final int borderRadius;
  final Color backgroundColor;
  final Color textColor;
  final Color borderColor;

  const MyTextField({
    required this.controller,
    required this.hintText,
    required this.obscureText,
    required this.borderRadius,
    required this.backgroundColor,
    required this.textColor,
    required this.borderColor,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: controller,
      obscureText: obscureText,
      style: TextStyle(color: textColor),
      decoration: InputDecoration(
        enabledBorder: OutlineInputBorder(
          borderSide: BorderSide(color: borderColor),
          borderRadius: BorderRadius.circular(borderRadius.toDouble()),
        ),
        focusedBorder: OutlineInputBorder(
          borderSide: BorderSide(color: borderColor),
          borderRadius: BorderRadius.circular(borderRadius.toDouble()),
        ),
        fillColor: backgroundColor,
        filled: true,
        hintText: hintText,
        hintStyle: TextStyle(color: textColor.withOpacity(0.6)),
      ),
    );
  }
}
