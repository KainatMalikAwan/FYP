import 'package:flutter/material.dart';

class CustomAppBarIconButton extends StatefulWidget {
  final bool isPlusClicked;
  final VoidCallback onTap;
  final IconData icon;

  CustomAppBarIconButton({
    required this.isPlusClicked,
    required this.onTap,
    required this.icon,
  });

  @override
  _CustomAppBarIconButtonState createState() => _CustomAppBarIconButtonState();
}

class _CustomAppBarIconButtonState extends State<CustomAppBarIconButton> {
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: widget.onTap,
      child: Container(
        width: 40.0,
        height: 40.0,
        decoration: BoxDecoration(
          color: widget.isPlusClicked ? Colors.red : Color(0xFF199A8E), // Change color based on isPlusClicked
          shape: BoxShape.circle,
        ),
        child: Center(
          child: Icon(
            widget.icon,
            color: widget.isPlusClicked ? Color(0xFF199A8E) : Colors.white, // Change icon color based on isPlusClicked
          ),
        ),
      ),
    );
  }
}
