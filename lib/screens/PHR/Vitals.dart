import 'package:flutter/material.dart';
import 'dart:convert';

import 'package:http/http.dart' as http;
class Vital {
  final int id;
  final DateTime time;
  final int patientId;
  final int vitalsId;
  final Vitals vitals;
  final List<VitalObservedValue> vitalObservedValue;

  Vital({
    required this.id,
    required this.time,
    required this.patientId,
    required this.vitalsId,
    required this.vitals,
    required this.vitalObservedValue,
  });

  factory Vital.fromJson(Map<String, dynamic> json) {
    return Vital(
      id: json['id'],
      time: DateTime.parse(json['time']),
      patientId: json['patientId'],
      vitalsId: json['vitalsId'],
      vitals: Vitals.fromJson(json['vitals']),
      vitalObservedValue: (json['vitalObservedValue'] as List)
          .map((item) => VitalObservedValue.fromJson(item))
          .toList(),
    );
  }
}

class Vitals {
  final int id;
  final String name;

  Vitals({
    required this.id,
    required this.name,
  });

  factory Vitals.fromJson(Map<String, dynamic> json) {
    return Vitals(
      id: json['id'],
      name: json['name'],
    );
  }
}

class VitalObservedValue {
  final int id;
  final int observedValue;
  final int vitalsMeasureId;
  final String readingType;

  VitalObservedValue({
    required this.id,
    required this.observedValue,
    required this.vitalsMeasureId,
    required this.readingType,
  });

  factory VitalObservedValue.fromJson(Map<String, dynamic> json) {
    return VitalObservedValue(
      id: json['id'],
      observedValue: json['observedValue'],
      vitalsMeasureId: json['vitalsMeasureId'],
      readingType: json['readingType'],
    );
  }
}



















class VitalsScreen extends StatefulWidget {
  @override
  _VitalsScreenState createState() => _VitalsScreenState();
}

class _VitalsScreenState extends State<VitalsScreen> {
  late List<Vital> vitals = [];

  @override
  void initState() {
    super.initState();
    fetchData();
  }
  Future<void> fetchData() async {
    final String baseURL = 'http://192.168.18.61:3000'; // Hardcoded base URL
    final String patientId = '3'; // Replace with your patient ID
    final String token = 'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpZCI6NCwicm9sZSI6InBhdGllbnQiLCJpYXQiOjE3MDU4OTAwNjcsImV4cCI6MTcwNTg5MzY2N30.wIcaxoT15SQJM-ghRiqinVnAKnRgwRiqEgLvEUvYzDI'; // Replace with your authentication token

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
        setState(() {
          vitals = responseData.map((data) => Vital.fromJson(data)).toList();
        });
      } else {
        throw Exception('Failed to fetch Measures of Patient: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Failed to fetch Measures of Patient: $e');
    }
  }

  List<DateTime> _getDistinctDates(List<Vital> vitals) {
    Set<DateTime> datesSet = vitals.map((vital) => DateTime(vital.time.year, vital.time.month, vital.time.day)).toSet();
    return datesSet.toList()..sort((a, b) => b.compareTo(a));
  }

  List<Vital> _getVitalsByDate(DateTime date) {
    return vitals.where((vital) => DateTime(vital.time.year, vital.time.month, vital.time.day) == date).toList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Vitals'),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(height: 10),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  _buildNavButton('All'),
                  _buildNavButton('BP'),
                  _buildNavButton('Sugar'),
                  _buildNavButton('Temp'),
                ],
              ),
              SizedBox(height: 10),
              _buildDateSelector('From'),
              SizedBox(height: 10),
              _buildDateSelector('To'),
              SizedBox(height: 20),
              _buildDataList(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildNavButton(String title) {
    return Container(
      width: 80,
      height: 40,
      decoration: BoxDecoration(
        color: Color(0xFF199A8E),
        borderRadius: BorderRadius.circular(5),
      ),
      child: Center(
        child: Text(
          title,
          style: TextStyle(color: Colors.white),
        ),
      ),
    );
  }

  Widget _buildDateSelector(String label) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          '  $label',
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
        ),
        Stack(
          children: [
            Container(
              width: 290,
              height: 40,
              decoration: BoxDecoration(
                color: Colors.grey[200],
                borderRadius: BorderRadius.circular(10),
              ),
              child: Center(
                child: TextField(
                  enabled: false,
                  decoration: InputDecoration(
                    border: InputBorder.none,
                    contentPadding: EdgeInsets.symmetric(horizontal: 10),
                  ),
                ),
              ),
            ),
            Positioned(
              right: 0,
              top: 0,
              bottom: 0,
              child: IconButton(
                icon: Icon(Icons.calendar_today),
                onPressed: () {
                  // Add onPressed action for calendar icon
                },
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildDataList() {
    return ListView.builder(
      shrinkWrap: true,
      physics: NeverScrollableScrollPhysics(),
      itemCount: _getDistinctDates(vitals).length,
      itemBuilder: (context, index) {
        final date = _getDistinctDates(vitals)[index];
        final vitalsByDate = _getVitalsByDate(date);
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ListTile(
              title: Text('${date.month}/${date.day}'),
              trailing: Checkbox(
                value: false, // Change value according to your logic
                onChanged: (newValue) {
                  // Handle checkbox state change
                },
              ),
            ),
            SizedBox(height: 10),
            _buildExpensesList(vitalsByDate),
            SizedBox(height: 10),
          ],
        );
      },
    );
  }

  Widget _buildExpensesList(List<Vital> vitalsByDate){
    return ListView.builder(
      shrinkWrap: true,
      physics: NeverScrollableScrollPhysics(),
      itemCount: vitalsByDate.length,
      itemBuilder: (context, index) {
        final vital = vitalsByDate[index];
        return Padding(
          padding: const EdgeInsets.symmetric(vertical: 8.0),
          child: Container(
            decoration: BoxDecoration(
              color: Colors.grey[200],
              borderRadius: BorderRadius.circular(10),
            ),
            child: ListTile(
              title: Text('${vital.vitals.name}: ${vital.vitalObservedValue.map((value) => '${value.readingType}: ${value.observedValue}').join(", ")}'),
              trailing: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  IconButton(
                    icon: Icon(Icons.edit),
                    onPressed: () {
                      // Handle edit action
                    },
                  ),
                  IconButton(
                    icon: Icon(Icons.delete),
                    onPressed: () {
                      // Handle delete action
                    },
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Your App Title',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: VitalsScreen(),
    );
  }
}
