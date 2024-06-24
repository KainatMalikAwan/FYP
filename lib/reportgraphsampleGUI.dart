import 'dart:math';
import 'package:flutter/material.dart';
import 'package:charts_flutter/flutter.dart' as charts;

void main() {
  runApp(MaterialApp(
    home: Scaffold(
      appBar: AppBar(
        title: Text('Custom Graph Widget Example'),
      ),
      body: CustomGraphWidget(
        dates: [
          DateTime(2034, 8, 1),
          DateTime(2043, 9, 2),
          DateTime(2023, 11, 3),
          DateTime(2023, 12, 4),
          DateTime(2010, 5, 19),
        ],
        measuredValues: [
          [2000, 0, 90, 95, 1000],
          [560, 0, 90, 95, 10],
        ],
        valueTypes: [
          'Hemoglobin',
          'White Blood Cells (WBC)',
          'Platelets',
          'Red Blood Cells (RBC)',
          'Neutrophils',
          'Lymphocytes',
          'Monocytes',
          'Eosinophils',
          'Basophils',
          'Mean Corpuscular Volume (MCV)',
        ],
        valueUnits: ['mg/dL'],
      ),
    ),
  ));
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
  List<bool> seriesVisibility = [];

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

    // Initialize series visibility
    seriesVisibility = List.filled(widget.valueTypes.length, true);
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
          measureFn: (GraphData data, _) => seriesVisibility[i] ? data.value : null,
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

  void _toggleSeriesVisibility(int seriesIndex) {
    setState(() {
      seriesVisibility[seriesIndex] = !seriesVisibility[seriesIndex];
      dataSeries[seriesIndex] = charts.Series<GraphData, DateTime>(
        id: widget.valueTypes[seriesIndex],
        colorFn: (_, __) => _getColor(seriesIndex),
        domainFn: (GraphData data, _) => data.time,
        measureFn: (GraphData data, _) => seriesVisibility[seriesIndex] ? data.value : null,
        data: dataSeries[seriesIndex].data!,
        labelAccessorFn: (GraphData data, _) => '${widget.valueTypes[seriesIndex]}: ${data.value}',
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Container(
        width: MediaQuery.of(context).size.width,
        padding: EdgeInsets.all(8.0),
        child: Column(
          children: [
            SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Container(
                width: max(800, MediaQuery.of(context).size.width),
                height: 400,
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
                    charts.SeriesLegend(
                      position: charts.BehaviorPosition.bottom,
                      showMeasures: true,
                      measureFormatter: (num? value) {
                        return value!.toStringAsFixed(0);
                      },
                      desiredMaxColumns: 2,
                      cellPadding: EdgeInsets.symmetric(horizontal: 4.0),
                      entryTextStyle: charts.TextStyleSpec(
                        fontSize: 12,
                        color: charts.MaterialPalette.black,
                      ),
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
        children: widget.valueTypes.asMap().entries.map((entry) {
          int index = entry.key;
          String type = entry.value;
          return Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8.0),
            child: GestureDetector(
              onTap: () {
                _toggleSeriesVisibility(index);
              },
              child: Row(
                children: [
                  Container(
                    width: 12,
                    height: 12,
                    color: seriesVisibility[index] ? _getColor(index).toDartColor() : Colors.grey,
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
