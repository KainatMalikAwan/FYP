// medicine_recommendation.dart
class MedicineRecommendation {
  final int id;
  final String dosage;
  final int medicineId;
  final int patientId;
  final int doctorId;

  MedicineRecommendation({
    required this.id,
    required this.dosage,
    required this.medicineId,
    required this.patientId,
    required this.doctorId,
  });
}

