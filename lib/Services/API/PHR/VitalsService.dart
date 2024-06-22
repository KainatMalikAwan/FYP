import 'dart:convert';
import 'package:http/http.dart' as http;
import '../../../models/VitalsMeasure.dart';
import '../../config.dart';

class VitalsServices {
  String token = ''; // This should be dynamically set, possibly through a constructor or a method.

  Future<void> deleteMeasure(int measureId) async {
    final url = Uri.parse('${Config.baseUrl}/measures/$measureId');
    try {
      final response = await http.delete(
        url,
        headers: {
          'Authorization': 'Bearer $token',
          'Content-Type': 'application/json',
        },
      );

      if (response.statusCode == 200) {
        print('Measure deleted successfully');
      } else {
        print('Failed to delete measure: ${response.statusCode}');
      }
    } catch (e) {
      print('Failed to delete measure: $e');
    }
  }




  /////////////---------------------update vitals api

    Future<void> updateMeasure(VitalsMeasure measure) async {
    final url = Uri.parse('${Config.baseUrl}/measures');
    final headers = {'Content-Type': 'application/json'};
    final body = json.encode(measure.toJson());

    try {
      final response = await http.put(url, headers: headers, body: body);
      if (response.statusCode == 200) {
        print('Success: ${response.body}');
      } else {
        print('Failed with status code: ${response.statusCode}');
        print('Response: ${response.body}');
      }
    } catch (e) {
      print('Error: $e');
    }
  }
/////////////--------------------- end update vitals api

}
