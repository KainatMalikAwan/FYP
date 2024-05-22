// vitals_value_range.dart
class VitalsValueRange {
  final int id;
  final int ageMin;
  final int ageMax;
  final double min;
  final double max;
  final String gender;
  final int vitalsId;

  VitalsValueRange({
    required this.id,
    required this.ageMin,
    required this.ageMax,
    required this.min,
    required this.max,
    required this.gender,
    required this.vitalsId,
  });
}
