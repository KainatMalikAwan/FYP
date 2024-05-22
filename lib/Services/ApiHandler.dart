import 'dart:convert';
import 'package:http/http.dart' as http;

class APIHandler {
  final String baseLink;

  APIHandler({required this.baseLink});

  Future<Map<String, dynamic>> signIn(String email, String password) async {
    final response = await http.post(
      Uri.parse('$baseLink/auth/signin'),
      headers: <String, String>{
        'Content-Type': 'application/json',
      },
      body: jsonEncode(<String, String>{
        'email': email,
        'password': password,
      }),
    );

    if (response.statusCode == 200) {
      return json.decode(response.body);
    } else {
      throw Exception('Failed to sign in');
    }
  }

  Future<Map<String, dynamic>> getAllCommentsForRecommendation(int recommendationId) async {
    final response = await http.get(Uri.parse('$baseLink/comments/recommendationsComment/$recommendationId'));

    if (response.statusCode == 200) {
      return json.decode(response.body);
    } else {
      throw Exception('Failed to get comments');
    }
  }

  Future<Map<String, dynamic>> getCommentById(int commentId) async {
    final response = await http.get(Uri.parse('$baseLink/comments/$commentId'));

    if (response.statusCode == 200) {
      return json.decode(response.body);
    } else {
      throw Exception('Failed to get comment');
    }
  }

  Future<Map<String, dynamic>> createComment(String comment, int recommendationId) async {
    final response = await http.post(
      Uri.parse('$baseLink/comments'),
      headers: <String, String>{
        'Content-Type': 'application/json',
      },
      body: jsonEncode(<String, dynamic>{
        'comment': comment,
        'recommendationId': recommendationId,
      }),
    );

    if (response.statusCode == 201) {
      return json.decode(response.body);
    } else {
      throw Exception('Failed to create comment');
    }
  }

  Future<void> updateComment(int commentId, String updatedComment) async {
    final response = await http.put(
      Uri.parse('$baseLink/comments/$commentId'),
      headers: <String, String>{
        'Content-Type': 'application/json',
      },
      body: jsonEncode(<String, String>{
        'comment': updatedComment,
      }),
    );

    if (response.statusCode != 204) {
      throw Exception('Failed to update comment');
    }
  }

  Future<void> deleteComment(int commentId) async {
    final response = await http.delete(Uri.parse('$baseLink/comments/delete/$commentId'));

    if (response.statusCode != 204) {
      throw Exception('Failed to delete comment');
    }
  }

  Future<Map<String, dynamic>> createDisease(String name) async {
    final response = await http.post(
      Uri.parse('$baseLink/diseases'),
      headers: <String, String>{
        'Content-Type': 'application/json',
      },
      body: jsonEncode(<String, String>{
        'name': name,
      }),
    );

    if (response.statusCode == 201) {
      return json.decode(response.body);
    } else {
      throw Exception('Failed to create disease');
    }
  }

  Future<void> updateDisease(int diseaseId, String updatedName) async {
    final response = await http.put(
      Uri.parse('$baseLink/diseases/update/$diseaseId'),
      headers: <String, String>{
        'Content-Type': 'application/json',
      },
      body: jsonEncode(<String, String>{
        'name': updatedName,
      }),
    );

    if (response.statusCode != 204) {
      throw Exception('Failed to update disease');
    }
  }

  Future<Map<String, dynamic>> getSingleDisease(int diseaseId) async {
    final response = await http.get(Uri.parse('$baseLink/diseases/$diseaseId'));

    if (response.statusCode == 200) {
      return json.decode(response.body);
    } else {
      throw Exception('Failed to get disease');
    }
  }

  Future<List<dynamic>> getAllDiseases() async {
    final response = await http.get(Uri.parse('$baseLink/diseases'));

    if (response.statusCode == 200) {
      return json.decode(response.body);
    } else {
      throw Exception('Failed to get diseases');
    }
  }

  Future<void> deleteDisease(int diseaseId) async {
    final response = await http.delete(Uri.parse('$baseLink/diseases/delete/$diseaseId'));

    if (response.statusCode != 204) {
      throw Exception('Failed to delete disease');
    }
  }

  Future<List<dynamic>> getAllDiseaseToPatients() async {
    final response = await http.get(Uri.parse('$baseLink/disease-to-patient'));

    if (response.statusCode == 200) {
      return json.decode(response.body);
    } else {
      throw Exception('Failed to get disease to patients');
    }
  }

  Future<Map<String, dynamic>> getDiseaseToPatientById(int diseaseToPatientId) async {
    final response = await http.get(Uri.parse('$baseLink/disease-to-patient/$diseaseToPatientId'));

    if (response.statusCode == 200) {
      return json.decode(response.body);
    } else {
      throw Exception('Failed to get disease to patient');
    }
  }

  Future<Map<String, dynamic>> createDiseaseToPatient(int patientId, int diseaseId) async {
    final response = await http.post(
      Uri.parse('$baseLink/disease-to-patient'),
      headers: <String, String>{
        'Content-Type': 'application/json',
      },
      body: jsonEncode(<String, dynamic>{
        'patientId': patientId,
        'diseaseId': diseaseId,
      }),
    );

    if (response.statusCode == 201) {
      return json.decode(response.body);
    } else {
      throw Exception('Failed to create disease to patient');
    }
  }

  Future<List<dynamic>> getAllDoctors() async {
    final response = await http.get(Uri.parse('$baseLink/doctors'));

    if (response.statusCode == 200) {
      return json.decode(response.body);
    } else {
      throw Exception('Failed to get doctors');
    }
  }

  Future<Map<String, dynamic>> getDoctorById(int doctorId) async {
    final response = await http.get(Uri.parse('$baseLink/doctors/$doctorId'));

    if (response.statusCode == 200) {
      return json.decode(response.body);
    } else {
      throw Exception('Failed to get doctor');
    }
  }

  Future<Map<String, dynamic>> createDoctor(String phone, String email, String gender, int age, String cnic, String name, String specialization, String password) async {
    final response = await http.post(
      Uri.parse('$baseLink/doctors'),
      headers: <String, String>{
        'Content-Type': 'application/json',
      },
      body: jsonEncode(<String, dynamic>{
        'phone': phone,
        'email': email,
        'gender': gender,
        'age': age,
        'cnic': cnic,
        'name': name,
        'specialization': specialization,
        'password': password,
      }),
    );

    if (response.statusCode == 201) {
      return json.decode(response.body);
    } else {
      throw Exception('Failed to create doctor');
    }
  }

  Future<void> updateDoctor(int doctorId, String phone, String email, String gender, int age, String cnic, String name, String specialization) async {
    final response = await http.put(
      Uri.parse('$baseLink/doctors/$doctorId'),
      headers: <String, String>{
        'Content-Type': 'application/json',
      },
      body: jsonEncode(<String, dynamic>{
        'phone': phone,
        'email': email,
        'gender': gender,
        'age': age,
        'cnic': cnic,
        'name': name,
        'specialization': specialization,
      }),
    );

    if (response.statusCode != 204) {
      throw Exception('Failed to update doctor');
    }
  }

  Future<void> deleteDoctor(int doctorId) async {
    final response = await http.delete(Uri.parse('$baseLink/doctors/$doctorId'));

    if (response.statusCode != 204) {
      throw Exception('Failed to delete doctor');
    }
  }

  Future<List<dynamic>> getAllLabs() async {
    final response = await http.get(Uri.parse('$baseLink/labs'));

    if (response.statusCode == 200) {
      return json.decode(response.body);
    } else {
      throw Exception('Failed to get labs');
    }
  }

  Future<Map<String, dynamic>> getLabById(int labId) async {
    final response = await http.get(Uri.parse('$baseLink/labs/$labId'));

    if (response.statusCode == 200) {
      return json.decode(response.body);
    } else {
      throw Exception('Failed to get lab');
    }
  }

  Future<Map<String, dynamic>> createLab(String name) async {
    final response = await http.post(
      Uri.parse('$baseLink/labs'),
      headers: <String, String>{
        'Content-Type': 'application/json',
      },
      body: jsonEncode(<String, String>{
        'name': name,
      }),
    );

    if (response.statusCode == 201) {
      return json.decode(response.body);
    } else {
      throw Exception('Failed to create lab');
    }
  }

  Future<void> updateLab(int labId, String updatedName) async {
    final response = await http.put(
      Uri.parse('$baseLink/labs/$labId'),
      headers: <String, String>{
        'Content-Type': 'application/json',
      },
      body: jsonEncode(<String, String>{
        'name': updatedName,
      }),
    );

    if (response.statusCode != 204) {
      throw Exception('Failed to update lab');
    }
  }

  Future<void> deleteLab(int labId) async {
    final response = await http.delete(Uri.parse('$baseLink/labs/$labId'));

    if (response.statusCode != 204) {
      throw Exception('Failed to delete lab');
    }
  }

  Future<List<dynamic>> getAllMedicines() async {
    final response = await http.get(Uri.parse('$baseLink/medicines'));

    if (response.statusCode == 200) {
      return json.decode(response.body);
    } else {
      throw Exception('Failed to get medicines');
    }
  }

  Future<Map<String, dynamic>> getMedicineById(int medicineId) async {
    final response = await http.get(Uri.parse('$baseLink/medicines/$medicineId'));

    if (response.statusCode == 200) {
      return json.decode(response.body);
    } else {
      throw Exception('Failed to get medicine');
    }
  }

  Future<void> createMedicine(String name) async {
    final response = await http.post(
      Uri.parse('$baseLink/medicines'),
      headers: <String, String>{
        'Content-Type': 'application/json',
      },
      body: jsonEncode(<String, String>{
        'name': name,
      }),
    );

    if (response.statusCode != 201) {
      throw Exception('Failed to create medicine');
    }
  }

  Future<void> deleteMedicine(int medicineId) async {
    final response = await http.delete(Uri.parse('$baseLink/medicines/$medicineId'));

    if (response.statusCode != 204) {
      throw Exception('Failed to delete medicine');
    }
  }

  Future<Map<String, dynamic>> getAllRecommendations(String baseLink, String token) async {
    final url = Uri.parse('$baseLink/recommendations');
    final headers = {
      "Authorization": "Bearer $token",
      "Content-Type": "application/json"
    };

    final response = await http.get(url, headers: headers);
    return json.decode(response.body);
  }

  Future<Map<String, dynamic>> getRecommendationById(String baseLink, String token, String recommendationId) async {
    final url = Uri.parse('$baseLink/recommendations/$recommendationId');
    final headers = {
      "Authorization": "Bearer $token",
      "Content-Type": "application/json"
    };

    final response = await http.get(url, headers: headers);
    return json.decode(response.body);
  }

  Future<Map<String, dynamic>> createRecommendation(String baseLink, String token, String dosage, int medicineId, int patientId, int doctorId) async {
    final url = Uri.parse('$baseLink/recommendations');
    final headers = {
      "Authorization": "Bearer $token",
      "Content-Type": "application/json"
    };
    final payload = json.encode({
      "dosage": dosage,
      "medicineId": medicineId,
      "patientId": patientId,
      "doctorId": doctorId
    });

    final response = await http.post(url, headers: headers, body: payload);
    return json.decode(response.body);
  }

  Future<Map<String, dynamic>> updateRecommendation(String baseLink, String token, String recommendationId, String dosage, int medicineId, int patientId, int doctorId) async {
    final url = Uri.parse('$baseLink/recommendations/$recommendationId');
    final headers = {
      "Authorization": "Bearer $token",
      "Content-Type": "application/json"
    };
    final payload = json.encode({
      "dosage": dosage,
      "medicineId": medicineId,
      "patientId": patientId,
      "doctorId": doctorId
    });

    final response = await http.put(url, headers: headers, body: payload);
    return json.decode(response.body);
  }

  Future<Map<String, dynamic>> deleteRecommendation(String baseLink, String token, String recommendationId) async {
    final url = Uri.parse('$baseLink/recommendations/$recommendationId');
    final headers = {
      "Authorization": "Bearer $token"
    };

    final response = await http.delete(url, headers: headers);
    return json.decode(response.body);
  }

  Future<Map<String, dynamic>> getAllTestOffers(String baseLink, String token) async {
    final url = Uri.parse('$baseLink/test-offers');
    final headers = {
      "Authorization": "Bearer $token",
      "Content-Type": "application/json"
    };

    final response = await http.get(url, headers: headers);
    return json.decode(response.body);
  }

  Future<Map<String, dynamic>> getTestOfferById(String baseLink, String token, String id) async {
    final url = Uri.parse('$baseLink/test-offers/$id');
    final headers = {
      "Authorization": "Bearer $token",
      "Content-Type": "application/json"
    };

    final response = await http.get(url, headers: headers);
    return json.decode(response.body);
  }

  Future<Map<String, dynamic>> getTestOfferByLab(String baseLink, String token, String labId) async {
    final url = Uri.parse('$baseLink/test-offers/laboffer/$labId');
    final headers = {
      "Authorization": "Bearer $token",
      "Content-Type": "application/json"
    };

    final response = await http.get(url, headers: headers);
    return json.decode(response.body);
  }

  Future<Map<String, dynamic>> createTestOffer(String baseLink, String token, String testId, String methodId) async {
    final url = Uri.parse('$baseLink/test-offers');
    final headers = {
      "Authorization": "Bearer $token",
      "Content-Type": "application/json"
    };
    final payload = json.encode({
      "testId": testId,
      "methodId": methodId
    });

    final response = await http.post(url, headers: headers, body: payload);
    return json.decode(response.body);
  }

  Future<Map<String, dynamic>> updateTestOffer(String baseLink, String token, String id, String testId, String methodId) async {
    final url = Uri.parse('$baseLink/test-offers/$id');
    final headers = {
      "Authorization": "Bearer $token",
      "Content-Type": "application/json"
    };
    final payload = json.encode({
      "testId": testId,
      "methodId": methodId
    });

    final response = await http.put(url, headers: headers, body: payload);
    return json.decode(response.body);
  }

  Future<Map<String, dynamic>> deleteTestOffer(String baseLink, String token, String id) async {
    final url = Uri.parse('$baseLink/test-offers/$id');
    final headers = {
      "Authorization": "Bearer $token",
      "Content-Type": "application/json"
    };

    final response = await http.delete(url, headers: headers);
    return json.decode(response.body);
  }

  Future<Map<String, dynamic>> createTest(String baseLink, String token, String name, String testOfferPayload) async {
    final url = Uri.parse('$baseLink/tests');
    final headers = {
      "Authorization": "Bearer $token",
      "Content-Type": "application/json"
    };
    final payload = json.encode({
      "name": name,
      "testOffer": testOfferPayload
    });

    final response = await http.post(url, headers: headers, body: payload);
    return json.decode(response.body);
  }

// Function to handle the "Get SingleTestReport of patient" endpoint
  Future<void> getSingleTestReportOfPatient() async {
    final String token = "SD21rfjuBdOXSlbbOm0ee52UXnz2";
    final String baseLink = "{{baseLink}}";
    final String testOfferId = "2";
    final String patientId = "1";

    final response = await http.get(
      Uri.parse('$baseLink/tests/testreport/$testOfferId/$patientId'),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      },
    );

    if (response.statusCode == 200) {
      // Handle successful response
      print('Single Test Report of Patient: ${response.body}');
    } else {
      // Handle error response
      print('Failed to fetch Single Test Report of Patient: ${response.statusCode}');
    }
  }

// Function to handle the "Update Test" endpoint
  Future<void> updateTest() async {
    final String token = "SD21rfjuBdOXSlbbOm0ee52UXnz2";
    final String baseLink = "{{baseLink}}";
    final String id = "1"; // Replace with the actual ID

    final response = await http.put(
      Uri.parse('$baseLink/tests/$id'),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      },
      body: jsonEncode({
        "name": "Updated Test Name",
        "testOffer": [
          {
            "id": 1,
            "methodId": 1,
            "LabOffer": [
              {"id": 1, "labId": 1}
            ],
            "testReportField": [
              {
                "id": 1,
                "title": "Updated Report Field 1",
                "testNormalRanges": [
                  {"id": 1, "gender": "Male", "min": 0, "max": 100, "ageMin": 20, "ageMax": 30}
                ]
              }
            ]
          }
        ]
      }),
    );

    if (response.statusCode == 200) {
      // Handle successful response
      print('Test Updated Successfully');
    } else {
      // Handle error response
      print('Failed to update Test: ${response.statusCode}');
    }
  }

// Function to handle the "Delete Test" endpoint
  Future<void> deleteTest() async {
    final String token = "SD21rfjuBdOXSlbbOm0ee52UXnz2";
    final String baseLink = "{{baseLink}}";
    final String id = "1"; // Replace with the actual ID

    final response = await http.delete(
      Uri.parse('$baseLink/tests/$id'),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      },
    );

    if (response.statusCode == 200) {
      // Handle successful response
      print('Test Deleted Successfully');
    } else {
      // Handle error response
      print('Failed to delete Test: ${response.statusCode}');
    }
  }

// Function to handle the "Get All Test Reports by patientID" endpoint
  Future<void> getAllTestReportsByPatientId() async {
    final String token = "SD21rfjuBdOXSlbbOm0ee52UXnz2";
    final String baseLink = "{{baseLink}}";
    final String patientId = "1";

    final response = await http.get(
      Uri.parse('$baseLink/tests/testreport/$patientId'),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      },
    );

    if (response.statusCode == 200) {
      // Handle successful response
      print('All Test Reports by Patient ID: ${response.body}');
    } else {
      // Handle error response
      print('Failed to fetch Test Reports by Patient ID: ${response.statusCode}');
    }
  }

// Function to handle the "Create Vitals" endpoint
  Future<void> createVitals() async {
    final String token = "SD21rfjuBdOXSlbbOm0ee52UXnz2";
    final String baseLink = "{{baseLink}}";

    final response = await http.post(
      Uri.parse('$baseLink/vitals'),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      },
      body: jsonEncode({
        "name": "Blood Pressure",
        "vitalsValueRanges": [
          {"gender": "Male", "min": 90, "max": 120, "ageMin": 20, "ageMax": 30},
          {"gender": "Female", "min": 85, "max": 110, "ageMin": 20, "ageMax": 30},
          {"gender": "Male", "min": 95, "max": 130, "ageMin": 31, "ageMax": 40},
          {"gender": "Female", "min": 90, "max": 120, "ageMin": 31, "ageMax": 40}
        ]
      }),
    );

    if (response.statusCode == 200) {
      // Handle successful response
      print('Vitals Created Successfully');
    } else {
      // Handle error response
      print('Failed to create Vitals: ${response.statusCode}');
    }
  }

// Function to handle the "Get All Vitals of patient" endpoint
  Future<void> getAllVitalsOfPatient() async {
    final String token = "SD21rfjuBdOXSlbbOm0ee52UXnz2";
    final String baseLink = "{{baseLink}}";
    final String patientId = "1";

    final response = await http.get(
      Uri.parse('$baseLink/vitals/$patientId?fromDate=2022-01-22T02:40:07.392Z&toDate=2024-01-22T02:40:07.392Z'),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      },
    );

    if (response.statusCode == 200) {
      // Handle successful response
      print('All Vitals of Patient: ${response.body}');
    } else {
      // Handle error response
      print('Failed to fetch Vitals of Patient: ${response.statusCode}');
    }
  }

// Function to handle the "Get Vitals by ID" endpoint
  Future<void> getVitalsById() async {
    final String token = "SD21rfjuBdOXSlbbOm0ee52UXnz2";
    final String baseLink = "{{baseLink}}";
    final String vitalsId = "1";

    final response = await http.get(
      Uri.parse('$baseLink/vitals/$vitalsId'),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      },
    );

    if (response.statusCode == 200) {
      // Handle successful response
      print('Vitals by ID: ${response.body}');
    } else {
      // Handle error response
      print('Failed to fetch Vitals by ID: ${response.statusCode}');
    }
  }

// Function to handle the "Update Vitals" endpoint
  Future<void> updateVitals() async {
    final String token = "SD21rfjuBdOXSlbbOm0ee52UXnz2";
    final String baseLink = "{{baseLink}}";
    final String vitalsId = "1"; // Replace with the actual ID

    final response = await http.put(
      Uri.parse('$baseLink/vitals/$vitalsId'),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      },
      body: jsonEncode({
        "name": "Updated Vitals Name",
        "vitalsValueRanges": [
          {"id": 1, "gender": "Male", "min": 0, "max": 100, "ageMin": 20, "ageMax": 30}
        ]
      }),
    );

    if (response.statusCode == 200) {
      // Handle successful response
      print('Vitals Updated Successfully');
    } else {
      // Handle error response
      print('Failed to update Vitals: ${response.statusCode}');
    }
  }

// Function to handle the "Delete Vitals" endpoint
  Future<void> deleteVitals() async {
    final String token = "SD21rfjuBdOXSlbbOm0ee52UXnz2";
    final String baseLink = "{{baseLink}}";
    final String vitalsId = "1"; // Replace with the actual ID

    final response = await http.delete(
      Uri.parse('$baseLink/vitals/$vitalsId'),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      },
    );

    if (response.statusCode == 200) {
      // Handle successful response
      print('Vitals Deleted Successfully');
    } else {
      // Handle error response
      print('Failed to delete Vitals: ${response.statusCode}');
    }
  }

// Function to handle the "Vital Names" endpoint
  Future<void> getVitalNames() async {
    final String token = "SD21rfjuBdOXSlbbOm0ee52UXnz2";
    final String baseLink = "{{baseLink}}";

    final response = await http.get(
      Uri.parse('$baseLink/vitals/vital/names'),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      },
    );

    if (response.statusCode == 200) {
      // Handle successful response
      print('Vital Names: ${response.body}');
    } else {
      // Handle error response
      print('Failed to fetch Vital Names: ${response.statusCode}');
    }
  }

// Function to handle the "Create Measure" endpoint
  Future<void> createMeasure() async {
    final String token = "SD21rfjuBdOXSlbbOm0ee52UXnz2";
    final String baseLink = "{{baseLink}}";

    final response = await http.post(
      Uri.parse('$baseLink/measures'),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      },
      body: jsonEncode({
        "patientId": 1,
        "vitalsId": 2,
        "vitalObservedValues": [{"readingType": "Fahrenheit", "observedValue": 90}]
      }),
    );

    if (response.statusCode == 200) {
      // Handle successful response
      print('Measure Created Successfully');
    } else {
      // Handle error response
      print('Failed to create Measure: ${response.statusCode}');
    }
  }


// Function to handle the "Get All Measures of patient" endpoint
  Future<void> getAllMeasuresOfPatient() async {
    final String token = "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpZCI6NCwicm9sZSI6InBhdGllbnQiLCJpYXQiOjE3MDU4OTAwNjcsImV4cCI6MTcwNTg5MzY2N30.wIcaxoT15SQJM-ghRiqinVnAKnRgwRiqEgLvEUvYzDI";
    final String baseLink = "localhost:3000";
    final String patientId = "1";

    final response = await http.get(
      Uri.parse('$baseLink/measures/patient/$patientId'),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      },
    );

    if (response.statusCode == 200) {
      // Handle successful response
      print('All Measures of Patient: ${response.body}');
    } else {
      // Handle error response
      print('Failed to fetch Measures of Patient: ${response.statusCode}');
    }
  }

// Function to handle the "Get Measure by ID" endpoint
  Future<void> getMeasureById() async {
    final String token = "SD21rfjuBdOXSlbbOm0ee52UXnz2";
    final String baseLink = "localhost:3000";
    final String measureId = "1";

    final response = await http.get(
      Uri.parse('$baseLink/measures/$measureId'),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      },
    );

    if (response.statusCode == 200) {
      // Handle successful response
      print('Measure by ID: ${response.body}');
    } else {
      // Handle error response
      print('Failed to fetch Measure by ID: ${response.statusCode}');
    }
  }

// Function to handle the "Update Measure" endpoint
  Future<void> updateMeasure() async {
    final String token = "SD21rfjuBdOXSlbbOm0ee52UXnz2";
    final String baseLink = "localhost:3000";
    final String measureId = "1"; // Replace with the actual ID

    final response = await http.put(
      Uri.parse('$baseLink/measures/$measureId'),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      },
      body: jsonEncode({
        "patientId": 1,
        "vitalsId": 2
      }),
    );

    if (response.statusCode == 200) {
      // Handle successful response
      print('Measure Updated Successfully');
    } else {
      // Handle error response
      print('Failed to update Measure: ${response.statusCode}');
    }
  }

// Function to handle the "Delete Measure" endpoint
  Future<void> deleteMeasure() async {
    final String token = "SD21rfjuBdOXSlbbOm0ee52UXnz2";
    final String baseLink = "localhost:3000";
    final String measureId = "1"; // Replace with the actual ID

    final response = await http.delete(
      Uri.parse('$baseLink/measures/$measureId'),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      },
    );

    if (response.statusCode == 200) {
      // Handle successful response
      print('Measure Deleted Successfully');
    } else {
      // Handle error response
      print('Failed to delete Measure: ${response.statusCode}');
    }
  }

// Endpoint: Create Observed Values
  Future<void> createObservedValues(String baseURL, String token, Map<String, dynamic> data) async {
    final response = await http.post(
      Uri.parse('$baseURL/create-observed-values'),
      headers: {'Authorization': 'Bearer $token', 'Content-Type': 'application/json'},
      body: jsonEncode(data),
    );
    if (response.statusCode == 201) {
      // Handle success
    } else {
      // Handle error
      throw Exception('Failed to create observed values');
    }
  }

// Endpoint: Get All Shares
  Future<List<dynamic>> getAllShares(String baseURL, String token) async {
    final response = await http.get(Uri.parse('$baseURL/get-all-shares'), headers: {'Authorization': 'Bearer $token'});
    if (response.statusCode == 200) {
      return jsonDecode(response.body);
    } else {
      // Handle error
      throw Exception('Failed to get all shares');
    }
  }

// Endpoint: Get Share By ID
  Future<Map<String, dynamic>> getShareById(String baseURL, String token, String id) async {
    final response = await http.get(Uri.parse('$baseURL/get-share-by-id/$id'), headers: {'Authorization': 'Bearer $token'});
    if (response.statusCode == 200) {
      return jsonDecode(response.body);
    } else {
      // Handle error
      throw Exception('Failed to get share by ID');
    }
  }

// Endpoint: Create Share
  Future<void> createShare(String baseURL, String token, Map<String, dynamic> data) async {
    final response = await http.post(
      Uri.parse('$baseURL/create-share'),
      headers: {'Authorization': 'Bearer $token', 'Content-Type': 'application/json'},
      body: jsonEncode(data),
    );
    if (response.statusCode == 201) {
      // Handle success
    } else {
      // Handle error
      throw Exception('Failed to create share');
    }
  }

// Endpoint: Update Share
  Future<void> updateShare(String baseURL, String token, String id, Map<String, dynamic> data) async {
    final response = await http.put(
      Uri.parse('$baseURL/update-share/$id'),
      headers: {'Authorization': 'Bearer $token', 'Content-Type': 'application/json'},
      body: jsonEncode(data),
    );
    if (response.statusCode == 200) {
      // Handle success
    } else {
      // Handle error
      throw Exception('Failed to update share');
    }
  }

// Endpoint: Delete Share
  Future<void> deleteShare(String baseURL, String token, String id) async {
    final response = await http.delete(Uri.parse('$baseURL/delete-share/$id'), headers: {'Authorization': 'Bearer $token'});
    if (response.statusCode == 200) {
      // Handle success
    } else {
      // Handle error
      throw Exception('Failed to delete share');
    }
  }

// Endpoint: Get ShareDetails By ID
  Future<Map<String, dynamic>> getShareDetailsById(String baseURL, String token, String id) async {
    final response = await http.get(Uri.parse('$baseURL/get-share-details-by-id/$id'), headers: {'Authorization': 'Bearer $token'});
    if (response.statusCode == 200) {
      return jsonDecode(response.body);
    } else {
      // Handle error
      throw Exception('Failed to get share details by ID');
    }
  }

// Endpoint: Update ShareDetails
  Future<void> updateShareDetails(String baseURL, String token, String id, Map<String, dynamic> data) async {
    final response = await http.put(
      Uri.parse('$baseURL/update-share-details/$id'),
      headers: {'Authorization': 'Bearer $token', 'Content-Type': 'application/json'},
      body: jsonEncode(data),
    );
    if (response.statusCode == 200) {
      // Handle success
    } else {
      // Handle error
      throw Exception('Failed to update share details');
    }
  }

// Endpoint: Delete ShareDetails
  Future<void> deleteShareDetails(String baseURL, String token, String id) async {
    final response = await http.delete(Uri.parse('$baseURL/delete-share-details/$id'), headers: {'Authorization': 'Bearer $token'});
    if (response.statusCode == 200) {
      // Handle success
    } else {
      // Handle error
      throw Exception('Failed to delete share details');
    }
  }

// Endpoint: Update Vital Value Range
  Future<void> updateVitalValueRange(String baseURL, String token, String id, Map<String, dynamic> data) async {
    final response = await http.put(
      Uri.parse('$baseURL/update-vital-value-range/$id'),
      headers: {'Authorization': 'Bearer $token', 'Content-Type': 'application/json'},
      body: jsonEncode(data),
    );
    if (response.statusCode == 200) {
      // Handle success
    } else {
      // Handle error
      throw Exception('Failed to update vital value range');
    }
  }

// Endpoint: Get Vital Value Range by ID
  Future<Map<String, dynamic>> getVitalValueRangeById(String baseURL, String token, String id) async {
    final response = await http.get(Uri.parse('$baseURL/get-vital-value-range-by-id/$id'), headers: {'Authorization': 'Bearer $token'});
    if (response.statusCode == 200) {
      return jsonDecode(response.body);
    } else {
      // Handle error
      throw Exception('Failed to get vital value range by ID');
    }
  }

// Endpoint: Get All Vital Value Ranges
  Future<List<dynamic>> getAllVitalValueRanges(String baseURL, String token) async {
    final response = await http.get(Uri.parse('$baseURL/get-all-vital-value-ranges'), headers: {'Authorization': 'Bearer $token'});
    if (response.statusCode == 200) {
      return jsonDecode(response.body);
    } else {
      // Handle error
      throw Exception('Failed to get all vital value ranges');
    }
  }

// Endpoint: Delete Vital Value Range
  Future<void> deleteVitalValueRange(String baseURL, String token, String id) async {
    final response = await http.delete(Uri.parse('$baseURL/delete-vital-value-range/$id'), headers: {'Authorization': 'Bearer $token'});
    if (response.statusCode == 200) {
      // Handle success
    } else {
      // Handle error
      throw Exception('Failed to delete vital value range');
    }
  }

// Endpoint: Get All Tests
  Future<List<dynamic>> getAllTests(String baseURL, String token) async {
    final response = await http.get(Uri.parse('$baseURL/get-all-tests'), headers: {'Authorization': 'Bearer $token'});
    if (response.statusCode == 200) {
      return jsonDecode(response.body);
    } else {
      // Handle error
      throw Exception('Failed to get all tests');
    }
  }

// Endpoint: Get Test by ID
  Future<Map<String, dynamic>> getTestById(String baseURL, String token, String id) async {
    final response = await http.get(Uri.parse('$baseURL/get-test-by-id/$id'), headers: {'Authorization': 'Bearer $token'});
    if (response.statusCode == 200) {
      return jsonDecode(response.body);
    } else {
      // Handle error
      throw Exception('Failed to get test by ID');
    }
  }

// Add more methods for other endpoints as needed
}
