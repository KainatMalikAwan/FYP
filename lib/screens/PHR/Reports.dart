import 'dart:io';
import 'package:flutter/material.dart';
import 'package:fyp/screens/PHR/OCR.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Medical Screen',
      theme: ThemeData(
        primaryColor: Color(0xFF199A8E),
        colorScheme: ColorScheme.fromSwatch().copyWith(secondary: Color(0xFF199A8E)),
      ),
      home: MedicalScreen(),
    );
  }
}

class MedicalScreen extends StatefulWidget {
  @override
  _MedicalScreenState createState() => _MedicalScreenState();
}

class _MedicalScreenState extends State<MedicalScreen> {
  String selectedLab = 'Twin City';
  String selectedAge = 'Select Age';
  String selectedGender = 'Select Gender';
  String selectedMethod = 'Select Method';
  String selectedSliderButton = 'Blood CP';

  void _openImagePickerScreen() {
    Navigator.of(context).push(
      MaterialPageRoute(builder: (context) => ImagePickerScreen()),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        automaticallyImplyLeading: false, // Remove back arrow
        title: Container(), // Empty title
        backgroundColor: Color(0xFF199A8E),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  DropdownButton<String>(
                    value: selectedLab,
                    items: ['Twin City', 'Primix', 'Diagnosis Center']
                        .map((String value) {
                      return DropdownMenuItem<String>(
                        value: value,
                        child: Text(value, style: TextStyle(fontSize: 14, color: Color(0xFF199A8E))),
                      );
                    }).toList(),
                    onChanged: (String? newValue) {
                      setState(() {
                        selectedLab = newValue!;
                      });
                    },
                    style: TextStyle(color: Color(0xFF199A8E)),
                    dropdownColor: Colors.white,
                    iconEnabledColor: Color(0xFF199A8E),
                    underline: Container(
                      height: 2,
                      color: Color(0xFF199A8E),
                    ),
                  ),
                  GestureDetector(
                    onTap: _openImagePickerScreen,
                    child: Row(
                      children: [
                        Icon(Icons.camera_alt, color: Color(0xFF199A8E)),
                        SizedBox(width: 5),
                        Text(
                          'Scan',
                          style: TextStyle(
                            color: Color(0xFF199A8E),
                            fontSize: 16,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              SizedBox(height: 20),
              SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Row(
                  children: [
                    _buildSliderButton('Blood CP'),
                    _buildSliderButton('KFT'),
                    _buildSliderButton('LFT'),
                    _buildSliderButton('New'),
                  ],
                ),
              ),
              SizedBox(height: 20),
              SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _buildDropdownWithHeading('Age', ['Select Age', '0-18', '19-35', '36-60', '60+']),
                    SizedBox(width: 20),
                    _buildDropdownWithHeading('Gender', ['Select Gender', 'Male', 'Female', 'Other']),
                    SizedBox(width: 20),
                    _buildDropdownWithHeading('Method', ['Select Method', 'Method 1', 'Method 2', 'Method 3']),
                  ],
                ),
              ),
              SizedBox(height: 20),
              if (selectedSliderButton == 'Blood CP') ...[
                _buildTextFieldWithLabel('Red Blood Cell Count (RBC)', 'Range: 4.7-6.1 million cells/mcL'),
                _buildTextFieldWithLabel('Hemoglobin', 'Range: 13.8-17.2 grams/dL'),
                _buildTextFieldWithLabel('Hematocrit', 'Range: 41-50%'),
                _buildTextFieldWithLabel('Mean Corpuscular Volume (MCV)', 'Range: 80-100 femtoliters (fL)'),
                _buildTextFieldWithLabel('Mean Corpuscular Hemoglobin (MCH)', 'Range: 27-32 picograms (pg)'),
                _buildTextFieldWithLabel('Mean Corpuscular Hemoglobin Concentration (MCHC)', 'Range: 32-36 grams/deciliter (g/dL)'),
                _buildTextFieldWithLabel('Red Cell Distribution Width (RDW)', 'Range: 11.5-14.5%'),
                _buildTextFieldWithLabel('Platelet Count', 'Range: 150-400 thousand cells/mcL'),
                _buildTextFieldWithLabel('Mean Platelet Volume (MPV)', 'Range: 7.2-11.1 femtoliters (fL)'),
                _buildTextFieldWithLabel('White Blood Cell Count (WBC)', 'Range: 4.5-11 thousand cells/mcL'),
              ] else if (selectedSliderButton == 'KFT') ...[
                _buildTextFieldWithLabel('Creatinine', 'Range: 0.6-1.2 mg/dL'),
                _buildTextFieldWithLabel('Blood Urea Nitrogen (BUN)', 'Range: 7-20 mg/dL'),
              ] else if (selectedSliderButton == 'LFT') ...[
                _buildTextFieldWithLabel('Bilirubin', 'Range: 0.1-1.2 mg/dL'),
                _buildTextFieldWithLabel('Alanine Aminotransferase (ALT)', 'Range: 7-56 U/L'),
              ] else if (selectedSliderButton == 'New') ...[
                _buildTextFieldWithLabel('New Test 1', 'Range: value range'),
                _buildTextFieldWithLabel('New Test 2', 'Range: value range'),
              ],
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSliderButton(String title) {
    bool isSelected = selectedSliderButton == title;
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8.0),
      child: ElevatedButton(
        onPressed: () {
          setState(() {
            selectedSliderButton = title;
          });
        },
        style: ElevatedButton.styleFrom(
          primary: isSelected ? Color(0xFF199A8E) : Colors.grey,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
        ),
        child: Text(title, style: TextStyle(color: Colors.white, fontSize: 14)),
      ),
    );
  }

  Widget _buildDropdownWithHeading(String heading, List<String> items) {
    String selectedItem = items[0];
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          heading,
          style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
        ),
        SizedBox(height: 5),
        Container(
          width: 120,
          height: 30,
          padding: EdgeInsets.symmetric(horizontal: 10),
          decoration: BoxDecoration(
            border: Border.all(color: Color(0xFF199A8E)),
            borderRadius: BorderRadius.circular(5),
          ),
          child: DropdownButton<String>(
            value: selectedItem,
            isExpanded: true,
            items: items.map((String value) {
              return DropdownMenuItem<String>(
                value: value,
                child: Text(value, style: TextStyle(fontSize: 14, color: Color(0xFF199A8E))),
              );
            }).toList(),
            onChanged: (String? newValue) {
              setState(() {
                selectedItem = newValue!;
              });
            },
            style: TextStyle(color: Color(0xFF199A8E)),
            dropdownColor: Colors.white,
            iconEnabledColor: Color(0xFF199A8E),
            underline: Container(),
          ),
        ),
      ],
    );
  }

  Widget _buildTextFieldWithLabel(String label, String range) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
        ),
        SizedBox(height: 10),
        Text(
          range,
          style: TextStyle(fontSize: 14, color: Colors.grey),
        ),
        SizedBox(height: 10),
        Row(
          children: [
            Expanded(
              child: TextField(
                decoration: InputDecoration(
                  border: OutlineInputBorder(),
                  labelText: 'Enter value',
                  labelStyle: TextStyle(color: Color(0xFF199A8E)),
                  focusedBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: Color(0xFF199A8E)),
                  ),
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }
}
