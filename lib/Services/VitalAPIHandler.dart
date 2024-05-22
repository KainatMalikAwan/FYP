import 'dart:convert';
import 'package:http/http.dart' as http;

class VitalAPIHandler {
  final String baseURL;
  final String token;

  VitalAPIHandler(this.baseURL, this.token);

  /// Creates vitals record.
  Future<void> createVitals(Map<String, dynamic> data) async {
    try {
      final response = await http.post(
        Uri.parse('$baseURL/vitals'),
        headers: {'Authorization': 'Bearer $token', 'Content-Type': 'application/json'},
        body: jsonEncode(data),
      );
      if (response.statusCode != 200) {
        throw Exception('Failed to create vitals: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Failed to create vitals: $e');
    }
  }

  /// Creates a new measure record.
  Future<void> createMeasure(Map<String, dynamic> data) async {
    try {
      final response = await http.post(
        Uri.parse('$baseURL/measures'),
        headers: {
          'Authorization': 'Bearer $token',
          'Content-Type': 'application/json',
        },
        body: jsonEncode(data),
      );
      if (response.statusCode != 200) {
        throw Exception('Failed to create Measure: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Failed to create Measure: $e');
    }
  }

  /// Retrieves all measures of a specific patient.
  Future<void> getAllMeasuresOfPatient(String patientId) async {
    try {
      final response = await http.get(
        Uri.parse('$baseURL/measures/patient/$patientId'),
        headers: {
          'Authorization': 'Bearer $token',
          'Content-Type': 'application/json',
        },
      );

      if (response.statusCode == 200) {
        print('All Measures of Patient: ${response.body}');
      } else {
        throw Exception('Failed to fetch Measures of Patient: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Failed to fetch Measures of Patient: $e');
    }
  }

  /// Retrieves a measure by its ID.
  Future<void> getMeasureById(String measureId) async {
    try {
      final response = await http.get(
        Uri.parse('$baseURL/measures/$measureId'),
        headers: {
          'Authorization': 'Bearer $token',
          'Content-Type': 'application/json',
        },
      );

      if (response.statusCode == 200) {
        print('Measure by ID: ${response.body}');
      } else {
        throw Exception('Failed to fetch Measure by ID: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Failed to fetch Measure by ID: $e');
    }
  }

  /// Updates a measure.
  Future<void> updateMeasure(String measureId, Map<String, dynamic> data) async {
    try {
      final response = await http.put(
        Uri.parse('$baseURL/measures/$measureId'),
        headers: {
          'Authorization': 'Bearer $token',
          'Content-Type': 'application/json',
        },
        body: jsonEncode(data),
      );

      if (response.statusCode != 200) {
        throw Exception('Failed to update Measure: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Failed to update Measure: $e');
    }
  }

  /// Deletes a measure by its ID.
  Future<void> deleteMeasure(String measureId) async {
    try {
      final response = await http.delete(
        Uri.parse('$baseURL/measures/$measureId'),
        headers: {
          'Authorization': 'Bearer $token',
          'Content-Type': 'application/json',
        },
      );

      if (response.statusCode != 200) {
        throw Exception('Failed to delete Measure: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Failed to delete Measure: $e');
    }
  }
}
