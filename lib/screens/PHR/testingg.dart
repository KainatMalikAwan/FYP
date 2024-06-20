import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;

import '../../CustomWidgets/CustomDropdown.dart';
import '../../models/Vital.dart';
import '../../CustomWidgets/CustomRadioButtons.dart';
import 'package:fyp/Services/config.dart';
import 'Graphs.dart';

void main() {
  runApp(MaterialApp(
    home: VitalsGraphScreen(),
  ));
}

class VitalsGraphScreen extends StatefulWidget {
  @override
  _VitalsGraphScreenState createState() => _VitalsGraphScreenState();
}

class _VitalsGraphScreenState extends State<VitalsGraphScreen> {
  late List<Vital> vitals = [];
  late List<Vital> allVitals = [];
  String selectedFilter = 'All';
  DateTime? fromDate;
  DateTime? toDate;

  String _selectedVital = 'Sugar'; // Initially selected vital
  String token = '';

  // Reading type variables
  String _sugarReadingType = 'Random';
  String _bpReadingType = 'Systolic';
  String _tempReadingType = 'Fahrenheit';

  // for building graph
  List<DateTime> dates = [DateTime(2010, 5, 19)];
  List<int> valueList1 = [1];
  List<int> valueList2 = [1];
  String valueType = '';
  String value2Type = 'Diastolic';
  String valueUnits = 'mmHg';

  @override
  void initState() {
    super.initState();
    fetchData();
  }

  Future<void> fetchData() async {
    final String baseURL = Config.baseUrl;
    final prefs = await SharedPreferences.getInstance();
    final int? patientId = prefs.getInt('userId');
    token = prefs.getString('token')!;

    try {
      final response = await http.get(
        Uri.parse('$baseURL/measures/patient/$patientId'),
        headers: {
          'Authorization': 'Bearer $token',
          'Content-Type': 'application/json',
        },
      );

      if (response.statusCode == 200) {
        final List<dynamic> responseData = jsonDecode(response.body)['data'];
        allVitals = responseData.map((data) => Vital.fromJson(data)).toList();

        setState(() {
          vitals = _filterVitals(); // Initial filter to set up the UI
        });
      } else {
        throw Exception('Failed to fetch Measures of Patient: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Failed to fetch Measures of Patient: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        padding: EdgeInsets.all(16.0),
        child: Center(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              SizedBox(height: 20),
              // Select Vital dropdown
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(height: 20),
                  // Horizontally scrollable row for vital selection and reading type
                  SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: Row(
                      children: [
                        // Selected vital
                        Text(
                          '$_selectedVital ',
                          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                        ),

                        // Reading type based on selected vital
                        _buildReadingTypeWidget(),
                      ],
                    ),
                  ),
                  SizedBox(width: 40),
                  DropdownButton<String>(
                    value: _selectedVital,
                    items: ['Sugar', 'Blood Pressure', 'Temp'].map((String value) {
                      return DropdownMenuItem<String>(
                        value: value,
                        child: Text(value),
                      );
                    }).toList(),
                    onChanged: (String? value) {
                      setState(() {
                        _selectedVital = value!;
                        fromDate = null; // Reset fromDate when vital changes
                        toDate = null; // Reset toDate when vital changes
                        vitals = _filterVitals(); // Update filtered vitals immediately
                      });
                    },
                  ),
                ],
              ),
              SizedBox(height: 20),
              // Select Reading Type radios
              _buildReadingTypeSelection(),
              SizedBox(height: 20),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  ElevatedButton(
                    onPressed: () {
                      _selectFromDate(context);
                    },
                    child: Text(fromDate == null
                        ? 'Select From Date'
                        : 'From: ${DateFormat('dd MMM yyyy').format(fromDate!)}'),
                  ),
                  ElevatedButton(
                    onPressed: () {
                      _selectToDate(context);
                    },
                    child: Text(toDate == null
                        ? 'Select To Date'
                        : 'To: ${DateFormat('dd MMM yyyy').format(toDate!)}'),
                  ),
                ],
              ),
              SizedBox(height: 20),
              ElevatedButton(
                onPressed: () {
                  setState(() {
                    vitals = _filterVitals();
                    // _PoplateGraphLists(vitals); // Removed from here
                  });
                },
                child: Text('Display'),
              ),
              SizedBox(height: 20),
              _buildChart(),
              _buildDataList(vitals),
              // Moved _buildChart here
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildReadingTypeWidget() {
    // Return widget based on selected vital
    switch (_selectedVital) {
      case 'Sugar':
        return Text(
          '($_sugarReadingType)',
          style: TextStyle(fontSize: 16),
        );
      case 'Temp':
        return Text(
          '($_tempReadingType)',
          style: TextStyle(fontSize: 16),
        );
      case 'Blood Pressure':
        return Text(
          '($_bpReadingType)',
          style: TextStyle(fontSize: 16),
        );
      default:
        return SizedBox.shrink();
    }
  }

  Widget _buildReadingTypeSelection() {
    // Build radio buttons based on selected vital
    if (_selectedVital == 'Sugar') {
      return SugarReadingTypeRadioButtons(
        selectedType: _sugarReadingType,
        onTypeSelected: (value) {
          setState(() {
            _sugarReadingType = value;
            _PoplateGraphLists(_filterVitals()); // Call _PoplateGraphLists here with filtered vitals
          });
        },
      );
    } else if (_selectedVital == 'Temp') {
      return TemperatureReadingTypeRadioButtons(
        selectedType: _tempReadingType,
        onTypeSelected: (value) {
          setState(() {
            _tempReadingType = value;
            _PoplateGraphLists(_filterVitals()); // Call _PoplateGraphLists here with filtered vitals
          });
        },
      );
    } else if (_selectedVital == 'Blood Pressure') {
      return BloodPressureReadingTypeRadioButtons(
        selectedType: _bpReadingType,
        onTypeSelected: (value) {
          setState(() {
            _bpReadingType = value;
            _PoplateGraphLists(_filterVitals()); // Call _PoplateGraphLists here with filtered vitals
          });
        },
      );
    } else {
      return SizedBox.shrink(); // Return empty widget if no vital is selected
    }
  }

  void _selectFromDate(BuildContext context) async {
    final DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: fromDate ?? DateTime.now(),
      firstDate: DateTime(1900),
      lastDate: DateTime.now(),
    );

    if (pickedDate != null && pickedDate != fromDate) {
      setState(() {
        fromDate = pickedDate;
      });
    }
  }

  void _selectToDate(BuildContext context) async {
    final DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: toDate ?? DateTime.now(),
      firstDate: DateTime(1900),
      lastDate: DateTime.now(),
    );

    if (pickedDate != null && pickedDate != toDate) {
      setState(() {
        toDate = pickedDate;
      });
    }
  }

  void _PoplateGraphLists(List<Vital> filteredVitals) {
    dates = [];
    valueList1 = [];
    valueList2 = [];
    valueType = '';
    valueUnits = '';

    filteredVitals.forEach((vital) {
      final formattedDate = DateTime(vital.time.year, vital.time.month, vital.time.day);
      dates.add(formattedDate);

      if (vital.vitalObservedValue.isNotEmpty) {
        final observedValue1 = vital.vitalObservedValue[0];
        valueList1.add(observedValue1.observedValue);

        switch (vital.vitals.name) {
          case 'Sugar':
            valueType = observedValue1.readingType;
            valueUnits = 'mg/dl';
            break;
          case 'Temp':
            valueType = observedValue1.readingType;
            valueUnits = '°C';
            break;
          case 'Blood Pressure':
            valueType = observedValue1.readingType;
            valueUnits = 'mmHg';

            // If the vital is Blood Pressure, check for the second observed value
            if (vital.vitalObservedValue.length > 1) {
              final observedValue2 = vital.vitalObservedValue[1];
              valueList2.add(observedValue2.observedValue);
              value2Type = observedValue2.readingType;
            } else {
              // Clear valueList2 and value2Type if there is no second observed value
              valueList2 = [];
              value2Type = '';
            }
            break;
          default:
            valueType = observedValue1.readingType;
            valueUnits = '';
            break;
        }
      }
    });

    print(dates);
    print(valueList1);
    print(valueList2);
    print(valueUnits);
    print(valueType);
    print(value2Type);
    setState(() {}); // Call setState to update the UI after populating graph lists
  }

  List<Vital> _filterVitals() {
    List<Vital> filteredVitals = allVitals;

    filteredVitals = filteredVitals.where((vital) => vital.vitals.name == _selectedVital).toList();

    switch (_selectedVital) {
      case 'Sugar':
        filteredVitals = filteredVitals.where((vital) {
          return vital.vitalObservedValue.any((value) {
            return value.readingType.trim() == _sugarReadingType.trim();
          });
        }).toList();
        break;
      case 'Temp':
        filteredVitals = filteredVitals.where((vital) {
          return vital.vitalObservedValue.any((value) {
            return value.readingType.trim() == _tempReadingType.trim();
          });
        }).toList();
        break;
      case 'Blood Pressure':
        filteredVitals = filteredVitals.where((vital) {
          return vital.vitalObservedValue.any((value) {
            return value.readingType.trim() == _bpReadingType.trim();
          });
        }).toList();
        break;
      default:
        break;
    }

    if (fromDate != null && toDate != null) {
      filteredVitals = filteredVitals.where((vital) =>
      vital.time.isAfter(fromDate!) && vital.time.isBefore(toDate!)).toList();
    } else if (fromDate != null) {
      filteredVitals = filteredVitals.where((vital) =>
      vital.time.isAfter(fromDate!) || vital.time.isAtSameMomentAs(fromDate!)).toList();
    } else if (toDate != null) {
      filteredVitals = filteredVitals.where((vital) =>
      vital.time.isBefore(toDate!) || vital.time.isAtSameMomentAs(toDate!)).toList();
    }


    for (var vital in filteredVitals) {
      print("Vital: ${vital.vitals.name}, Date: ${vital.time}, Observed Values: ${vital.vitalObservedValue.map((v) => v.observedValue).toList()}, Reading Types: ${vital.vitalObservedValue.map((v) => v.readingType).toList()}");
    }
    _PoplateGraphLists(filteredVitals); // Call _PoplateGraphLists with filtered vitals here
    return filteredVitals;
  }

  Widget _buildChart() {
    if (valueList1.isEmpty && _selectedVital != 'Blood Pressure') {
      return Text('No data to display on chart');
    }

    if ((valueList1.isEmpty || valueList2.isEmpty) && _selectedVital == 'Blood Pressure') {
      return Text('No data to display on chart');
    }

    String units = _selectedVital == 'Sugar'
        ? 'mg/dl'
        : _selectedVital == 'Temp'
        ? '°F'
        : _selectedVital == 'Blood Pressure'
        ? 'mmHg'
        : '';

    return CustomGraphWidget(
      dates: dates,
      measuredValues: [valueList1, if (_selectedVital == 'Blood Pressure') valueList2],
      valueTypes: [valueType, if (_selectedVital == 'Blood Pressure') value2Type],
      valueUnits: [units],
    );
  }

  Widget _buildDataList(List<Vital> filteredVitals) {
    return Container(
      height: 300,
      child: ListView.builder(
        itemCount: filteredVitals.length,
        itemBuilder: (context, index) {
          final vital = filteredVitals[index];
          final observedValue = vital.vitalObservedValue.isNotEmpty
              ? vital.vitalObservedValue[0]
              : null;

          return ListTile(
            title: Text('${vital.time.day}/${vital.time.month}/${vital.time.year}'),
            subtitle: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Vital: ${vital.vitals.name}'),
                Text('Type: ${observedValue != null ? observedValue.readingType : 'Unknown'}'),
                Text('Value: ${observedValue != null ? observedValue.observedValue.toString() : 'N/A'}'),
              ],
            ),
          );
        },
      ),
    );
  }
}

class SugarReadingTypeRadioButtons extends StatelessWidget {
  final String selectedType;
  final ValueChanged<String> onTypeSelected;

  const SugarReadingTypeRadioButtons({
    required this.selectedType,
    required this.onTypeSelected,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        CustomRadioButtons(
          types: ['Fasting', 'Random'],
          onOptionSelected: onTypeSelected,
          initialSelectedValue: selectedType,
        ),
      ],
    );
  }
}

class TemperatureReadingTypeRadioButtons extends StatelessWidget {
  final String selectedType;
  final ValueChanged<String> onTypeSelected;

  const TemperatureReadingTypeRadioButtons({
    required this.selectedType,
    required this.onTypeSelected,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        CustomRadioButtons(
          types: ['Celsius', 'Fahrenheit', 'Kelvin'],
          onOptionSelected: onTypeSelected,
          initialSelectedValue: selectedType,
        ),
      ],
    );
  }
}

class BloodPressureReadingTypeRadioButtons extends StatelessWidget {
  final String selectedType;
  final ValueChanged<String> onTypeSelected;

  const BloodPressureReadingTypeRadioButtons({
    required this.selectedType,
    required this.onTypeSelected,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        CustomRadioButtons(
          types: ['Systolic', 'Diastolic'],
          onOptionSelected: onTypeSelected,
          initialSelectedValue: selectedType,
        ),
      ],
    );
  }
}

void printFilteredVitals(List<Vital> filteredVitals) {
  print('Filtered Vitals:');
  for (var vital in filteredVitals) {
    print('Vital Name: ${vital.vitals.name}');
    print('Time: ${vital.time}');
    print('Observed Values:');
    for (var observedValue in vital.vitalObservedValue) {
      print(' - Value: ${observedValue.observedValue}');
      print(' - Reading Type: ${observedValue.readingType}');
    }
    print('------------------');
  }
}
