// vitals_measure.dart
class VitalsMeasure {
  final int id;
  final DateTime time;
  final int patientId;
  final int vitalsId;

  VitalsMeasure({
    required this.id,
    required this.time,
    required this.patientId,
    required this.vitalsId,
  });
}