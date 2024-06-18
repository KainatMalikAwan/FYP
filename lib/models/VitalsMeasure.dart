
import 'package:fyp/models/VitalObservedValue.dart';

class VitalsMeasure {
  final int vitalsMeasureId;
   final DateTime time;
  final List<VitalObservedValue> vitalObservedValues;

  VitalsMeasure({
    required this.vitalsMeasureId,
    required this.time,
    required this.vitalObservedValues,
  });



  Map<String, dynamic> toJson() {
    return {
      'vitalsMeasureId': vitalsMeasureId,
      'time': time.toIso8601String(),
      'vitalObservedValues': vitalObservedValues.map((v) => v.toJson()).toList(),
    };
  }
}
