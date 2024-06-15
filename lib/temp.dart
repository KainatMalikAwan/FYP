import 'dart:math';
import 'package:flutter/material.dart';
import 'package:charts_flutter/flutter.dart' as charts;

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
  VitalType _selectedVitalType = VitalType.bloodPressure; // Default selected vital type
  DurationType _selectedDurationType = DurationType.daily; // Default selected duration

  @override
  Widget build(BuildContext context) {
    List<charts.Series<GraphData, DateTime>> data = generateSampleData(_selectedVitalType, _selectedDurationType);

    return Scaffold(
      appBar: AppBar(
        title: Text('Vitals Graph'),
      ),
      body: Column(
        children: [
          DropdownButton<VitalType>(
            value: _selectedVitalType,
            onChanged: (newValue) {
              setState(() {
                _selectedVitalType = newValue!;
              });
            },
            items: VitalType.values.map((vitalType) {
              return DropdownMenuItem<VitalType>(
                value: vitalType,
                child: Text(vitalType.toString().split('.').last),
              );
            }).toList(),
          ),
          DropdownButton<DurationType>(
            value: _selectedDurationType,
            onChanged: (newValue) {
              setState(() {
                _selectedDurationType = newValue!;
              });
            },
            items: DurationType.values.map((durationType) {
              return DropdownMenuItem<DurationType>(
                value: durationType,
                child: Text(durationType.toString().split('.').last),
              );
            }).toList(),
          ),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: charts.TimeSeriesChart(
                data,
                animate: true,
                dateTimeFactory: const charts.LocalDateTimeFactory(),
                behaviors: [charts.ChartTitle('Value vs Time')],
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text(
              'Unit: ${getUnit(_selectedVitalType)}',
              style: TextStyle(fontSize: 16),
            ),
          ),
        ],
      ),
    );
  }

  List<charts.Series<GraphData, DateTime>> generateSampleData(VitalType vitalType, DurationType durationType) {
    Random random = Random();
    double minValue, maxValue;
    String unit;

    switch (vitalType) {
      case VitalType.bloodPressure:
        minValue = 80;
        maxValue = 120;
        unit = 'mmHg';
        break;
      case VitalType.sugarLevel:
        minValue = 70;
        maxValue = 140;
        unit = 'mg/dL';
        break;
      case VitalType.temperature:
        minValue = 95;
        maxValue = 104;
        unit = '°F';
        break;
    }

    List<GraphData> sampleData = List.generate(30, (index) {
      DateTime date = DateTime.now().subtract(Duration(days: 30 - index));
      double value = minValue + random.nextDouble() * (maxValue - minValue);
      return GraphData(date, value, unit);
    });

    return [
      charts.Series<GraphData, DateTime>(
        id: vitalType.toString(),
        colorFn: (_, __) => charts.MaterialPalette.blue.shadeDefault,
        domainFn: (GraphData data, _) => data.time,
        measureFn: (GraphData data, _) => data.value,
        data: sampleData,
      )
    ];
  }

  String getUnit(VitalType vitalType) {
    switch (vitalType) {
      case VitalType.bloodPressure:
        return 'mmHg';
      case VitalType.sugarLevel:
        return 'mg/dL';
      case VitalType.temperature:
        return '°F';
      default:
        return '';
    }
  }
}

class GraphData {
  final DateTime time;
  final double value;
  final String unit;

  GraphData(this.time, this.value, this.unit);
}

enum VitalType {
  bloodPressure,
  sugarLevel,
  temperature,
}

enum DurationType {
  daily,
  weekly,
  monthly,
  yearly,
}


































// import 'dart:convert';
// import 'dart:math';
// import 'package:http/http.dart' as http;
//
// void main() {
//   // Use the static base URL
//   String baseUrl = 'http://192.168.0.101:3000';
//
//   // Append "/measures" to the base link for the API endpoint
//   String apiUrl = '$baseUrl/measures';
//
//   // Generate and send 60 random measures
//   generateAndSendMeasures(apiUrl, 60);
// }
//
// Future<void> generateAndSendMeasures(String apiUrl, int count) async {
//   for (int i = 0; i < count; i++) {
//     // Generate the API body with random values
//     Map<String, dynamic> apiBody = generateRandomMeasure();
//
//     // Call the API
//     await callApi(apiUrl, apiBody);
//   }
// }
//
// Map<String, dynamic> generateRandomMeasure() {
//   Random random = Random();
//
//   // Define ranges for each vital
//   const Map<String, Map<String, int>> ranges = {
//     'Blood Pressure Systolic': {'min': 90, 'max': 120},
//     'Blood Pressure Diastolic': {'min': 60, 'max': 80},
//     'Temperature': {'min': 95, 'max': 104}, // Fahrenheit
//     'Sugar Fasting': {'min': 70, 'max': 100},
//     'Sugar Random': {'min': 70, 'max': 140},
//   };
//
//   // Define vitals with corresponding IDs
//   const vitals = {
//     'Blood Pressure': 15,
//     'Temperature': 16,
//     'Sugar': 17,
//   };
//
//   // Randomly choose a vital
//   String selectedVital = (vitals.keys.toList()..shuffle()).first;
//   int vitalsId = vitals[selectedVital]!;
//
//   // Generate appropriate readings based on selected vital
//   List<Map<String, dynamic>> observedValues = [];
//   if (selectedVital == 'Blood Pressure') {
//     observedValues = [
//       {'readingType': 'Systolic', 'observedValue': randomInRange(ranges['Blood Pressure Systolic']!, random)},
//       {'readingType': 'Diastolic', 'observedValue': randomInRange(ranges['Blood Pressure Diastolic']!, random)},
//     ];
//   } else if (selectedVital == 'Temperature') {
//     observedValues = [
//       {'readingType': 'Fahrenheit', 'observedValue': randomInRange(ranges['Temperature']!, random)},
//     ];
//   } else if (selectedVital == 'Sugar') {
//     String readingType = (random.nextBool()) ? 'Fasting' : 'Random';
//     observedValues = [
//       {'readingType': readingType, 'observedValue': randomInRange(ranges['Sugar $readingType']!, random)},
//     ];
//   }
//
//   return {
//     'patientId': 1,
//     'vitalsId': vitalsId,
//     'vitalObservedValues': observedValues,
//   };
// }
//
// int randomInRange(Map<String, int> range, Random random) {
//   return range['min']! + random.nextInt(range['max']! - range['min']! + 1);
// }
//
// Future<void> callApi(String apiUrl, Map<String, dynamic> apiBody) async {
//   try {
//     // Convert the API body to JSON
//     String requestBody = jsonEncode(apiBody);
//
//     // Send POST request
//     http.Response response = await http.post(
//       Uri.parse(apiUrl),
//       headers: {'Content-Type': 'application/json'},
//       body: requestBody,
//     );
//
//     // Check the response status code
//     if (response.statusCode == 200) {
//       print('API call successful');
//       print('Response: ${response.body}');
//     } else {
//       print('Error: ${response.statusCode}');
//     }
//   } catch (e) {
//     print('Error: $e');
//   }
// }































