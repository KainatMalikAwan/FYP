import 'package:flutter/material.dart';

class CustomRadioButtons extends StatefulWidget {
  final List<String> types;
  final String? initialSelectedValue;
  final Function(String) onOptionSelected;

  CustomRadioButtons({required this.types, required this.onOptionSelected,required this.initialSelectedValue});

  @override
  _CustomRadioButtonsState createState() => _CustomRadioButtonsState();
}

class _CustomRadioButtonsState extends State<CustomRadioButtons> {
  String _selectedType = '';
  @override
  void initState() {
    super.initState();
    _selectedType = widget.initialSelectedValue!;
  }
  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 16.0),
        child: Row(
          children: widget.types.map((type) {
            return Row(
              children: [
                Text(
                  type,
                  style: TextStyle(
                    fontSize: 19.0,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                Radio(
                  value: type,
                  groupValue: _selectedType,
                  onChanged: (value) {
                    setState(() {
                      _selectedType = value.toString();
                      widget.onOptionSelected(value.toString());
                    });
                  },
                  activeColor: Color(0xFF199A8E), // Specified color for the radio button
                ),
              ],
            );
          }).toList(),
        ),
      ),
    );
  }
}
