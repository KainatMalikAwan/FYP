import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:fyp/Services/API/PHR/ReportsServices.dart'; // Adjust the path as per your project structure
import 'package:fyp/models/PHR/Reports/Lab.dart'; // Adjust the path as per your project structure
import 'package:fyp/models/PHR/Reports/LabTestOffer.dart'; // Adjust the path as per your project structure
import 'package:fyp/models/PHR/Reports/Test.dart';
import 'package:fyp/ThemeSettings/ThemeSettings.dart'; // Import the theme settings

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Lab Dropdown',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: AddReportScreen(),
    );
  }
}

class AddReportScreen extends StatefulWidget {
  @override
  _AddReportState createState() => _AddReportState();
}

class _AddReportState extends State<AddReportScreen> {
  List<Lab> _labs = [];
  Lab? _selectedLab;
  List<LabTestOffer> _labTestOffers = [];
  bool _loadingLabs = true;
  bool _errorLoadingLabs = false;
  Test? _test;
  bool _loadingTestFormat = false;
  bool _errorLoadingTestFormat = false;
  final _formKey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();
    fetchLabs();
  }

  Future<void> fetchLabs() async {
    try {
      List<Lab> labs = await ReportsService().fetchLabs();
      setState(() {
        _labs = labs;
        if (_labs.isEmpty) {
          _errorLoadingLabs = true;
        } else {
          _selectedLab = _labs.first;
          fetchTestOffers(_selectedLab!.id);
        }
        _loadingLabs = false;
      });
    } catch (e) {
      print('Failed to load labs: $e');
      setState(() {
        _loadingLabs = false;
        _errorLoadingLabs = true;
      });
    }
  }

  Future<void> fetchTestOffers(int labId) async {
    try {
      List<LabTestOffer> testOffers = await ReportsService().fetchTestOffersByLabId(labId);
      setState(() {
        _labTestOffers = testOffers;
      });
    } catch (e) {
      print('Failed to load test offers: $e');
    }
  }

  Future<void> fetchTestFormat(int testOfferId) async {
    setState(() {
      _loadingTestFormat = true;
      _errorLoadingTestFormat = false;
    });
    try {
      Test test = await ReportsService().fetchTestFormat(testOfferId);

      setState(() {
        _test = test;
        _loadingTestFormat = false;
      });
    } catch (e) {
      print('Failed to load test format: $e');
      setState(() {
        _loadingTestFormat = false;
        _errorLoadingTestFormat = true;
      });
    }
  }

  Future<void> uploadTest(Test test) async {
    try {
      final List<Map<String, dynamic>> response = await ReportsService().uploadPatientTest(test);

      // Show the popup with the test results
      showTestResultsPopup(context, response);
    } catch (e) {
      // Show error popup
      showErrorPopup(context, 'Failed to upload test data: $e');
    }
  }

  void showTestResultsPopup(BuildContext context, List<Map<String, dynamic>> responseData) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Test Results'),
          content: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: responseData.map((item) {
                String status = item['status'];
                Color textColor;

                switch (status.toLowerCase()) {
                  case 'high':
                    textColor = Colors.red;
                    break;
                  case 'low':
                    textColor = Colors.grey;
                    break;
                  default:
                    textColor = Colors.black;
                    break;
                }

                return Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Field Name: ${item['fieldName']}',
                      style: TextStyle(color: ThemeSettings.labelColor,fontWeight:FontWeight.bold),
                    ),
                    SizedBox(height: 4),
                    Text(
                      'Observed Value: ${item['observedValue']}',
                      style: TextStyle(color: ThemeSettings.labelColor),
                    ),
                    SizedBox(height: 4),
                    Text(
                      'Status: ${item['status']}',
                      style: TextStyle(color: textColor),
                    ),
                    SizedBox(height: 12),
                  ],
                );
              }).toList(),
            ),
          ),
          actions: <Widget>[
            TextButton(
              child: Text('OK'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  void showErrorPopup(BuildContext context, String message) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Row(
            children: [
              Icon(Icons.error, color: Colors.red),
              SizedBox(width: 8),
              Text('Error', style: TextStyle(color: Colors.red)),
            ],
          ),
          content: Text(message),
          actions: <Widget>[
            TextButton(
              child: Text('OK'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(height: 100),
            _loadingLabs
                ? Center(child: CircularProgressIndicator())
                : _errorLoadingLabs
                ? Text(
              'Failed to load labs',
              style: TextStyle(color: Colors.red),
            )
                : _labs.isEmpty
                ? Text(
              'No labs available',
              style: TextStyle(color: Colors.red),
            )
                : Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Lab:',
                  style: TextStyle(color: ThemeSettings.labelColor),
                ),
                SizedBox(width: 10),
                Expanded(
                  child: Container(
                    width: 200, // Fixed width for the dropdown
                    child: DropdownButtonFormField<Lab>(
                      isExpanded: true,
                      decoration: InputDecoration(
                        filled: true,
                        fillColor: ThemeSettings.bgcolor,
                        contentPadding: EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10.0),
                          borderSide: BorderSide(
                            color: ThemeSettings.buttonColor, // Border color set to button color
                          ),
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10.0),
                          borderSide: BorderSide(
                            color: ThemeSettings.buttonColor, // Border color when enabled
                          ),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10.0),
                          borderSide: BorderSide(
                            color: ThemeSettings.buttonColor, // Border color when focused
                          ),
                        ),
                      ),
                      hint: Text(
                        'Select Lab',
                        style: TextStyle(color: ThemeSettings.buttonTextColor),
                      ),
                      value: _selectedLab,
                      onChanged: (Lab? newValue) {
                        setState(() {
                          _selectedLab = newValue;
                          if (newValue != null) {
                            fetchTestOffers(newValue.id);
                            print('Selected Lab ID: ${newValue.id}');
                          }
                        });
                      },
                      items: _labs.map<DropdownMenuItem<Lab>>((Lab lab) {
                        return DropdownMenuItem<Lab>(
                          value: lab,
                          child: Text(
                            lab.name,
                            style: TextStyle(color: ThemeSettings.labelColor),
                          ),
                        );
                      }).toList(),
                    ),
                  ),
                ),
                IconButton(
                  icon: Icon(Icons.camera_alt),
                  color: ThemeSettings.buttonColor, // Use color from theme settings
                  onPressed: () {
                    // Handle camera icon press
                  },
                ),
              ],
            ),
            SizedBox(height: 20),
            if (_selectedLab == null)
              Text(
                'No lab selected',
                style: TextStyle(color: Colors.red),
              ),
            if (_selectedLab != null && _labTestOffers.isEmpty)
              Text(
                'No tests in ${_selectedLab!.name} lab',
                style: TextStyle(color: Colors.red),
              ),
            SizedBox(height: 10),
            _labTestOffers.isNotEmpty
                ? SizedBox(
              height: 50,
              child: ListView.builder(
                scrollDirection: Axis.horizontal,
                itemCount: _labTestOffers.length,
                itemBuilder: (context, index) {
                  return Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 4.0),
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        primary: ThemeSettings.buttonColor, // Background color
                        onPrimary: ThemeSettings.buttonTextColor, // Text color
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10.0),
                        ),
                      ),
                      onPressed: () {
                        fetchTestFormat(_labTestOffers[index].testOfferId);
                        print('Selected Test Offer ID: ${_labTestOffers[index].testOfferId}');
                      },
                      child: Text(_labTestOffers[index].testName),
                    ),
                  );
                },
              ),
            )
                : SizedBox(), // To keep the layout consistent
            SizedBox(height: 20),
            _loadingTestFormat
                ? Center(child: CircularProgressIndicator())
                : _errorLoadingTestFormat
                ? Text(
              'Failed to load test format',
              style: TextStyle(color: Colors.red),
            )
                : _test != null
                ? Expanded(
              child: Form(
                key: _formKey,
                child: ListView(
                  children: [
                    ..._test!.reportFields.map((field) {
                      return Padding(
                        padding: const EdgeInsets.symmetric(vertical: 8.0),
                        child: TextFormField(
                          decoration: InputDecoration(
                            labelText: field.title,
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10.0),
                              borderSide: BorderSide(
                                color: ThemeSettings.labelColor,
                              ),
                            ),
                            enabledBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10.0),
                              borderSide: BorderSide(
                                color: ThemeSettings.labelColor,
                              ),
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10.0),
                              borderSide: BorderSide(
                                color: ThemeSettings.labelColor,
                              ),
                            ),
                          ),
                          keyboardType: TextInputType.number,
                          onChanged: (value) {
                            setState(() {
                              field.value = int.tryParse(value);
                            });
                          },
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Please enter a value';
                            }
                            if (int.tryParse(value) == null) {
                              return 'Invalid input: ${field.title} must be a number';
                            }
                            return null;
                          },
                        ),
                      );
                    }).toList(),
                    SizedBox(height: 20),
                    ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        primary: ThemeSettings.buttonColor,
                        onPrimary: ThemeSettings.buttonTextColor,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10.0),
                        ),
                      ),
                      onPressed: () async {
                        if (_formKey.currentState!.validate()) {
                          await uploadTest(_test!);
                        }
                      },
                      child: Text('Save'),
                    ),
                  ],
                ),
              ),
            )
                : SizedBox(),
          ],
        ),
      ),
    );
  }
}
