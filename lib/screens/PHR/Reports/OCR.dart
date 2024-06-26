import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:fyp/Services/API/PHR/ReportsServices.dart'; // Adjust the path as per your project structure
import 'package:fyp/models/PHR/Reports/Lab.dart'; // Adjust the path as per your project structure
import 'package:fyp/models/PHR/Reports/LabTestOffer.dart'; // Adjust the path as per your project structure
import '../../../Services/config.dart';
import '../../../ThemeSettings/ThemeSettings.dart'; // Adjust the path as per your project structure

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Lab Dropdown',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        textButtonTheme: TextButtonThemeData(
          style: TextButton.styleFrom(
            primary: ThemeSettings.buttonTextColor,
            backgroundColor: ThemeSettings.buttonColor,
          ),
        ),
      ),
      home:OCRScreen(),
    );
  }
}

class OCRScreen extends StatefulWidget {
  @override
  _OCRState createState() => _OCRState();
}

class _OCRState extends State<OCRScreen> {
  List<Lab> _labs = [];
  Lab? _selectedLab;
  List<LabTestOffer> _labTestOffers = [];
  bool _loadingLabs = true;
  bool _errorLoadingLabs = false;
  File? _selectedImage;
  LabTestOffer? _selectedTestOffer;

  @override
  void initState() {
    super.initState();
    fetchLabs();
  }

  Future<void> fetchLabs() async {
    try {
      List<Lab> labs = await ReportsService().fetchLabs();
      setState(() {
        _labs = labs;
        if (_labs.isEmpty) {
          _errorLoadingLabs = true;
        } else {
          _selectedLab = _labs.first;
          fetchTestOffers(_selectedLab!.id);
        }
        _loadingLabs = false;
      });
    } catch (e) {
      print('Failed to load labs: $e');
      setState(() {
        _loadingLabs = false;
        _errorLoadingLabs = true;
      });
    }
  }

  Future<void> fetchTestOffers(int labId) async {
    try {
      List<LabTestOffer> testOffers =
      await ReportsService().fetchTestOffersByLabId(labId);
      setState(() {
        _labTestOffers = testOffers;
        // Reset selected test offer when fetching new offers
        _selectedTestOffer = null;
      });
    } catch (e) {
      print('Failed to load test offers: $e');
    }
  }

  Future<void> _pickImage() async {
    final pickedImage = await ImagePicker().getImage(
      source: ImageSource.gallery,
    );
    if (pickedImage != null) {
      setState(() {
        _selectedImage = File(pickedImage.path);
      });
    }
  }

  void _saveSelectedTestOffer(LabTestOffer offer) async {
    setState(() {
      _selectedTestOffer = offer;
    });

    // Open image picker after selecting test offer
    await _pickImage();

    // Print test offer ID after selecting image
    if (_selectedImage != null && _selectedTestOffer != null) {
      print('Selected Image: $_selectedImage');
      print('Test Offer ID: ${_selectedTestOffer!.testOfferId}');
    } else {
      print('Please select an image and a test offer.');
    }
  }

  Future<void> _submitReportFormData({
    required int labOfferId,
    required int patientId,
    required File testImage,
  }) async {
    try {
      var request = http.MultipartRequest(
        'POST',
        Uri.parse('${Config.baseUrl}/tests/scan'),
      );

      // Add form fields
      request.fields['labOfferId'] = labOfferId.toString();
      request.fields['patientId'] = patientId.toString();

      // Add image file
      var imageStream = http.ByteStream(testImage.openRead());
      var length = await testImage.length();
      var multipartFile = http.MultipartFile(
        'testImage',
        imageStream,
        length,
        filename: testImage.path.split('/').last,
      );
      request.files.add(multipartFile);

      // Send request
      var response = await http.Response.fromStream(await request.send());

      if (response.statusCode == 200) {
        print('Report submitted successfully.');
      } else {
        print('Failed to submit report. Status code: ${response.statusCode}');
      }
    } catch (e) {
      print('Error submitting report: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Select Lab and Test'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(height: 20),
            _loadingLabs
                ? Center(child: CircularProgressIndicator())
                : _errorLoadingLabs
                ? Text(
              'Failed to load labs',
              style: TextStyle(color: Colors.red),
            )
                : DropdownButtonFormField<Lab>(
              isExpanded: true,
              decoration: InputDecoration(
                filled: true,
                fillColor: ThemeSettings.bgcolor,
                contentPadding: EdgeInsets.symmetric(
                    horizontal: 10, vertical: 5),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10.0),
                  borderSide: BorderSide(color: Colors.grey),
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10.0),
                  borderSide: BorderSide(color: Colors.grey),
                ),
              ),
              hint: Text('Select Lab'),
              value: _selectedLab,
              onChanged: (Lab? newValue) {
                setState(() {
                  _selectedLab = newValue;
                  if (newValue != null) {
                    fetchTestOffers(newValue.id);
                    print('Selected Lab ID: ${newValue.id}');
                  }
                });
              },
              items: _labs.map((lab) {
                return DropdownMenuItem<Lab>(
                  value: lab,
                  child: Text(
                    lab.name,
                    style:
                    TextStyle(color: ThemeSettings.labelColor),
                  ),
                );
              }).toList(),
            ),
            SizedBox(height: 20),
            _labTestOffers.isEmpty
                ? Center(
              child: Text('No tests available for the selected lab'),
            )
                : SizedBox(
              height: 60,
              child: ListView(
                scrollDirection: Axis.horizontal,
                children: _labTestOffers.map((offer) {
                  return Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 8.0),
                    child: TextButton(
                      onPressed: () => _saveSelectedTestOffer(offer),
                      style: ButtonStyle(
                        backgroundColor: MaterialStateProperty.all<Color>(
                            ThemeSettings.buttonColor),
                        foregroundColor: MaterialStateProperty.all<Color>(
                            ThemeSettings.buttonTextColor),
                        minimumSize: MaterialStateProperty.all<Size>(
                            Size.fromWidth(
                                100)), // Adjust as needed
                        padding: MaterialStateProperty.all<EdgeInsets>(
                          EdgeInsets.symmetric(
                              horizontal: 12, vertical: 8),
                        ),
                        shape: MaterialStateProperty.all<
                            RoundedRectangleBorder>(
                          RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8.0),
                          ),
                        ),
                      ),
                      child: Text(
                        offer.testName,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                            fontSize:
                            12), // Adjust the font size as needed
                      ),
                    ),
                  );
                }).toList(),
              ),
            ),
            SizedBox(height: 20),
            _selectedImage != null
                ? Padding(
              padding: const EdgeInsets.symmetric(vertical: 16.0),
              child: Center(
                child: Image.file(
                  _selectedImage!,
                  height: 100,
                  width: 100,
                  fit: BoxFit.cover,
                ),
              ),
            )
                : Container(),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                print(_selectedTestOffer!.testOfferId,);
                if (_selectedTestOffer != null && _selectedImage != null) {
                  _submitReportFormData(
                    labOfferId: _selectedTestOffer!.testOfferId,
                    patientId: 1, // Replace with actual patient ID
                    testImage: _selectedImage!,
                  );
                } else {
                  print('Please select a test offer and an image.');
                }
              },
              style: ButtonStyle(
                backgroundColor:
                MaterialStateProperty.all<Color>(ThemeSettings.labelColor),
                foregroundColor: MaterialStateProperty.all<Color>(
                    ThemeSettings.buttonTextColor),
                padding: MaterialStateProperty.all<EdgeInsets>(
                    EdgeInsets.symmetric(horizontal: 16, vertical: 12)),
              ),
              child: Text('Submit'),
            ),
          ],
        ),
      ),
    );
  }
}

Future<void> submitReportFormData({
    required int labOfferId,
    required int patientId,
    required File testImage,
  }) async {
    try {
      // Create multipart request for sending image and form data
      var request = http.MultipartRequest('POST', Uri.parse('${Config.baseUrl}/your-endpoint-path'));

      // Add form fields
      request.fields['labOfferId'] = labOfferId.toString();
      request.fields['patientId'] = patientId.toString();

      // Add image file
      var imageStream = http.ByteStream(testImage.openRead());
      var length = await testImage.length();
      var multipartFile = http.MultipartFile(
        'testImage',
        imageStream,
        length,
        filename: testImage.path.split('/').last,
      );
      request.files.add(multipartFile);

      // Send request
      var streamedResponse = await request.send();
      var response = await http.Response.fromStream(streamedResponse);

      if (response.statusCode == 200) {
        print('Report submitted successfully.');
      } else {
        print('Failed to submit report. Status code: ${response.statusCode}');
      }
    } catch (e) {
      print('Error submitting report: $e');
    }
  }

