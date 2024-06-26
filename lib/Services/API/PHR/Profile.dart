import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:fyp/Services/config.dart';

import 'dart:convert';
import 'package:http/http.dart' as http;

///////////////////////Edit main patient profile//////////////////////
import 'dart:convert';
import 'package:http/http.dart' as http;

Future<http.Response> editPatient(String patientId, Map<String, dynamic> patientData) async {
  final String url = '${Config.baseUrl}/patients/$patientId';
  final response = await http.put(
    Uri.parse(url),
    headers: {
      'Content-Type': 'application/json',
    },
    body: json.encode(patientData),
  );

  if (response.statusCode == 200) {
    print('Patient updated successfully');
  } else {
    print('Failed to update patient: ${response.statusCode}');
    print('Response body: ${response.body}');
  }

  return response; // Return the response object
}

