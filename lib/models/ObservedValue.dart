// observed_value.dart
class ObservedValue {
  final int id;
  final int testReportFieldId;
  final int testAddedByPatientId;
  final double observedValue;
  final String status;

  ObservedValue({
    required this.id,
    required this.testReportFieldId,
    required this.testAddedByPatientId,
    required this.observedValue,
    required this.status,
  });
}