import 'package:flutter/material.dart';

class CustomTextBox extends StatefulWidget {
  final String label;
  final IconData icon;
  final bool isPassword;
  final TextEditingController controller;
  final bool readOnly; // Optional parameter for read-only mode

  CustomTextBox({
    required this.label,
    required this.icon,
    this.isPassword = false,
    required this.controller,
    this.readOnly = false, // Set default to false
  });

  @override
  _CustomTextBoxState createState() => _CustomTextBoxState();
}

class _CustomTextBoxState extends State<CustomTextBox> {
  bool _obscureText = true;

  @override
  void initState() {
    super.initState();
    _obscureText = widget.isPassword; // Initial state based on isPassword
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 60,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(30),
        border: Border.all(color: Colors.grey),
      ),
      padding: EdgeInsets.symmetric(horizontal: 16),
      child: Row(
        children: [
          Icon(widget.icon),
          SizedBox(width: 10),
          Expanded(
            child: TextField(
              controller: widget.controller,
              obscureText: widget.isPassword ? _obscureText : false,
              enabled: !widget.readOnly, // Disable editing if readOnly is true
              decoration: InputDecoration(
                border: InputBorder.none,
                labelText: widget.label,
              ),
            ),
          ),
          if (widget.isPassword)
            IconButton(
              icon: Icon(_obscureText ? Icons.visibility_off : Icons.visibility),
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