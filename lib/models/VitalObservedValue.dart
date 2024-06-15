
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

  factory VitalObservedValue.fromJson(Map<String, dynamic> json) {
    return VitalObservedValue(
      id: json['id'],
      observedValue: json['observedValue'],
      vitalsMeasureId: json['vitalsMeasureId'],
      readingType: json['readingType'],
    );
  }
}