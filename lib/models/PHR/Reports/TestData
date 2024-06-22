
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
      observedValue: (json['observedValue'] is int)
          ? (json['observedValue'] as int).toDouble()
          : json['observedValue'],
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
    list.map((i) => ObservationValue.fromJson(i)).toList();

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
    list.map((i) => TestReportField.fromJson(i)).toList();

    return TestData(
      testAddedByPatientId: json['testAddedByPatientId'],
      name: json['name'],
      time: DateTime.parse(json['time']),
      testReportField: testReportFieldList,
    );
  }
}

class ResponseData {
  final List<TestData> data;

  ResponseData({
    required this.data,
  });

  factory ResponseData.fromJson(Map<String, dynamic> json) {
    var list = json['data'] as List;
    List<TestData> testDataList = list.map((i) => TestData.fromJson(i)).toList();

    return ResponseData(data: testDataList);
  }
}
