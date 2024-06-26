import 'package:http/http.dart' as http;
import 'dart:convert';
import '../../../models/PHR/Reports/Test.dart';
import '../../../models/PHR/Reports/Lab.dart';
import '../../../models/PHR/Reports/LabTestOffer.dart';
import '../../config.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:fyp/models/PHR/Reports/TestData.dart';

class ReportsService {
  Future<List<LabTestOffer>> fetchTestOffersByLabId(int labId) async {
    final response = await http.get(Uri.parse('${Config.baseUrl}/test-offers/laboffer/$labId'));

    if (response.statusCode == 200) {
      final parsed = jsonDecode(response.body);
      List<LabTestOffer> testOffers = (parsed['data'] as List)
          .map((json) => LabTestOffer.fromJson(json))
          .toList();

      return testOffers;
    } else {
      throw Exception('Failed to load test offers');
    }
  }

  Future<List<Lab>> fetchLabs() async {
    final response = await http.get(Uri.parse('${Config.baseUrl}/labs'));

    if (response.statusCode == 200) {
      List<dynamic> data = jsonDecode(response.body)['data'];
      List<Lab> labs = data.map((json) => Lab.fromJson(json)).toList();
      return labs;
    } else {
      throw Exception('Failed to load labs');
    }
  }


  Future<Test> fetchTestFormat(int id) async {
    try {
      final response = await http.get(
          Uri.parse('${Config.baseUrl}/test-offers/$id'));

      if (response.statusCode == 200) {
        final jsonData = jsonDecode(response.body);

        // Parse the JSON into Test object
        final test = Test.fromJson({
          'labOfferId': jsonData['data']['LabOffer'][0]['id'],
          // Assuming LabOffer is a list with one element
          'time': "2024-06-21T12:00:00Z",
          // Replace with actual datetime parsing
          'testReportField': jsonData['data']['testReportField'],
        });
        print('patt ID: ${test.patientId}');
        print('Lab Offer ID: ${test.labOfferId}');
        print('Time: ${test.time}');
        print('Report Fields:');
        for (var field in test.reportFields) {
          print('  ${field.title}: ${field.value}');
        }

        return test;
      } else {
        throw Exception('Failed to load data: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Error fetching data: $e');
    }
  }

  Future<List<Map<String, dynamic>>> uploadPatientTest(Test test) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final int? patientId = prefs.getInt('Patient-id');
      test.patientId = patientId ?? 0; // Set patientId from SharedPreferences or default value
      print('---patient ID: ${test.patientId}');
      print('---Lab Offer ID: ${test.labOfferId}');
      print('---Time: ${test.time}');
      print('Report Fields:');
      for (var field in test.reportFields) {
        print(' ----- ${field.title}: ${field.value}');
      }
      print(test.toJson());

      const String apiUrl = '${Config.baseUrl}/create-observed-values';
      final response = await http.post(
        Uri.parse(apiUrl),
        headers: {
          'Content-Type': 'application/json',
        },
        body: jsonEncode(test.toJson()),
      );

      if (response.statusCode == 201) {
        print('Data uploaded successfully');
        // Parse the JSON response
        final List responseData = jsonDecode(response.body);

        // Create a list of maps containing the relevant data
        final List<Map<String, dynamic>> result = responseData.map((item) {
          return {
            'fieldName': item['testReportField']['title'],
            'observedValue': item['observedValue'],
            'status': item['status'],
          };
        }).toList();

        return result; // Return the parsed data
      } else {
        throw Exception('Failed to upload data: ${response.reasonPhrase}');
      }
    } catch (e) {
      throw Exception('Error uploading data: $e');
    }
  }

  Future<List<TestData>> fetchTestData(int patientId) async {
    try {
      final response = await http.get(Uri.parse('${Config.baseUrl}/tests/testreportwithresult/$patientId'));

      if (response.statusCode == 200) {
        final jsonResponse = jsonDecode(response.body);
        ResponseData responseData = ResponseData.fromJson(jsonResponse);
        List<TestData> data = responseData.data;
        return data;
      } else {
        throw Exception('Failed to load test data');
      }
    } catch (e) {
      print('Error fetching test data: $e');
      throw Exception('Failed to load test data: $e');
    }
  }



}
