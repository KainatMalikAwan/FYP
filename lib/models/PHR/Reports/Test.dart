import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:fyp/Services/config.dart';

class Test {
  late int? patientId; // Make patientId nullable
  final int labOfferId;
  final DateTime time;
  final List<ReportField> reportFields;

  Test({
    required this.patientId,
    required this.labOfferId,
    required this.time,
    required this.reportFields,
  });

  factory Test.fromJson(Map<String, dynamic> json) {
    return Test(
      patientId: null, // Initialize patientId to null
      labOfferId: json['labOfferId'],
      time: DateTime.parse(json['time']),
      reportFields: List<ReportField>.from((json['testReportField'] ?? []).map((x) => ReportField.fromJson(x))),
    );
  }

  Map<String, dynamic> toJson() {
    Map<String, dynamic> json = {
      'patientId':patientId,
      'labOfferId': labOfferId,
      'time': time.toIso8601String(),
      'data': reportFields.map((x) => x.toJson()).toList(),
    };


    return json;
  }
}

class ReportField {
  final int id;
  final String title;
  int? value;

  ReportField({
    required this.id,
    required this.title,
    this.value,
  });

  factory ReportField.fromJson(Map<String, dynamic> json) {
    return ReportField(
      id: json['id'],
      title: json['title'],
      value: json['value'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      "testReportFieldId": id,

      "observedValue": value,
    };
  }
}


