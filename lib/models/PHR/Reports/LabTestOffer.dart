// lab_test_offer.dart
class LabTestOffer {
  final int testOfferId;
  final String testName;

  LabTestOffer({required this.testOfferId, required this.testName});

  factory LabTestOffer.fromJson(Map<String, dynamic> json) {
    return LabTestOffer(
      testOfferId: json['id'],
      testName: json['test']['name'],
    );
  }
}