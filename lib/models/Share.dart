// share.dart
class Share {
  final int id;
  final int patientId;
  final int doctorId;
  final String type;
  final DateTime time;

  Share({
    required this.id,
    required this.patientId,
    required this.doctorId,
    required this.type,
    required this.time,
  });
}