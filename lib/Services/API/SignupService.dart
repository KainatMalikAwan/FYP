import 'dart:convert';
import 'package:http/http.dart' as http;
import '../config.dart';

class SignupService {

  Future<void> createPatient(Map<String, dynamic> patientData) async {

    final url = Uri.parse('${Config.baseUrlDoc}/patients');// Assuming the patient API endpoint

    try {
      // Send POST request to create the patient
      http.Response response = await http.post(
        url,
        headers: {
          'Content-Type': 'application/json',
        },
        body: jsonEncode(patientData),
      );

      // Check if the request was successful (status code 200 or 201)
      if (response.statusCode == 200 || response.statusCode == 201) {
        // Parse the response body
        Map<String, dynamic> responseData = jsonDecode(response.body);
        print('Patient created successfully:');
        print(responseData);
      } else {
        // If the request was not successful, print the error message
        print('Failed to create patient. Error: ${response.body}');
      }
    } catch (error) {
      // Catch any potential errors and print them
      print('An error occurred while creating the patient: $error');
    }
  }

  Future<void> createDoctor(Map<String, dynamic> doctorData) async {
    final url = Uri.parse('${Config.baseUrl}/doctors'); // Update with your actual URL

    try {
      // Send POST request to create the doctor
      http.Response response = await http.post(
        url,
        headers: {
          'Content-Type': 'application/json',
        },
        body: jsonEncode(doctorData),
      );

      // Check if the request was successful (status code 200 or 201)
      if (response.statusCode == 200 || response.statusCode == 201) {
        // Parse the response body
        Map<String, dynamic> responseData = jsonDecode(response.body);
        print('Doctor created successfully:');
        print(responseData);
      } else {
        // If the request was not successful, print the error message
        print('Failed to create doctor. Error: ${response.body}');
      }
    } catch (error) {
      // Catch any potential errors and print them
      print('An error occurred while creating the doctor: $error');
    }
  }
}
