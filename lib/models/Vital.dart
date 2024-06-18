import 'VitalObservedValue.dart';
import 'Vitals.dart';

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