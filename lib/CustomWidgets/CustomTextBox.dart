import 'package:flutter/material.dart';

class CustomTextBox extends StatefulWidget {
  final String label;
  final IconData icon;
  final bool isPassword;

  CustomTextBox({required this.label, required this.icon, this.isPassword = false});

  @override
  _CustomTextBoxState createState() => _CustomTextBoxState();
}

class _CustomTextBoxState extends State<CustomTextBox> {
  bool _obscureText = false;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 60,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(30), // Set circular border radius
        border: Border.all(color: Colors.grey),
      ),
      padding: EdgeInsets.symmetric(horizontal: 16),
      child: Row(
        children: [
          Icon(widget.icon),
          SizedBox(width: 10),
          Expanded(
            child: TextField(
              obscureText: widget.isPassword ? _obscureText : false,
              decoration: InputDecoration(
                border: InputBorder.none,
                labelText: widget.label,
              ),
            ),
          ),
          if (widget.isPassword)
            IconButton(
              icon: Icon(_obscureText ? Icons.visibility : Icons.visibility_off),
              onPressed: () {
                setState(() {
                  _obscureText = !_obscureText;
                });
              },
            ),
        ],
      ),
    );
  }
}
