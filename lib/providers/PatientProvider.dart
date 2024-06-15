import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/patient.dart';

class PatientProvider extends ChangeNotifier {
  Patient? _patient;

  Patient? get patient => _patient;

  void setPatient(Patient patient) {
    _patient = patient;
    savePatient();
    notifyListeners();
  }

  void clearPatient() {
    _patient = null;
    removePatient();
    notifyListeners();
  }

  Future<void> savePatient() async {
    final prefs = await SharedPreferences.getInstance();
    if (_patient != null) {
      final patientJson = jsonEncode(_patient!.toJson()); // Serialize to JSON
      await prefs.setString('patient', patientJson);
    }
  }

  Future<void> loadPatient() async {
    final prefs = await SharedPreferences.getInstance();
    final patientData = prefs.getString('patient');
    if (patientData != null) {
      final decodedData = jsonDecode(patientData); // Deserialize from JSON
      _patient = Patient.fromJson(decodedData);
      notifyListeners();
    }
  }

  Future<void> removePatient() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove('patient');
  }
}
