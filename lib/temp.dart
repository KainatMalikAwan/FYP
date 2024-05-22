import 'dart:convert';
import 'package:http/http.dart' as http;

class ApiCaller {
  static const String baseUrl = 'http://192.168.18.61:3000';
  static const String token = 'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpZCI6NCwicm9sZSI6InBhdGllbnQiLCJpYXQiOjE3MDU4OTAwNjcsImV4cCI6MTcwNTg5MzY2N30.wIcaxoT15SQJM-ghRiqinVnAKnRgwRiqEgLvEUvYzDI';

  static Future<void> getAllMeasuresOfPatient(int patientId) async {
    try {
      final response = await http.get(
        Uri.parse('$baseUrl/measures/patient/$patientId'),
        headers: {
          'Authorization': 'Bearer $token',
          'Content-Type': 'application/json',
        },
      );

      if (response.statusCode == 200) {
        final responseData = jsonDecode(response.body);
        print(responseData);
      } else {
        throw Exception('Failed to fetch measures of patient: ${response.statusCode}');
      }
    } catch (e) {
      print('Error: $e');
    }
  }
}

void main() {
  ApiCaller.getAllMeasuresOfPatient(3);
}
