import 'package:flutter/material.dart';
import 'CustomDropdown.dart';
import 'CustomDateTimeTextBox.dart';
import 'CustomRadioButtons.dart';
import 'SaveCanelButton.dart';

class CustomAddVitalsPopUp extends StatefulWidget {
  final VoidCallback onClose;

  const CustomAddVitalsPopUp({Key? key, required this.onClose})
      : super(key: key);

  @override
  _CustomAddVitalsPopUpState createState() => _CustomAddVitalsPopUpState();
}

class _CustomAddVitalsPopUpState extends State<CustomAddVitalsPopUp> {
  String _selectedVital = 'Sugar'; // Initially selected value
  String _selectedType = '';
  late TextEditingController _controller = TextEditingController();

  @override
  void initState() {
    super.initState();
    _selectedVital = 'BP'; // Set the initial selected value
  }

  @override
  Widget build(BuildContext context) {
    List<String> vitals = ['Sugar', 'BP', 'Temperature'];

    return Container(
      height: MediaQuery.of(context).size.height / 2,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20.0),
      ),
      padding: EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(height: 30),
          Center(
            child: Text(
              _selectedVital.isNotEmpty ? _selectedVital : 'Select a Vital Sign',
              style: TextStyle(
                fontSize: 20.0,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          Container(
            margin: EdgeInsets.symmetric(vertical: 10.0),
            height: 2.0,
            width: double.infinity,
            color: Colors.grey,
          ),
          SizedBox(height: 15),
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                Text(
                  'Select Item',
                  style: TextStyle(
                    fontSize: 19.0,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                SizedBox(width: 30),
                CustomDropdown(
                  vitals: vitals,
                  initialSelectedValue: _selectedVital,
                  onItemSelected: (value) {
                    setState(() {
                      _selectedVital = value;
                    });
                  },
                ),
              ],
            ),
          ),
          SizedBox(height: 10),
          // Display different UI components based on the selected vital sign
          if (_selectedVital == 'Sugar')
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                CustomRadioButtons(
                  types: ['Fasting', 'Random'],
                  onOptionSelected: (value) {
                    setState(() {
                      _selectedType = value;
                    });
                  }, initialSelectedValue: 'Random',
                ),
                SizedBox(height: 10),
                Container(
                  height: 40,
                  decoration: BoxDecoration(
                    color: Colors.grey[200],
                    borderRadius: BorderRadius.circular(15.0),
                    border: Border.all(
                      color: Color(0xFF199A8E),
                    ),
                  ),
                  padding: EdgeInsets.symmetric(horizontal: 12.0),
                  child: TextField(
                    controller: _controller,
                    decoration: InputDecoration(
                      hintText: 'Enter Value',
                      hintStyle: TextStyle(color: Colors.grey[600]),
                      border: InputBorder.none,
                    ),
                  ),
                ),
              ],
            ),
          if (_selectedVital == 'Temperature')
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                CustomRadioButtons(
                  types: const ['Celsius', 'Fahrenheit', 'Kelvin'],
                  onOptionSelected: (value) {
                    setState(() {
                      _selectedType = value;
                    });
                  }, initialSelectedValue: 'Celsius',
                ),
                SizedBox(height: 10),
                Container(
                  height: 40,
                  decoration: BoxDecoration(
                    color: Colors.grey[200],
                    borderRadius: BorderRadius.circular(15.0),
                    border: Border.all(
                      color: Color(0xFF199A8E),
                    ),
                  ),
                  padding: EdgeInsets.symmetric(horizontal: 12.0),
                  child: TextField(
                    controller: _controller,
                    decoration: InputDecoration(
                      hintText: 'Enter Value',
                      hintStyle: TextStyle(color: Colors.grey[600]),
                      border: InputBorder.none,
                    ),
                  ),
                ),
              ],
            ),
          if (_selectedVital == 'BP')
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  height: 40,
                  decoration: BoxDecoration(
                    color: Colors.grey[200],
                    borderRadius: BorderRadius.circular(15.0),
                    border: Border.all(
                      color: Color(0xFF199A8E),
                    ),
                  ),
                  padding: EdgeInsets.symmetric(horizontal: 12.0),
                  child: TextField(
                    controller: _controller,
                    decoration: InputDecoration(
                      hintText: 'Enter Systolic Value',
                      hintStyle: TextStyle(color: Colors.grey[600]),
                      border: InputBorder.none,
                    ),
                  ),
                ),
                SizedBox(height: 10),
                Container(
                  height: 40,
                  decoration: BoxDecoration(
                    color: Colors.grey[200],
                    borderRadius: BorderRadius.circular(15.0),
                    border: Border.all(
                      color: Color(0xFF199A8E),
                    ),
                  ),
                  padding: EdgeInsets.symmetric(horizontal: 12.0),
                  child: TextField(
                    controller: _controller,
                    decoration: InputDecoration(
                      hintText: 'Enter Diastolic Value',
                      hintStyle: TextStyle(color: Colors.grey[600]),
                      border: InputBorder.none,
                    ),
                  ),
                ),
              ],
            ),
          SizedBox(height: 20),
          Align(
            alignment: Alignment.centerRight,
            child: CustomDateTimeTextBox(),
          ),
          SizedBox(height: 10),
          SaveCancelButtons(
            onSave: () {
              // Handle save button press
              print('Save button pressed');
              widget.onClose();
              Navigator.of(context).pop();
              // Add logic to upload data based on the selected vital sign and type
              // Example:
              if (_selectedVital == 'Sugar') {
                // Use _selectedType and _controller.text to upload sugar data
              } else if (_selectedVital == 'Temperature') {
                // Use _selectedType and _controller.text to upload temperature data
              } else if (_selectedVital == 'BP') {
                // Use _controller.text to upload blood pressure data
              }
            },
            onCancel: () {
              // Handle cancel button press
              print('Cancel button pressed');
              widget.onClose();
              Navigator.of(context).pop();
            },
          ),
        ],
      ),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }
}
