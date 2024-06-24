import 'dart:convert';
import 'package:fyp/screens/PHR/Home.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:fyp/Services/config.dart';

class VitalToUplode {
  final int patientId;
  final int vitalsId;
  final List<VitalObservedValue> vitalObservedValues;

  VitalToUplode({
    required this.patientId,
    required this.vitalsId,
    required this.vitalObservedValues,
  });

  Map<String, dynamic> toJson() => {
    'patientId': patientId,
    'vitalsId': vitalsId,
    'vitalObservedValues':
    List<dynamic>.from(vitalObservedValues.map((x) => x.toJson())),
  };
}

class VitalObservedValue {
  final String readingType;
  final double observedValue;

  VitalObservedValue({
    required this.readingType,
    required this.observedValue,
  });

  Map<String, dynamic> toJson() => {
    'readingType': readingType,
    'observedValue': observedValue,
  };
}

Future<String> submitVitalReading(VitalToUplode vital) async {
  final url = Uri.parse('${Config.baseUrl}/measures');
  final String token =
      'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpZCI6NCwicm9sZSI6InBhdGllbnQiLCJpYXQiOjE3MDU4OTAwNjcsImV4cCI6MTcwNTg5MzY2N30.wIcaxoT15SQJM-ghRiqinVnAKnRgwRiqEgLvEUvYzDI';

  final response = await http.post(url,
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
        'Authorization': 'Bearer $token',
      },
      body: jsonEncode(vital.toJson()));

  if (response.statusCode == 200) {
    return jsonDecode(response.body)["message"];
  } else {
    throw Exception('Failed to submit vital reading');
  }
}

class UploadDataScreen extends StatefulWidget {
  @override
  _UploadDataScreenState createState() => _UploadDataScreenState();
}

class _UploadDataScreenState extends State<UploadDataScreen> {
  String _selectedVital = 'Sugar';
  String _selectedReadingType = 'Fasting';
  String _selectedUnit = 'Fahrenheit';

  TextEditingController _systolicController = TextEditingController();
  TextEditingController _diastolicController = TextEditingController();
  TextEditingController _temperatureController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Upload Vitals Data'),
        actions: [
          IconButton(
            icon: Icon(Icons.home),
            onPressed: () {
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(builder: (context) => HomeScreen(token: "akjhgkahe")),
              );
            },
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            DropdownButtonFormField<String>(
              value: _selectedVital,
              onChanged: (newValue) {
                setState(() {
                  _selectedVital = newValue!;
                });
              },
              items: ['Sugar', 'Blood Pressure', 'Temp']
                  .map<DropdownMenuItem<String>>((String value) {
                return DropdownMenuItem<String>(
                  value: value,
                  child: Text(value),
                );
              }).toList(),
              decoration: InputDecoration(
                labelText: 'Select Vital',
              ),
            ),
            SizedBox(height: 16.0),
            if (_selectedVital == 'Sugar')
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  TextFormField(
                    controller: _temperatureController,
                    keyboardType: TextInputType.number,
                    decoration: InputDecoration(
                      labelText: 'Enter Sugar Level',
                    ),
                  ),
                  SizedBox(height: 16.0),
                  Row(
                    children: [
                      Radio(
                        value: 'Fasting',
                        groupValue: _selectedReadingType,
                        onChanged: (value) {
                          setState(() {
                            _selectedReadingType = value.toString();
                          });
                        },
                      ),
                      Text('Fasting'),
                      Radio(
                        value: 'Regular',
                        groupValue: _selectedReadingType,
                        onChanged: (value) {
                          setState(() {
                            _selectedReadingType = value.toString();
                          });
                        },
                      ),
                      Text('Regular'),
                    ],
                  ),
                ],
              ),
            if (_selectedVital == 'Blood Pressure')
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  TextFormField(
                    controller: _systolicController,
                    keyboardType: TextInputType.number,
                    decoration: InputDecoration(
                      labelText: 'Enter Systolic Value',
                    ),
                  ),
                  SizedBox(height: 16.0),
                  TextFormField(
                    controller: _diastolicController,
                    keyboardType: TextInputType.number,
                    decoration: InputDecoration(
                      labelText: 'Enter Diastolic Value',
                    ),
                  ),
                ],
              ),
            if (_selectedVital == 'Temp')
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  TextFormField(
                    controller: _temperatureController,
                    keyboardType: TextInputType.number,
                    decoration: InputDecoration(
                      labelText: 'Enter Temperature Value',
                    ),
                  ),
                  SizedBox(height: 16.0),
                  Row(
                    children: [
                      Radio(
                        value: 'Fahrenheit',
                        groupValue: _selectedUnit,
                        onChanged: (value) {
                          setState(() {
                            _selectedUnit = value.toString();
                          });
                        },
                      ),
                      Text('Fahrenheit'),
                      Radio(
                        value: 'Celsius',
                        groupValue: _selectedUnit,
                        onChanged: (value) {
                          setState(() {
                            _selectedUnit = value.toString();
                          });
                        },
                      ),
                      Text('Celsius'),
                      Radio(
                        value: 'Kelvin',
                        groupValue: _selectedUnit,
                        onChanged: (value) {
                          setState(() {
                            _selectedUnit = value.toString();
                          });
                        },
                      ),
                      Text('Kelvin'),
                    ],
                  ),
                ],
              ),
            SizedBox(height: 16.0),
            ElevatedButton(
              onPressed: () {
                // Implement API call here
                // Use _selectedVital, _selectedReadingType, _selectedUnit
                // and controller values to construct the API request

                // Example:
                if (_selectedVital == 'Sugar') {
                  submitVitalReading(VitalToUplode(
                    patientId: 1,
                    vitalsId: 17, // Assuming 1 is the ID for Sugar
                    vitalObservedValues: [
                      VitalObservedValue(
                        readingType: _selectedReadingType,
                        observedValue: double.parse(
                            _temperatureController.text.trim()),
                      ),
                    ],
                  ));
                } else if (_selectedVital == 'Blood Pressure') {
                  submitVitalReading(VitalToUplode(
                    patientId: 1,
                    vitalsId: 15, // Assuming 2 is the ID for Blood Pressure
                    vitalObservedValues: [
                      VitalObservedValue(
                        readingType: 'Systolic',
                        observedValue: double.parse(
                            _systolicController.text.trim()),
                      ),
                      VitalObservedValue(
                        readingType: 'Diastolic',
                        observedValue: double.parse(
                            _diastolicController.text.trim()),
                      ),
                    ],
                  ));
                } else if (_selectedVital == 'Temp') {
                  submitVitalReading(VitalToUplode(
                    patientId: 1,
                    vitalsId: 16, // Assuming 3 is the ID for Temperature
                    vitalObservedValues: [
                      VitalObservedValue(
                        readingType: _selectedUnit,
                        observedValue: double.parse(
                            _temperatureController.text.trim()),
                      ),
                    ],
                  ));
                }
              },
              child: Text('Upload Data'),
            ),
          ],
        ),
      ),
    );
  }
}

void main() {
  runApp(MaterialApp(
    home: UploadDataScreen(),
  ));
}
