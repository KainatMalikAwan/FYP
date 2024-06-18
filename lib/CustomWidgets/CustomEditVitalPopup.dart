import 'package:flutter/material.dart';
import '../models/Vital.dart';
import '../models/VitalObservedValue.dart';
import '../models/Vitals.dart';
import '../screens/PHR/Vitals.dart';
import 'CustomDateTimeTextBox.dart';
import 'CustomRadioButtons.dart';
import 'SaveCanelButton.dart';
import 'package:fyp/Services/API/VitalsService.dart';
import 'package:fyp/models/VitalObservedValue.dart';
import 'package:fyp/models/VitalsMeasure.dart';
import 'package:intl/intl.dart';

final VitalsServices _obj = VitalsServices();

class CustomEditVitalsPopUp extends StatefulWidget {
  final VoidCallback onClose;
  final Vital vitaltoedit;

  const CustomEditVitalsPopUp({Key? key, required this.onClose, required this.vitaltoedit}) : super(key: key);

  @override
  _CustomEditVitalsPopUpState createState() => _CustomEditVitalsPopUpState();
}

class _CustomEditVitalsPopUpState extends State<CustomEditVitalsPopUp> {
  late TextEditingController _controller1;
  late TextEditingController _controller2;
  DateTime? _selectedDate;
  TimeOfDay? _selectedTime;

  @override
  void initState() {
    super.initState();
    _controller1 = TextEditingController(text: widget.vitaltoedit.vitalObservedValue[0].observedValue.toString());
    _selectedDate = widget.vitaltoedit.time;
    _selectedTime = TimeOfDay.fromDateTime(widget.vitaltoedit.time);

    if (widget.vitaltoedit.vitals.name == 'Blood Pressure') {
      _controller2 = TextEditingController(text: widget.vitaltoedit.vitalObservedValue[1].observedValue.toString());
    }
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

  void _saveVitalMeasure() {
    int vitalMeasureId = widget.vitaltoedit.id;
    DateTime time = _selectedDate!; // The selected date and time

    List<VitalObservedValue> vitalObservedValues = [];
    if (widget.vitaltoedit.vitals.name == 'Sugar' || widget.vitaltoedit.vitals.name == 'Temp') {
      vitalObservedValues.add(VitalObservedValue(
        id: widget.vitaltoedit.vitalObservedValue[0].id,
        observedValue: int.parse(_controller1.text),
        vitalsMeasureId: vitalMeasureId,
        readingType: widget.vitaltoedit.vitalObservedValue[0].readingType,
      ));
    } else if (widget.vitaltoedit.vitals.name == 'Blood Pressure') {
      vitalObservedValues.add(VitalObservedValue(
        id: widget.vitaltoedit.vitalObservedValue[0].id,
        observedValue: int.parse(_controller1.text),
        vitalsMeasureId: vitalMeasureId,
        readingType: widget.vitaltoedit.vitalObservedValue[0].readingType,
      ));
      vitalObservedValues.add(VitalObservedValue(
        id: widget.vitaltoedit.vitalObservedValue[1].id,
        observedValue: int.parse(_controller2.text),
        vitalsMeasureId: vitalMeasureId,
        readingType: widget.vitaltoedit.vitalObservedValue[1].readingType,
      ));
    }

    VitalsMeasure vitalmeasure = VitalsMeasure(
      vitalsMeasureId: vitalMeasureId,
      time: time,
      vitalObservedValues: vitalObservedValues,
    );

    try {
      _obj.updateMeasure(vitalmeasure);
    } catch (e) {
      print('Error updating VitalsMeasure: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
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
            widget.vitaltoedit.vitals.name.isNotEmpty ? widget.vitaltoedit.vitals.name : 'Select a Vital Sign',
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
        if (widget.vitaltoedit.vitals.name == "Sugar")
    Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        CustomRadioButtons(
          types: ['Fasting', 'Regular'],
          onOptionSelected: (value) {
            // Handle selection change if needed
          },
          initialSelectedValue: widget.vitaltoedit.vitalObservedValue[0].readingType,
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
            controller: _controller1,
            decoration: InputDecoration(
              hintText: 'Enter Value',
              hintStyle: TextStyle(color: Colors.grey[600]),
              border: InputBorder.none,
            ),
          ),
        ),
      ],
    ),
    if (widget.vitaltoedit.vitals.name == "Temp")
    Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
    CustomRadioButtons(
    types: ['Celsius', 'Fahrenheit', 'Kelvin'],
    onOptionSelected: (value) {
    // Handle selection change if needed
    },
    initialSelectedValue: widget.vitaltoedit.vitalObservedValue[0].readingType,
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
    controller: _controller1,
    decoration: InputDecoration(
    hintText: 'Enter Value',
    hintStyle: TextStyle(color: Colors.grey[600]),
    border: InputBorder.none,
    ),
    ),
    ),
    ],
    ),
    if (widget.vitaltoedit.vitals.name == "Blood Pressure")
    Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      Text(
        'Systolic Value',
        style: TextStyle(
          fontSize: 16,
          fontWeight: FontWeight.bold,
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
    child: Row(
    children: [
    Expanded(
    child: TextField(
    controller: _controller1,
    decoration: InputDecoration(

    hintText: 'Enter Diastolic Value',
    hintStyle: TextStyle(color: Colors.grey[600]),
    border: InputBorder.none,
    ),
    ),
    ),
    SizedBox(width: 15),
    Text(
    'mmHg',
    style: TextStyle(fontSize: 16),
    ),
    ],
    ),
    ),
    SizedBox(height: 15),
      Text(
        'Diastolic Value',
        style: TextStyle(
          fontSize: 16,
          fontWeight: FontWeight.bold,
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
    child: Row(
    children: [
    Expanded(

    child: TextField(
    controller: _controller2,
    decoration: InputDecoration(

    hintText: 'Enter Diastolic Value',
    hintStyle: TextStyle(color: Colors.grey[600]),
    border: InputBorder.none,
    ),
    ),
    ),
    SizedBox(width: 10),
    Text(
    'mmHg',
    style: TextStyle(fontSize: 16),
    ),
    ],
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
    _selectedDate != null
    ? '${_selectedDate!.month}/${_selectedDate!.day}/${_selectedDate!.year} ${DateFormat.jm().format(_selectedDate!)}'
        : 'No date selected',
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
                  _saveVitalMeasure();
                  widget.onClose();
                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(builder: (context) => VitalsScreen()), // Navigate to VitalsScreen
                  );
                },
                onCancel: () {
                  // Handle cancel button press
                  print('Cancel button pressed');
                  widget.onClose();
                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(builder: (context) => VitalsScreen()), // Navigate to VitalsScreen
                  );
                },
              ),
            ],
        ),
    );
  }

  @override
  void dispose() {
    _controller1.dispose();
    if (widget.vitaltoedit.vitals.name == 'Blood Pressure') {
      _controller2.dispose();
    }
    super.dispose();
  }
}
