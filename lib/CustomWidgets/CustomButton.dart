import 'package:flutter/material.dart';

class CustomButton extends StatelessWidget {
  final String text;
  final VoidCallback onPressed;
  final Color color;

  CustomButton({required this.text, required this.onPressed, required this.color});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 60, // Same height as CustomTextBox
      decoration: BoxDecoration(
        color: color, // Set the background color
        borderRadius: BorderRadius.circular(30), // Circular border radius
      ),
      child: TextButton(
        onPressed: onPressed,
        child: Text(
          text,
          style: TextStyle(color: Colors.white), // Text color
        ),
      ),
    );
  }
}
