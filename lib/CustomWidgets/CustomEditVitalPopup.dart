import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'CustomDropdown.dart';
import 'CustomDateTimeTextBox.dart';
import 'CustomRadioButtons.dart';
import 'SaveCanelButton.dart';

class CustomEditVitalsPopUp extends StatefulWidget {
  final VoidCallback onClose;

  const CustomEditVitalsPopUp({Key? key, required this.onClose}) : super(key: key);

  @override
  _CustomEditVitalsPopUpState createState() => _CustomEditVitalsPopUpState();
}

class _CustomEditVitalsPopUpState extends State<CustomEditVitalsPopUp> {
  String _selectedVital = 'Sugar'; // Initially selected value
  String _selectedType = '';
  late TextEditingController _controller = TextEditingController();
  DateTime? _selectedDate;
  TimeOfDay? _selectedTime;

  @override
  void initState() {
    super.initState();
    _selectedVital = 'BP'; // Set the initial selected value
  }

  Future<void> _selectDate() async {
    DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: _selectedDate ?? DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime(2100),
    );
    if (pickedDate != null) {
      TimeOfDay? pickedTime = await showTimePicker(
        context: context,
        initialTime: _selectedTime ?? TimeOfDay.now(),
      );
      if (pickedTime != null) {
        setState(() {
          _selectedDate = DateTime(
            pickedDate.year,
            pickedDate.month,
            pickedDate.day,
            pickedTime.hour,
            pickedTime.minute,
          );
          _selectedTime = pickedTime;
        });
      }
    }
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
                  },
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
                  types: ['Celsius', 'Fahrenheit', 'Kelvin'],
                  onOptionSelected: (value) {
                    setState(() {
                      _selectedType = value;
                    });
                  },
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
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Date:',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              Row(
                children: [
                  Text(
                    _selectedDate == null
                        ? 'Select Date'
                        : '${_selectedDate!.month}/${_selectedDate!.day}/${_selectedDate!.year} ${_selectedTime!.format(context)}', // Display selected time
                    style: TextStyle(fontSize: 16),
                  ),
                  IconButton(
                    icon: Icon(Icons.edit),
                    onPressed: _selectDate,
                  ),
                ],
              ),
            ],
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

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Custom Edit Vitals Popup',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: HomePage(),
    );
  }
}

class HomePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Custom Edit Vitals Popup Example'),
      ),
      body: Center(
        child: ElevatedButton(
          onPressed: () {
            // Show the custom edit vitals popup
            showDialog(
              context: context,
              builder: (BuildContext context) {
                return Dialog(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20.0),
                  ),
                  elevation: 0.0,
                  backgroundColor: Colors.transparent,
                  child: CustomEditVitalsPopUp(
                    onClose: () {
                      Navigator.of(context).pop(); // Close the dialog
                    },
                  ),
                );
              },
            );
          },
          child: Text('Open Edit Vitals Popup'),
        ),
      ),
    );
  }
}
