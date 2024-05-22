import 'package:flutter/material.dart';

class CustomDropdown extends StatefulWidget {
  final List<String> vitals;
  final Function(String) onItemSelected;
  final String? initialSelectedValue; // Optional parameter for initial selected value

  CustomDropdown({
    required this.vitals,
    required this.onItemSelected,
    this.initialSelectedValue, // Declare initial selected value as optional
  });

  @override
  _CustomDropdownState createState() => _CustomDropdownState();
}

class _CustomDropdownState extends State<CustomDropdown> {
  late String _selectedVital;

  @override
  void initState() {
    super.initState();
    _selectedVital = widget.initialSelectedValue ?? ''; // Set initial selected value
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 154.0,
      height: 40.0,
      decoration: BoxDecoration(
        color: Colors.grey[300],
        borderRadius: BorderRadius.circular(15.0),
      ),
      child: DropdownButtonHideUnderline(
        child: ButtonTheme(
          alignedDropdown: true,
          child: DropdownButton<String>(
            value: _selectedVital.isNotEmpty ? _selectedVital : null,
            onChanged: (value) {
              setState(() {
                _selectedVital = value!;
                widget.onItemSelected(value);
              });
            },
            items: widget.vitals.map((vital) {
              return DropdownMenuItem<String>(
                value: vital,
                child: Text(
                  vital,
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 19.0,
                    fontWeight: FontWeight.w400,
                  ),
                ),
              );
            }).toList(),
            isExpanded: true,
          ),
        ),
      ),
    );
  }
}
