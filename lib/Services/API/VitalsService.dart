import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import '../config.dart';

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



}
