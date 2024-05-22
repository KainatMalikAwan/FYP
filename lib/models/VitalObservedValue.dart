// vital_observed_value.dart
class VitalObservedValue {
  final int id;
  final int observedValue;
  final int vitalsMeasureId;
  final String readingType;

  VitalObservedValue({
    required this.id,
    required this.observedValue,
    required this.vitalsMeasureId,
    required this.readingType,
  });
}