import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

import 'Services/config.dart';
import 'dart:math';
import 'package:charts_flutter/flutter.dart' as charts;

// Model classes
class ObservationValue {
  final int id;
  final int testReportFieldId;
  final int testAddedByPatientId;
  final double observedValue;
  final String status;

  ObservationValue({
    required this.id,
    required this.testReportFieldId,
    required this.testAddedByPatientId,
    required this.observedValue,
    required this.status,
  });

  factory ObservationValue.fromJson(Map<String, dynamic> json) {
    return ObservationValue(
      id: json['id'],
      testReportFieldId: json['testReportFieldId'],
      testAddedByPatientId: json['testAddedByPatientId'],
      observedValue: json['observedValue'].toDouble(),
      status: json['status'],
    );
  }
}

class TestReportField {
  final int id;
  final String title;
  final int testOfferId;
  final List<ObservationValue> observedValue;

  TestReportField({
    required this.id,
    required this.title,
    required this.testOfferId,
    required this.observedValue,
  });

  factory TestReportField.fromJson(Map<String, dynamic> json) {
    var list = json['observedValue'] as List;
    List<ObservationValue> observedValueList =
    list.map((e) => ObservationValue.fromJson(e)).toList();

    return TestReportField(
      id: json['id'],
      title: json['title'],
      testOfferId: json['testOfferId'],
      observedValue: observedValueList,
    );
  }
}

class TestData {
  final int testAddedByPatientId;
  final String name;
  final DateTime time;
  final List<TestReportField> testReportField;

  TestData({
    required this.testAddedByPatientId,
    required this.name,
    required this.time,
    required this.testReportField,
  });

  factory TestData.fromJson(Map<String, dynamic> json) {
    var list = json['testReportField'] as List;
    List<TestReportField> testReportFieldList =
    list.map((e) => TestReportField.fromJson(e)).toList();

    return TestData(
      testAddedByPatientId: json['testAddedByPatientId'],
      name: json['name'],
      time: DateTime.parse(json['time']),
      testReportField: testReportFieldList,
    );
  }
}

// Function to fetch data
Future<List<TestData>> fetchData(int patientId) async {
  final response = await http.get(
      Uri.parse('${Config.baseUrl}/tests/testreportwithresult/$patientId'));

  if (response.statusCode == 200) {
    final jsonResponse = jsonDecode(response.body);
    List<TestData> testDataList =
    (jsonResponse['data'] as List).map((e) => TestData.fromJson(e)).toList();
    return testDataList;
  } else {
    throw Exception('Failed to load test data');
  }
}

// Function to process data
void processData(List<TestData> testDataList, String testName, List<DateTime> dates, List<String> names, List<List<double>> values) {
  // Clear previous data
  dates.clear();
  names.clear();
  values.clear();

  // Collect dates for all TestData objects where the test name matches
  for (var testData in testDataList) {
    if (testData.name == testName) {
      dates.add(testData.time);
    }
  }

  // Get the first TestData object where the test name matches
  TestData firstTestData = testDataList.firstWhere(
        (testData) => testData.name == testName,
    orElse: () => TestData(
      testAddedByPatientId: 0,
      name: '',
      time: DateTime(1970),
      testReportField: [],
    ),
  );

  if (firstTestData.name == testName) {
    for (var reportField in firstTestData.testReportField) {
      names.add(reportField.title);

      List<double> tempValues = [];
      for (var observation in reportField.observedValue) {
        tempValues.add(observation.observedValue);
      }

      values.add(tempValues);
    }
  }
}

// Function to sort TestData list by dates
List<TestData> sortTestDataByDate(List<TestData> testDataList) {
  testDataList.sort((a, b) => a.time.compareTo(b.time));
  return testDataList;
}

// Main App
class TestGraphApp extends StatefulWidget {
  @override
  _TestGraphAppState createState() => _TestGraphAppState();
}

class _TestGraphAppState extends State<TestGraphApp> {
  late Future<List<TestData>> futureTestData;
  List<TestData> testDataList = [];
  String selectedTestName = '';
  List<DateTime> dates = [];
  List<String> names = [];
  List<List<double>> values = [];
  List<String> uniqueTestNames = [];

  @override
  void initState() {
    super.initState();
    futureTestData = fetchData(1); // Replace with actual patient ID
    futureTestData.then((data) {
      setState(() {
        testDataList = sortTestDataByDate(data);
        uniqueTestNames = testDataList.map((e) => e.name).toSet().toList();
        if (uniqueTestNames.isNotEmpty) {
          selectedTestName = uniqueTestNames.first;
          processData(testDataList, selectedTestName, dates, names, values);
        }
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: Text('Custom Graph Widget Example'),
        ),
        body: Column(
          children: [
            DropdownButton<String>(
              value: selectedTestName,
              onChanged: (String? newValue) {
                setState(() {
                  selectedTestName = newValue!;
                  processData(testDataList, selectedTestName, dates, names, values);
                });
              },
              items: uniqueTestNames.map<DropdownMenuItem<String>>((String value) {
                return DropdownMenuItem<String>(
                  value: value,
                  child: Text(value),
                );
              }).toList(),
            ),
            Expanded(
              child: CustomGraphWidget(
                dates: dates,
                measuredValues: values,
                valueTypes: names,
                valueUnits: ['mg/dL'], // Add appropriate units
              ),
            ),
          ],
        ),
      ),
    );
  }
}

void main() {
  runApp(TestGraphApp());
}

class CustomGraphWidget extends StatefulWidget {
  final List<DateTime> dates;
  final List<List<double>> measuredValues;
  final List<String> valueTypes;
  final List<String> valueUnits;

  CustomGraphWidget({
    required this.dates,
    required this.measuredValues,
    required this.valueTypes,
    required this.valueUnits,
  });

  @override
  _CustomGraphWidgetState createState() => _CustomGraphWidgetState();
}

class _CustomGraphWidgetState extends State<CustomGraphWidget> {
  late List<charts.Series<GraphData, DateTime>> dataSeries;
  late DateTime minDate;
  late DateTime maxDate;
  late double minValue;
  late double maxValue;
  Map<String, double>? selectedValues;

  @override
  void initState() {
    super.initState();
    _initializeChart();
  }

  @override
  void didUpdateWidget(CustomGraphWidget oldWidget) {
    super.didUpdateWidget(oldWidget);
    _initializeChart();
  }

  void _initializeChart() {
    for (var values in widget.measuredValues) {
      assert(values.length == widget.dates.length);
    }

    var sortedData = _sortData(widget.dates, widget.measuredValues);
    List<DateTime> sortedDates = sortedData.map((e) => e.key).toList();
    List<List<double>> sortedMeasuredValues = sortedData.map((e) => e.value).toList();

    dataSeries = _createChartData(sortedDates, sortedMeasuredValues, widget.valueTypes);
    minDate = sortedDates.first;
    maxDate = sortedDates.last;
    minValue = _calculateMinValue(sortedMeasuredValues);
    maxValue = _calculateMaxValue(sortedMeasuredValues);
  }

  List<MapEntry<DateTime, List<double>>> _sortData(List<DateTime> dates, List<List<double>> measuredValues) {
    List<MapEntry<DateTime, List<double>>> pairedData = [];

    for (int i = 0; i < dates.length; i++) {
      List<double> valuesAtI = [];
      for (int j = 0; j < measuredValues.length; j++) {
        valuesAtI.add(measuredValues[j][i]);
      }
      pairedData.add(MapEntry(dates[i], valuesAtI));
    }

    pairedData.sort((a, b) => a.key.compareTo(b.key));
    return pairedData;
  }

  List<charts.Series<GraphData, DateTime>> _createChartData(List<DateTime> dates, List<List<double>> values, List<String> types) {
    List<charts.Series<GraphData, DateTime>> seriesList = [];
    for (int i = 0; i < types.length; i++) {
      List<GraphData> data = [];
      for (int j = 0; j < dates.length; j++) {
        data.add(GraphData(dates[j], values[j][i]));
      }
      seriesList.add(
        charts.Series<GraphData, DateTime>(
          id: types[i],
          colorFn: (_, __) => _getColor(i),
          domainFn: (GraphData data, _) => data.time,
          measureFn: (GraphData data, _) => data.value,
          data: data,
          labelAccessorFn: (GraphData data, _) => '${types[i]}: ${data.value}',
        ),
      );
    }
    return seriesList;
  }

  charts.Color _getColor(int index) {
    List<charts.Color> colors = [
      charts.MaterialPalette.blue.shadeDefault,
      charts.MaterialPalette.red.shadeDefault,
      charts.MaterialPalette.green.shadeDefault,
      charts.MaterialPalette.deepOrange.shadeDefault,
      charts.MaterialPalette.purple.shadeDefault,
      charts.MaterialPalette.yellow.shadeDefault,
    ];
    return colors[index % colors.length];
  }

  double _calculateMinValue(List<List<double>> values) {
    double minVal = values.expand((e) => e).reduce(min);
    return minVal;
  }

  double _calculateMaxValue(List<List<double>> values) {
    double maxVal = values.expand((e) => e).reduce(max);
    return maxVal;
  }

  void _onSelectionChanged(charts.SelectionModel<DateTime> model) {
    if (model.hasDatumSelection) {
      final selectedDatum = model.selectedDatum;
      Map<String, double> values = {};
      for (var datumPair in selectedDatum) {
        values[datumPair.series.displayName!] = datumPair.datum.value;
      }
      setState(() {
        selectedValues = values;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Container(
        width: MediaQuery.of(context).size.width, // Use MediaQuery for width
        padding: EdgeInsets.all(8.0),
        child: Column(
          children: [
            SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Container(
                width: max(800, MediaQuery.of(context).size.width), // Adjust width as needed
                height: 400, // Example fixed height, adjust as needed
                child: charts.TimeSeriesChart(
                  dataSeries,
                  animate: true,
                  selectionModels: [
                    charts.SelectionModelConfig(
                      type: charts.SelectionModelType.info,
                      changedListener: _onSelectionChanged,
                    )
                  ],
                  domainAxis: charts.DateTimeAxisSpec(
                    tickFormatterSpec: charts.AutoDateTimeTickFormatterSpec(
                      day: charts.TimeFormatterSpec(
                        format: 'dd-MM',
                        transitionFormat: 'dd-MM-yyyy',
                      ),
                    ),
                    renderSpec: charts.SmallTickRendererSpec(
                      labelStyle: charts.TextStyleSpec(
                        fontSize: 12,
                        color: charts.MaterialPalette.black,
                      ),
                      lineStyle: charts.LineStyleSpec(
                        color: charts.MaterialPalette.black,
                      ),
                    ),
                  ),
                  primaryMeasureAxis: charts.NumericAxisSpec(
                    renderSpec: charts.GridlineRendererSpec(
                      labelStyle: charts.TextStyleSpec(
                        fontSize: 12,
                        color: charts.MaterialPalette.black,
                      ),
                      lineStyle: charts.LineStyleSpec(
                        color: charts.MaterialPalette.black,
                      ),
                    ),
                    tickFormatterSpec: charts.BasicNumericTickFormatterSpec(
                          (value) => '${value?.toDouble()} ${widget.valueUnits[0]}',
                    ),
                  ),
                  behaviors: [
                    charts.SelectNearest(
                      eventTrigger: charts.SelectionTrigger.tap,
                    ),
                    // charts.SeriesLegend(
                    //   position: charts.BehaviorPosition.bottom,
                    //   showMeasures: true,
                    //   measureFormatter: (num? value) {
                    //     return value!.toStringAsFixed(0);
                    //   },
                    // ),
                    charts.ChartTitle(
                      'Date',
                      behaviorPosition: charts.BehaviorPosition.bottom,
                      titleOutsideJustification: charts.OutsideJustification.middleDrawArea,
                    ),
                    charts.ChartTitle(
                      'Value',
                      behaviorPosition: charts.BehaviorPosition.start,
                      titleOutsideJustification: charts.OutsideJustification.middleDrawArea,
                    ),
                  ],
                ),
              ),
            ),
            _buildLegend(),
          ],
        ),
      ),
    );
  }

  Widget _buildLegend() {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(
        children: widget.valueTypes.map((type) {
          return Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8.0),
            child: Row(
              children: [
                Container(
                  width: 12,
                  height: 12,
                  color: _getColor(widget.valueTypes.indexOf(type)).toDartColor(),
                ),
                SizedBox(width: 4),
                Text(
                  selectedValues != null && selectedValues!.containsKey(type)
                      ? '${type}: ${selectedValues![type]}'
                      : type,
                  style: TextStyle(fontSize: 12),
                ),
              ],
            ),
          );
        }).toList(),
      ),
    );
  }
}

class GraphData {
  final DateTime time;
  final double value;

  GraphData(this.time, this.value);
}

extension on charts.Color {
  Color toDartColor() {
    return Color.fromARGB(a, r, g, b);
  }
}
//******************************************* important code
//--------------------------------------------------------------------------------------------------
//                                         displaying lists sapratley and graph

// import 'dart:convert';
// import 'package:flutter/material.dart';
// import 'package:http/http.dart' as http;
//
// import 'Services/config.dart';
// import 'dart:math';
// import 'package:charts_flutter/flutter.dart' as charts;
//
// // Model classes
// class ObservationValue {
//   final int id;
//   final int testReportFieldId;
//   final int testAddedByPatientId;
//   final double observedValue;
//   final String status;
//
//   ObservationValue({
//     required this.id,
//     required this.testReportFieldId,
//     required this.testAddedByPatientId,
//     required this.observedValue,
//     required this.status,
//   });
//
//   factory ObservationValue.fromJson(Map<String, dynamic> json) {
//     return ObservationValue(
//       id: json['id'],
//       testReportFieldId: json['testReportFieldId'],
//       testAddedByPatientId: json['testAddedByPatientId'],
//       observedValue: json['observedValue'].toDouble(),
//       status: json['status'],
//     );
//   }
// }
//
// class TestReportField {
//   final int id;
//   final String title;
//   final int testOfferId;
//   final List<ObservationValue> observedValue;
//
//   TestReportField({
//     required this.id,
//     required this.title,
//     required this.testOfferId,
//     required this.observedValue,
//   });
//
//   factory TestReportField.fromJson(Map<String, dynamic> json) {
//     var list = json['observedValue'] as List;
//     List<ObservationValue> observedValueList =
//     list.map((e) => ObservationValue.fromJson(e)).toList();
//
//     return TestReportField(
//       id: json['id'],
//       title: json['title'],
//       testOfferId: json['testOfferId'],
//       observedValue: observedValueList,
//     );
//   }
// }
//
// class TestData {
//   final int testAddedByPatientId;
//   final String name;
//   final DateTime time;
//   final List<TestReportField> testReportField;
//
//   TestData({
//     required this.testAddedByPatientId,
//     required this.name,
//     required this.time,
//     required this.testReportField,
//   });
//
//   factory TestData.fromJson(Map<String, dynamic> json) {
//     var list = json['testReportField'] as List;
//     List<TestReportField> testReportFieldList =
//     list.map((e) => TestReportField.fromJson(e)).toList();
//
//     return TestData(
//       testAddedByPatientId: json['testAddedByPatientId'],
//       name: json['name'],
//       time: DateTime.parse(json['time']),
//       testReportField: testReportFieldList,
//     );
//   }
// }
//
// // Function to fetch data
// Future<List<TestData>> fetchData(int patientId) async {
//   final response = await http.get(
//       Uri.parse('${Config.baseUrl}/tests/testreportwithresult/$patientId'));
//
//   if (response.statusCode == 200) {
//     final jsonResponse = jsonDecode(response.body);
//     List<TestData> testDataList = (jsonResponse['data'] as List)
//         .map((e) => TestData.fromJson(e))
//         .toList();
//     return testDataList;
//   } else {
//     throw Exception('Failed to load test data');
//   }
// }
// List<DateTime> dates = [];
// List<String> names = [];
// List<List<double>> values = [];
// // Function to process data
// void processData(List<TestData> testDataList, String testName) {
//
//
//   // Collect dates for all TestData objects where the test name matches
//   for (var testData in testDataList) {
//     if (testData.name == testName) {
//       dates.add(testData.time);
//     }
//   }
//
//   // Get the first TestData object where the test name matches
//   TestData firstTestData = testDataList.firstWhere(
//         (testData) => testData.name == testName,
//     orElse: () => TestData(
//       testAddedByPatientId: 0,
//       name: '',
//       time: DateTime(1970),
//       testReportField: [],
//     ),
//   );
//
//   if (firstTestData.name == testName) {
//     for (var reportField in firstTestData.testReportField) {
//       names.add(reportField.title);
//
//       List<double> tempValues = [];
//       for (var observation in reportField.observedValue) {
//         tempValues.add(observation.observedValue);
//       }
//
//       values.add(tempValues);
//     }
//   }
//
//   // Now you have the dates, names, and values lists populated
//   // Do something with them, like print or further processing
//   print('Dates: $dates');
//   print('Names: $names');
//   print('Values: $values');
// }
//
//
//
// // Function to sort TestData list by dates
// List<TestData> sortTestDataByDate(List<TestData> testDataList) {
//   testDataList.sort((a, b) => a.time.compareTo(b.time));
//   return testDataList;
// }
//
//
//
// Future<void> main() async {
//   List<TestData> testDataList = await fetchData(1); // Replace with actual patient ID
//   List<TestData> sortedTestDataList = sortTestDataByDate(testDataList);
//   // Loop to print sorted dates
//   print(sortedTestDataList.length);
//   processData(testDataList, "Special Chemistry");
//   runApp(MaterialApp(
//     home: Scaffold(
//       appBar: AppBar(
//         title: Text('Custom Graph Widget Example'),
//       ),
//       body: CustomGraphWidget(
//         dates: dates,
//         measuredValues:values,
//         valueTypes: names,
//         valueUnits: ['mg/dL'],
//       ),
//     ),
//   ));
// }
//
//
// class CustomGraphWidget extends StatefulWidget {
//   final List<DateTime> dates;
//   final List<List<double>> measuredValues;
//   final List<String> valueTypes;
//   final List<String> valueUnits;
//
//   CustomGraphWidget({
//     required this.dates,
//     required this.measuredValues,
//     required this.valueTypes,
//     required this.valueUnits,
//   });
//
//   @override
//   _CustomGraphWidgetState createState() => _CustomGraphWidgetState();
// }
//
// class _CustomGraphWidgetState extends State<CustomGraphWidget> {
//   late List<charts.Series<GraphData, DateTime>> dataSeries;
//   late DateTime minDate;
//   late DateTime maxDate;
//   late double minValue;
//   late double maxValue;
//   Map<String, double>? selectedValues;
//
//   @override
//   void initState() {
//     super.initState();
//     _initializeChart();
//   }
//
//   @override
//   void didUpdateWidget(CustomGraphWidget oldWidget) {
//     super.didUpdateWidget(oldWidget);
//     _initializeChart();
//   }
//
//   void _initializeChart() {
//     for (var values in widget.measuredValues) {
//       assert(values.length == widget.dates.length);
//     }
//
//     var sortedData = _sortData(widget.dates, widget.measuredValues);
//     List<DateTime> sortedDates = sortedData.map((e) => e.key).toList();
//     List<List<double>> sortedMeasuredValues = sortedData.map((e) => e.value).toList();
//
//     dataSeries = _createChartData(sortedDates, sortedMeasuredValues, widget.valueTypes);
//     minDate = sortedDates.first;
//     maxDate = sortedDates.last;
//     minValue = _calculateMinValue(sortedMeasuredValues);
//     maxValue = _calculateMaxValue(sortedMeasuredValues);
//   }
//
//   List<MapEntry<DateTime, List<double>>> _sortData(List<DateTime> dates, List<List<double>> measuredValues) {
//     List<MapEntry<DateTime, List<double>>> pairedData = [];
//
//     for (int i = 0; i < dates.length; i++) {
//       List<double> valuesAtI = [];
//       for (int j = 0; j < measuredValues.length; j++) {
//         valuesAtI.add(measuredValues[j][i]);
//       }
//       pairedData.add(MapEntry(dates[i], valuesAtI));
//     }
//
//     pairedData.sort((a, b) => a.key.compareTo(b.key));
//     return pairedData;
//   }
//
//   List<charts.Series<GraphData, DateTime>> _createChartData(List<DateTime> dates, List<List<double>> values, List<String> types) {
//     List<charts.Series<GraphData, DateTime>> seriesList = [];
//     for (int i = 0; i < types.length; i++) {
//       List<GraphData> data = [];
//       for (int j = 0; j < dates.length; j++) {
//         data.add(GraphData(dates[j], values[j][i]));
//       }
//       seriesList.add(
//         charts.Series<GraphData, DateTime>(
//           id: types[i],
//           colorFn: (_, __) => _getColor(i),
//           domainFn: (GraphData data, _) => data.time,
//           measureFn: (GraphData data, _) => data.value,
//           data: data,
//           labelAccessorFn: (GraphData data, _) => '${types[i]}: ${data.value}',
//         ),
//       );
//     }
//     return seriesList;
//   }
//
//   charts.Color _getColor(int index) {
//     List<charts.Color> colors = [
//       charts.MaterialPalette.blue.shadeDefault,
//       charts.MaterialPalette.red.shadeDefault,
//       charts.MaterialPalette.green.shadeDefault,
//       charts.MaterialPalette.deepOrange.shadeDefault,
//       charts.MaterialPalette.purple.shadeDefault,
//       charts.MaterialPalette.yellow.shadeDefault,
//     ];
//     return colors[index % colors.length];
//   }
//
//   double _calculateMinValue(List<List<double>> values) {
//     double minVal = values.expand((e) => e).reduce(min);
//     return minVal;
//   }
//
//   double _calculateMaxValue(List<List<double>> values) {
//     double maxVal = values.expand((e) => e).reduce(max);
//     return maxVal;
//   }
//
//   void _onSelectionChanged(charts.SelectionModel<DateTime> model) {
//     if (model.hasDatumSelection) {
//       final selectedDatum = model.selectedDatum;
//       Map<String, double> values = {};
//       for (var datumPair in selectedDatum) {
//         values[datumPair.series.displayName!] = datumPair.datum.value;
//       }
//       setState(() {
//         selectedValues = values;
//       });
//     }
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return SingleChildScrollView(
//       scrollDirection: Axis.horizontal,
//       child: Container(
//         width: MediaQuery.of(context).size.width, // Use MediaQuery for width
//         padding: EdgeInsets.all(8.0),
//         child: Column(
//           children: [
//             SingleChildScrollView(
//               scrollDirection: Axis.horizontal,
//               child: Container(
//                 width: max(800, MediaQuery.of(context).size.width), // Adjust width as needed
//                 height: 400, // Example fixed height, adjust as needed
//                 child: charts.TimeSeriesChart(
//                   dataSeries,
//                   animate: true,
//                   selectionModels: [
//                     charts.SelectionModelConfig(
//                       type: charts.SelectionModelType.info,
//                       changedListener: _onSelectionChanged,
//                     )
//                   ],
//                   domainAxis: charts.DateTimeAxisSpec(
//                     tickFormatterSpec: charts.AutoDateTimeTickFormatterSpec(
//                       day: charts.TimeFormatterSpec(
//                         format: 'dd-MM',
//                         transitionFormat: 'dd-MM-yyyy',
//                       ),
//                     ),
//                     renderSpec: charts.SmallTickRendererSpec(
//                       labelStyle: charts.TextStyleSpec(
//                         fontSize: 12,
//                         color: charts.MaterialPalette.black,
//                       ),
//                       lineStyle: charts.LineStyleSpec(
//                         color: charts.MaterialPalette.black,
//                       ),
//                     ),
//                   ),
//                   primaryMeasureAxis: charts.NumericAxisSpec(
//                     renderSpec: charts.GridlineRendererSpec(
//                       labelStyle: charts.TextStyleSpec(
//                         fontSize: 12,
//                         color: charts.MaterialPalette.black,
//                       ),
//                       lineStyle: charts.LineStyleSpec(
//                         color: charts.MaterialPalette.black,
//                       ),
//                     ),
//                     tickFormatterSpec: charts.BasicNumericTickFormatterSpec(
//                           (value) => '${value?.toDouble()} ${widget.valueUnits[0]}',
//                     ),
//                   ),
//                   behaviors: [
//                     charts.SelectNearest(
//                       eventTrigger: charts.SelectionTrigger.tap,
//                     ),
//                     // charts.SeriesLegend(
//                     //   position: charts.BehaviorPosition.bottom,
//                     //   showMeasures: true,
//                     //   measureFormatter: (num? value) {
//                     //     return value!.toStringAsFixed(0);
//                     //   },
//                     // ),
//                     charts.ChartTitle(
//                       'Date',
//                       behaviorPosition: charts.BehaviorPosition.bottom,
//                       titleOutsideJustification: charts.OutsideJustification.middleDrawArea,
//                     ),
//                     charts.ChartTitle(
//                       'Value',
//                       behaviorPosition: charts.BehaviorPosition.start,
//                       titleOutsideJustification: charts.OutsideJustification.middleDrawArea,
//                     ),
//                   ],
//                 ),
//               ),
//             ),
//             _buildLegend(),
//           ],
//         ),
//       ),
//     );
//   }
//
//   Widget _buildLegend() {
//     return SingleChildScrollView(
//       scrollDirection: Axis.horizontal,
//       child: Row(
//         children: widget.valueTypes.map((type) {
//           return Padding(
//             padding: const EdgeInsets.symmetric(horizontal: 8.0),
//             child: Row(
//               children: [
//                 Container(
//                   width: 12,
//                   height: 12,
//                   color: _getColor(widget.valueTypes.indexOf(type)).toDartColor(),
//                 ),
//                 SizedBox(width: 4),
//                 Text(
//                   selectedValues != null && selectedValues!.containsKey(type)
//                       ? '${type}: ${selectedValues![type]}'
//                       : type,
//                   style: TextStyle(fontSize: 12),
//                 ),
//               ],
//             ),
//           );
//         }).toList(),
//       ),
//     );
//   }
// }
//
// class GraphData {
//   final DateTime time;
//   final double value;
//
//   GraphData(this.time, this.value);
// }
//
// extension on charts.Color {
//   Color toDartColor() {
//     return Color.fromARGB(a, r, g, b);
//   }
// }
