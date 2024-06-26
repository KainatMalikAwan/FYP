import 'dart:convert';
import 'package:http/http.dart' as http;
import '../config.dart';

class SignupService {

  Future<http.Response> createPatient(Map<String, dynamic> patientData) async {
    final url = Uri.parse('${Config.baseUrl}/patients'); // Assuming the patient API endpoint

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
        // Optionally, you can parse and log the response body
        Map<String, dynamic> responseData = jsonDecode(response.body);
        print('Patient created successfully:');
        print(responseData);
      } else {
        // If the request was not successful, print the error message
        print('Failed to create patient. Error: ${response.body}');
      }

      return response; // Return the HTTP response
    } catch (error) {
      // Catch any potential errors and print them
      print('An error occurred while creating the patient: $error');
      rethrow; // Rethrow the error after logging it
    }
  }



  Future<http.Response> createDoctor(Map<String, dynamic> doctorData) async {
    final url = Uri.parse('${Config.baseUrlDoc}/doctors'); // Update with your actual URL

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
        // Optionally, you can parse and log the response body
        Map<String, dynamic> responseData = jsonDecode(response.body);
        print('Doctor created successfully:');
        print(responseData);
      } else {
        // If the request was not successful, print the error message
        print('Failed to create doctor. Error: ${response.body}');
      }

      return response; // Return the HTTP response
    } catch (error) {
      // Catch any potential errors and print them
      print('An error occurred while creating the doctor: $error');
      rethrow; // Rethrow the error after logging it
    }
  }
}
