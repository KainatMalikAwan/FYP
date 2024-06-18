class VitalObservedValue {
  final int id;
  late final int observedValue;
  final int vitalsMeasureId;
  late final String readingType;

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

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'observedValue': observedValue,
      'vitalsMeasureId': vitalsMeasureId,
      'readingType': readingType,
    };
  }
}
