// recommendation.dart
class Recommendation {
  final int id;
  final int doctorId;
  final int patientId;
  final int testOfferId;
  final DateTime time;

  Recommendation({
    required this.id,
    required this.doctorId,
    required this.patientId,
    required this.testOfferId,
    required this.time,
  });
}