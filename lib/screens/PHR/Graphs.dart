import 'dart:math';
import 'package:flutter/material.dart';
import 'package:charts_flutter/flutter.dart' as charts;

class CustomGraphWidget extends StatefulWidget {
  final List<DateTime> dates;
  final List<List<int>> measuredValues;
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
  late int minValue;
  late int maxValue;

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
    List<List<int>> sortedMeasuredValues = sortedData.map((e) => e.value).toList();

    dataSeries = _createChartData(sortedDates, sortedMeasuredValues, widget.valueTypes);
    minDate = sortedDates.first;
    maxDate = sortedDates.last;
    minValue = _calculateMinValue(sortedMeasuredValues);
    maxValue = _calculateMaxValue(sortedMeasuredValues);
  }

  List<MapEntry<DateTime, List<int>>> _sortData(List<DateTime> dates, List<List<int>> measuredValues) {
    List<MapEntry<DateTime, List<int>>> pairedData = [];

    for (int i = 0; i < dates.length; i++) {
      List<int> valuesAtI = [];
      for (int j = 0; j < measuredValues.length; j++) {
        valuesAtI.add(measuredValues[j][i]);
      }
      pairedData.add(MapEntry(dates[i], valuesAtI));
    }

    pairedData.sort((a, b) => a.key.compareTo(b.key));
    return pairedData;
  }

  List<charts.Series<GraphData, DateTime>> _createChartData(List<DateTime> dates, List<List<int>> values, List<String> types) {
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

  int _calculateMinValue(List<List<int>> values) {
    int minVal = values.expand((e) => e).reduce(min);
    return minVal;
  }

  int _calculateMaxValue(List<List<int>> values) {
    int maxVal = values.expand((e) => e).reduce(max);
    return maxVal;
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(8.0),
      height: 400, // Example fixed height, adjust as needed
      child: charts.TimeSeriesChart(
        dataSeries,
        animate: true,
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
                (value) => '${value?.toInt()} ${widget.valueUnits[0]}',
          ),
        ),
        behaviors: [
          charts.SeriesLegend(
            position: charts.BehaviorPosition.bottom,
            showMeasures: true,
            measureFormatter: (num? value) {
              return value!.toStringAsFixed(0);
            },
          ),
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
    );
  }
}

class GraphData {
  final DateTime time;
  final int value;

  GraphData(this.time, this.value);
}







//  use below grph  code if above caue issue

//
// //---------------------------- backup code for graph secreen
// import 'dart:math';
// import 'package:flutter/material.dart';
// import 'package:charts_flutter/flutter.dart' as charts;
//
// //
// //
// // class GraphScreen extends StatefulWidget {
// //   final List<DateTime> dates;
// //   final List<List<int>> measuredValues;
// //   final List<String> valueTypes;
// //   final List<String> valueUnits;
// //
// //   GraphScreen({
// //     required this.dates,
// //     required this.measuredValues,
// //     required this.valueTypes,
// //     required this.valueUnits,
// //   });
// //
// //   @override
// //   _GraphScreenState createState() => _GraphScreenState();
// // }
// //
// // class _GraphScreenState extends State<GraphScreen> {
// //   @override
// //   Widget build(BuildContext context) {
// //     return Scaffold(
// //
// //       body: SingleChildScrollView(
// //         child: Padding(
// //           padding: EdgeInsets.all(16.0),
// //           child: Column(
// //             crossAxisAlignment: CrossAxisAlignment.stretch,
// //             children: [
// //               CustomGraphWidget(
// //                 dates: widget.dates,
// //                 measuredValues: widget.measuredValues,
// //                 valueTypes: widget.valueTypes,
// //                 valueUnits: widget.valueUnits,
// //               ),
// //             ],
// //           ),
// //         ),
// //       ),
// //     );
// //   }
// // }
//
// class GraphScreen extends StatefulWidget {
//   final List<DateTime> dates;
//   final List<List<int>> measuredValues;
//   final List<String> valueTypes;
//   final List<String> valueUnits;
//
//   GraphScreen({
//     required this.dates,
//     required this.measuredValues,
//     required this.valueTypes,
//     required this.valueUnits,
//   });
//
//   @override
//   _GraphScreenState createState() => _GraphScreenState();
// }
//
// class _GraphScreenState extends State<GraphScreen> {
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: Text('Custom Graph Widget Example'),
//       ),
//       body: SingleChildScrollView(
//         child: Padding(
//           padding: EdgeInsets.all(16.0),
//           child: Column(
//             crossAxisAlignment: CrossAxisAlignment.stretch,
//             children: [
//               CustomGraphWidget(
//                 dates: widget.dates,
//                 measuredValues: widget.measuredValues,
//                 valueTypes: widget.valueTypes,
//                 valueUnits: widget.valueUnits,
//               ),
//             ],
//           ),
//         ),
//       ),
//     );
//   }
// }
//
// class CustomGraphWidget extends StatefulWidget {
//   final List<DateTime> dates;
//   final List<List<int>> measuredValues;
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
//   late int minValue;
//   late int maxValue;
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
//     List<List<int>> sortedMeasuredValues = sortedData.map((e) => e.value).toList();
//
//     dataSeries = _createChartData(sortedDates, sortedMeasuredValues, widget.valueTypes);
//     minDate = sortedDates.first;
//     maxDate = sortedDates.last;
//     minValue = _calculateMinValue(sortedMeasuredValues);
//     maxValue = _calculateMaxValue(sortedMeasuredValues);
//   }
//
//   List<MapEntry<DateTime, List<int>>> _sortData(List<DateTime> dates, List<List<int>> measuredValues) {
//     List<MapEntry<DateTime, List<int>>> pairedData = [];
//
//     for (int i = 0; i < dates.length; i++) {
//       List<int> valuesAtI = [];
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
//   @override
//   Widget build(BuildContext context) {
//     return Column(
//       crossAxisAlignment: CrossAxisAlignment.stretch,
//       children: [
//         // _buildDropdowns(),
//         _buildChart(),
//       ],
//     );
//   }
//
//   Widget _buildDropdowns() {
//     return Padding(
//       padding: const EdgeInsets.all(8.0),
//       child: Column(
//         crossAxisAlignment: CrossAxisAlignment.start,
//         children: [
//           DropdownButton<int>(
//             value: null,
//             onChanged: (int? newValue) {},
//             hint: Text('Select Year (Not Implemented)'),
//             items: [],
//           ),
//           SizedBox(height: 10),
//           DropdownButton<int>(
//             value: null,
//             onChanged: (int? newValue) {},
//             hint: Text('Select Month (Not Implemented)'),
//             items: [],
//           ),
//         ],
//       ),
//     );
//   }
//
//   List<charts.Series<GraphData, DateTime>> _createChartData(List<DateTime> dates, List<List<int>> values, List<String> types) {
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
//   int _calculateMinValue(List<List<int>> values) {
//     int minVal = values.expand((e) => e).reduce(min);
//     return minVal;
//   }
//
//   int _calculateMaxValue(List<List<int>> values) {
//     int maxVal = values.expand((e) => e).reduce(max);
//     return maxVal;
//   }
//
//   Widget _buildChart() {
//     return Container(
//       padding: EdgeInsets.all(8.0),
//       height: 400, // Example fixed height, adjust as needed
//       child: charts.TimeSeriesChart(
//         dataSeries,
//         animate: true,
//         domainAxis: charts.DateTimeAxisSpec(
//           tickFormatterSpec: charts.AutoDateTimeTickFormatterSpec(
//             day: charts.TimeFormatterSpec(
//               format: 'dd-MM',
//               transitionFormat: 'dd-MM-yyyy',
//             ),
//           ),
//           renderSpec: charts.SmallTickRendererSpec(
//             labelStyle: charts.TextStyleSpec(
//               fontSize: 12,
//               color: charts.MaterialPalette.black,
//             ),
//             lineStyle: charts.LineStyleSpec(
//               color: charts.MaterialPalette.black,
//             ),
//           ),
//         ),
//         primaryMeasureAxis: charts.NumericAxisSpec(
//           renderSpec: charts.GridlineRendererSpec(
//             labelStyle: charts.TextStyleSpec(
//               fontSize: 12,
//               color: charts.MaterialPalette.black,
//             ),
//             lineStyle: charts.LineStyleSpec(
//               color: charts.MaterialPalette.black,
//             ),
//           ),
//           tickFormatterSpec: charts.BasicNumericTickFormatterSpec(
//                 (value) => '${value?.toInt()} ${widget.valueUnits[0]}',
//           ),
//         ),
//         behaviors: [
//           charts.SeriesLegend(
//             position: charts.BehaviorPosition.bottom,
//             showMeasures: true,
//             measureFormatter: (num? value) {
//               return value!.toStringAsFixed(0);
//             },
//           ),
//           charts.ChartTitle(
//             'Date',
//             behaviorPosition: charts.BehaviorPosition.bottom,
//             titleOutsideJustification: charts.OutsideJustification.middleDrawArea,
//           ),
//           charts.ChartTitle(
//             'Value',
//             behaviorPosition: charts.BehaviorPosition.start,
//             titleOutsideJustification: charts.OutsideJustification.middleDrawArea,
//           ),
//         ],
//       ),
//     );
//   }
// }
//
// class GraphData {
//   final DateTime time;
//   final int value;
//
//   GraphData(this.time, this.value);
// }
