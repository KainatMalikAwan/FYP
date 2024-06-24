import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:intl/intl.dart';
import 'package:fyp/Services/config.dart';
import 'package:fyp/ThemeSettings/ThemeSettings.dart';
import 'package:fyp/models/PHR/Reports/TestData.dart';
import 'package:fyp/Services/API/PHR/ReportsServices.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'AddRepor.dart';

void main() {
  runApp(MyApp());
}



class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Medical Tests',
      theme: ThemeData(
        primarySwatch: Colors.teal,
      ),
      home: TestListScreen(),
    );
  }
}

class TestListScreen extends StatefulWidget {
  @override
  _TestListScreenState createState() => _TestListScreenState();
}

class _TestListScreenState extends State<TestListScreen> {
  late Future<List<TestData>> futureTestData;
  DateTime? fromDate;
  DateTime? toDate;
  Map<int, bool> testSelected = {};
  Map<DateTime, bool> dateSelected = {};
  String selectedTestName = 'All';
  List<String> testNames = [];

  @override
  void initState() {
    super.initState();

    futureTestData = _fetchTestData(); // Replace with the actual patient ID
  }

  Future<List<TestData>> _fetchTestData() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final int? storedPatientId = prefs.getInt('userId');

      if (storedPatientId != null) {
        // Replace ReportsService() with your actual service instance
        List<TestData> data = await ReportsService().fetchTestData(
            storedPatientId);

         extractUniqueTestNames(data);
        return data;
      } else {
        throw Exception('Patient ID not found in SharedPreferences');
      }
    } catch (e) {
      // Handle exceptions
      print('Error fetching test data: $e');
      rethrow; // Rethrow to propagate the error further if needed
    }
  }

  void extractUniqueTestNames(List<TestData> data) {
    Set<String> uniqueNames = {'All'};
    for (var testData in data) {
      uniqueNames.add(testData.name);
    }
    setState(() {
      testNames = uniqueNames.toList();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: InkWell(
          onTap: () {
            // Handle onTap for the app bar title
            print('AppBar tapped!');
          },
          child: Text(' Add New Tests:',
            style: TextStyle(
                color: ThemeSettings.labelColor,
                fontWeight:FontWeight.w500,
              fontSize: 15.0,
            ),

          ),
        ),
        actions: [



          Container(
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: ThemeSettings.labelColor,
            ),
            child: CircleAvatar(
              backgroundColor: Colors.transparent,
              child: IconButton(
                icon: Icon(Icons.add),
                color: ThemeSettings.buttonTextColor,
                onPressed: () {
                  // Navigate to AddReportScreen on button press
                  Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (context) => AddReportScreen(),
                    ),
                  );
                },
              ),
            ),
          ),

 SizedBox(width: 30,)
        ],
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Container(
            height: 50,
            margin: EdgeInsets.symmetric(vertical: 10),
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              itemCount: testNames.length,
              itemBuilder: (context, index) {
                String testName = testNames[index];
                return Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 5),
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      primary: selectedTestName == testName
                          ? ThemeSettings.buttonColor
                          : Colors.grey,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20),
                      ),
                    ),
                    onPressed: () {
                      setState(() {
                        selectedTestName = testName;
                      });
                    },
                    child: Text(
                      testName,
                      style: TextStyle(color: ThemeSettings.buttonTextColor),
                    ),
                  ),
                );
              },
            ),
          ),
          Container(
            height: 120,
            padding: EdgeInsets.all(10),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Expanded(
                      child: ElevatedButton.icon(
                        style: ElevatedButton.styleFrom(
                          primary: fromDate != null ? ThemeSettings.buttonColor : Colors.grey,
                        ),
                        onPressed: () => _selectDate(context, true),
                        icon: Icon(Icons.calendar_today, color: ThemeSettings.buttonTextColor),
                        label: Text(
                          'Pick From Date',
                          style: TextStyle(color: ThemeSettings.buttonTextColor),
                        ),
                      ),
                    ),
                    SizedBox(width: 10),
                    Expanded(
                      child: ElevatedButton.icon(
                        style: ElevatedButton.styleFrom(
                          primary: toDate != null ? ThemeSettings.buttonColor : Colors.grey,
                        ),
                        onPressed: () => _selectDate(context, false),
                        icon: Icon(Icons.calendar_today, color: ThemeSettings.buttonTextColor),
                        label: Text(
                          'Pick To Date',
                          style: TextStyle(color: ThemeSettings.buttonTextColor),
                        ),
                      ),
                    ),
                  ],
                ),
                if (fromDate != null || toDate != null)
                  Padding(
                    padding: EdgeInsets.only(top: 10),
                    child: Text(
                      '${fromDate != null ? 'From: ${DateFormat('dd MMMM yyyy').format(fromDate!)}' : ''} ${toDate != null ? 'To: ${DateFormat('dd MMMM yyyy').format(toDate!)}' : ''}',
                      style: TextStyle(color: Colors.black),
                    ),
                  ),
              ],
            ),
          ),
          Expanded(
            child: FutureBuilder<List<TestData>>(
              future: futureTestData,
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return Center(child: CircularProgressIndicator());
                }

                if (snapshot.hasError) {
                  return Center(child: Text('${snapshot.error}'));
                }

                if (!snapshot.hasData || snapshot.data!.isEmpty) {
                  return Center(child: Text('No data available'));
                }

                List<TestData> filteredData = snapshot.data!.where((testData) {
                  bool isInRange = true;
                  if (fromDate != null && toDate != null) {
                    isInRange = testData.time.isAfter(fromDate!) && testData.time.isBefore(toDate!);
                  } else if (fromDate != null) {
                    isInRange = testData.time.isAfter(fromDate!);
                  } else if (toDate != null) {
                    isInRange = testData.time.isBefore(toDate!);
                  }

                  bool isTestNameMatch = selectedTestName == 'All' || testData.name == selectedTestName;
                  return isInRange && isTestNameMatch;
                }).toList();

                filteredData.sort((a, b) => b.time.compareTo(a.time));

                Map<String, List<TestData>> groupedData = {};
                for (var data in filteredData) {
                  String dateKey = DateFormat('dd MMMM yyyy').format(data.time);
                  if (!groupedData.containsKey(dateKey)) {
                    groupedData[dateKey] = [];
                  }
                  groupedData[dateKey]!.add(data);
                }

                return ListView(
                  children: groupedData.entries.map((entry) {
                    String date = entry.key;
                    List<TestData> tests = entry.value;

                    return Column(
                      children: [
                        ListTile(
                          leading: Checkbox(
                            value: dateSelected[DateFormat('dd MMMM yyyy').parse(date)] ?? false,
                            activeColor: ThemeSettings.buttonColor,
                            onChanged: (bool? value) {
                              setState(() {
                                dateSelected[DateFormat('dd MMMM yyyy').parse(date)] = value ?? false;
                                for (var test in tests) {
                                  testSelected[test.testAddedByPatientId] = value ?? false;
                                }
                              });
                            },
                          ),
                          title: Text(
                            date,
                            style: TextStyle(fontWeight: FontWeight.bold),
                          ),
                        ),
                        ...tests.map((testData) {
                          return Card(
                            margin: EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10),
                              side: BorderSide(color: ThemeSettings.buttonColor),
                            ),
                            child: ListTile(
                              leading: Icon(
                                Icons.description, // Document icon
                                color: ThemeSettings.buttonColor, // Set the icon color
                              ),
                              trailing: Checkbox(
                                value: testSelected[testData.testAddedByPatientId] ?? false,
                                activeColor: ThemeSettings.buttonColor,
                                onChanged: (bool? value) {
                                  setState(() {
                                    testSelected[testData.testAddedByPatientId] = value ?? false;
                                    if (!value!) {
                                      dateSelected[DateFormat('dd MMMM yyyy').parse(date)] = false;
                                    }
                                  });
                                },
                              ),
                              title: Text(testData.name,
                                style: TextStyle(
                                  color: ThemeSettings.buttonColor, // Set the text color
                                  fontWeight: FontWeight.w900, // Make the text bold
                                ),
                              ),
                              subtitle: Text(date),
                              onTap: () => showTestDetails(context, testData),
                            ),
                          );
                        }).toList(),
                      ],
                    );
                  }).toList(),
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  void showTestDetails(BuildContext context, TestData testData) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          backgroundColor: ThemeSettings.buttonTextColor,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.all(Radius.circular(10)),
            side: BorderSide(color: ThemeSettings.buttonColor, width: 2), // Set the border color
          ),
          title: Text(testData.name,
              style: TextStyle(color: ThemeSettings.buttonColor), ),
          content: Container(
            width: MediaQuery.of(context).size.width * 0.9,
            child: SingleChildScrollView(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: testData.testReportField.expand((field) {
                  var relevantValues = field.observedValue.where(
                          (value) => value.testAddedByPatientId == testData.testAddedByPatientId);

                  return relevantValues.map((value) {
                    Color statusColor;
                    switch (value.status) {
                      case 'High':
                        statusColor = Colors.red;
                        break;
                      case 'Low':
                        statusColor = Colors.grey;
                        break;
                      default:
                        statusColor = Colors.black;
                    }

                    return ListTile(
                      title: Text(field.title,
                          style: TextStyle(color: ThemeSettings.buttonColor),
                    ),
                      subtitle: Text(
                        'Value: ${value.observedValue}, Status: ${value.status}',
                        style: TextStyle(color: statusColor),
                      ),
                    );
                  }).toList();
                }).toList(),
              ),
            ),
          ),
          actions: [
            TextButton(
              child: Text('Close',style: TextStyle(color: ThemeSettings.buttonColor),),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }


  Future<void> _selectDate(BuildContext context, bool isFromDate) async {
    DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: isFromDate ? fromDate ?? DateTime.now() : toDate ?? DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime.now(),
      builder: (BuildContext context, Widget? child) {
        return Theme(
          data: ThemeData(
            brightness: Theme.of(context).brightness,
            backgroundColor: Theme.of(context).scaffoldBackgroundColor,
            primaryColor: ThemeSettings.labelColor,
            textTheme: Theme.of(context).textTheme.copyWith(
              bodyText1: TextStyle(color: ThemeSettings.labelColor), // Label text color
              bodyText2: TextStyle(color: Theme.of(context).textTheme.bodyText2!.color), // Selected date text color
            ),
            dialogBackgroundColor: ThemeSettings.labelColor, // Background color
            dialogTheme: DialogTheme(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10.0), // Rounded corners
              ),
            ),
          ),
          child: child!,
        );
      },
    );

    setState(() {
      if (pickedDate != null) {
        if (isFromDate) {
          fromDate = pickedDate;
        } else {
          toDate = pickedDate;
        }
      }
    });
  }


}
